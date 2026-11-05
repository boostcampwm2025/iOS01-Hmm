# Firestore 에뮬레이터 환경 기반 InviteService 통합 테스트 모듈
from __future__ import annotations

import os
import threading
from uuid import uuid4

import pytest
from google.auth.credentials import AnonymousCredentials
from google.cloud import firestore as google_firestore

os.environ.setdefault("FIRESTORE_EMULATOR_HOST", "localhost:8080")
os.environ.setdefault("GCLOUD_PROJECT", "solodevelopertraining")
os.environ.setdefault("GOOGLE_CLOUD_PROJECT", "solodevelopertraining")

from invite.constants import (  # noqa: E402
    COLLECTION_INVITATIONS,
    COLLECTION_INVITE_CODES,
    COLLECTION_USERS,
    MAX_DAILY_ATTEMPTS,
    STATUS_PENDING,
)
from invite.errors import (  # noqa: E402
    AlreadyAppliedError,
    DailyAttemptLimitError,
    ForbiddenRewardError,
    InvalidInviteCodeError,
    InviteCodeNotFoundError,
    NicknameRequiredError,
    OwnInviteCodeError,
    RewardAlreadyClaimedError,
    RewardNotFoundError,
    UnauthenticatedError,
)
from invite.services import InviteService, grant_id_for  # noqa: E402

WALLET_KEYS = {"diamond", "diamonds", "gold", "wallet", "balance", "amount"}


# Firestore 에뮬레이터 포트 연결 가능 여부를 확인하는 헬퍼 함수
def _emulator_available() -> bool:
    host = os.environ.get("FIRESTORE_EMULATOR_HOST")
    if not host:
        return False
    import socket

    hostname, port_text = host.split(":")
    try:
        with socket.create_connection((hostname, int(port_text)), timeout=1):
            return True
    except OSError:
        return False


# 테스트용 Firestore 클라이언트 인스턴스를 제공하는 pytest fixture
@pytest.fixture(scope="module")
def db():
    if not _emulator_available():
        pytest.fail(
            "Firestore emulator is not running. "
            "Run ./functions/run_tests.sh from the repository root."
        )
    return google_firestore.Client(
        project=os.environ["GCLOUD_PROJECT"],
        credentials=AnonymousCredentials(),
    )


# 테스트용 InviteService 인스턴스를 제공하는 pytest fixture
@pytest.fixture
def service(db):
    return InviteService(db)


# 테스트에서 사용할 고유한 사용자 UID 문자열을 생성하는 헬퍼 함수
def _uid(prefix: str) -> str:
    return f"{prefix}_{uuid4().hex[:10]}"


# 초대 코드 최초 발급 및 재요청 시 기존 코드 재사용 동작을 검증하는 테스트
def test_issue_and_reuse_invite_code(service):
    uid = _uid("issuer")
    first = service.initialize_invite_profile(uid, "개발자")
    second = service.initialize_invite_profile(uid)
    assert first["inviteCode"] == second["inviteCode"]
    assert len(first["inviteCode"]) == 6


# 초대 코드 적용 전 닉네임 프로필 저장 요구사항을 검증하는 테스트
def test_nickname_required_profile(service):
    inviter = _uid("inviter")
    invitee = _uid("invitee")
    code = service.initialize_invite_profile(inviter, "초대자")["inviteCode"]

    with pytest.raises(NicknameRequiredError):
        service.apply_invite_code(invitee, code)


# 초대 코드 등록 성공 시 초대 관계 및 초대자/피초대자 보상이 생성되는지 검증하는 테스트
def test_apply_success_creates_invitation_and_grants(service, db):
    inviter = _uid("inviter")
    invitee = _uid("invitee")
    code = service.initialize_invite_profile(inviter)["inviteCode"]
    service.initialize_invite_profile(invitee, "피초대자")
    result = service.apply_invite_code(invitee, code)

    assert set(result) == {"inviteeGrant"}
    assert set(result["inviteeGrant"]) == {"grantId", "role"}
    assert "amount" not in result["inviteeGrant"]

    invitation = db.collection(COLLECTION_INVITATIONS).document(invitee).get()
    assert invitation.exists
    data = invitation.to_dict()
    assert set(data) == {
        "inviterUid",
        "inviteeNickname",
        "inviteCode",
        "inviterRewardStatus",
        "createdAt",
    }
    assert data["inviterUid"] == inviter
    assert data["inviteeNickname"] == "피초대자"
    assert data["inviterRewardStatus"] == STATUS_PENDING
    _assert_no_wallet_fields(data)


# 잘못된 코드, 미존재 코드, 본인 코드 입력 시 발생하는 예외 처리를 검증하는 테스트
def test_invalid_and_missing_and_own_code(service):
    inviter = _uid("own")
    code = service.initialize_invite_profile(inviter)["inviteCode"]

    with pytest.raises(InvalidInviteCodeError):
        service.apply_invite_code(inviter, "ABC10O")
    with pytest.raises(InviteCodeNotFoundError):
        service.apply_invite_code(_uid("missing"), "ABCDEF")
    with pytest.raises(OwnInviteCodeError):
        service.apply_invite_code(inviter, code)


# 동일 코드 재등록 시 멱등성 보장 및 다른 코드 중복 등록 방지를 검증하는 테스트
def test_already_applied_and_idempotent_retry(service):
    inviter = _uid("inviter")
    other = _uid("other")
    invitee = _uid("invitee")
    code = service.initialize_invite_profile(inviter)["inviteCode"]
    other_code = service.initialize_invite_profile(other)["inviteCode"]
    service.initialize_invite_profile(invitee, "피초대자")

    first = service.apply_invite_code(invitee, code)
    replay = service.apply_invite_code(invitee, code)
    assert first["inviteeGrant"]["grantId"] == replay["inviteeGrant"]["grantId"]

    with pytest.raises(AlreadyAppliedError):
        service.apply_invite_code(invitee, other_code)


# 실패 시도를 포함한 일일 최대 시도 횟수 초과 시 차단되는지 검증하는 테스트
def test_daily_attempt_limit_includes_failures(service, db):
    attacker = _uid("attacker")
    for _ in range(MAX_DAILY_ATTEMPTS):
        with pytest.raises(InviteCodeNotFoundError):
            service.apply_invite_code(attacker, "ABCDEF")
    with pytest.raises(DailyAttemptLimitError):
        service.apply_invite_code(attacker, "ABCDEF")
    user_doc = db.collection(COLLECTION_USERS).document(attacker).get()
    assert user_doc.exists
    assert user_doc.to_dict().get("dailyAttemptCount") == MAX_DAILY_ATTEMPTS


# 본인 보상만 수령 가능하며 중복 수령이 방지되는지 검증하는 테스트
def test_claim_is_owner_only_canonical_and_not_duplicated(service):
    inviter = _uid("inviter")
    invitee = _uid("invitee")
    other = _uid("other")
    code = service.initialize_invite_profile(inviter)["inviteCode"]
    service.initialize_invite_profile(invitee, "피초대자")
    service.apply_invite_code(invitee, code)
    grant_id = grant_id_for(invitee, "inviter")

    with pytest.raises(ForbiddenRewardError):
        service.claim_invite_reward(other, grant_id)
    with pytest.raises(RewardNotFoundError):
        service.claim_invite_reward(inviter, grant_id_for(invitee, "invitee"))

    with pytest.raises(RewardNotFoundError):
        service.claim_invite_reward(inviter, invitee)

    claimed = service.claim_invite_reward(inviter, grant_id)
    assert set(claimed) == {"grantId", "role"}
    assert claimed["grantId"] == grant_id
    assert "amount" not in claimed
    with pytest.raises(RewardAlreadyClaimedError):
        service.claim_invite_reward(inviter, grant_id)


# 인증 정보(UID)가 누락된 요청이 정상적으로 차단되는지 검증하는 테스트
def test_unauthenticated_requests_are_blocked(service):
    with pytest.raises(UnauthenticatedError):
        service.initialize_invite_profile(None)
    with pytest.raises(UnauthenticatedError):
        service.update_invite_nickname(None, "닉네임")
    with pytest.raises(UnauthenticatedError):
        service.apply_invite_code("", "ABCDEF")
    with pytest.raises(UnauthenticatedError):
        service.get_invite_status(None)
    with pytest.raises(UnauthenticatedError):
        service.claim_invite_reward(None, "grant")
    with pytest.raises(UnauthenticatedError):
        service.sync_invite_rewards("")


# 초대 상태 조회 및 보상 동기화 페이로드 구조를 검증하는 테스트
def test_status_and_sync_payloads(service, db):
    inviter = _uid("inviter")
    invitee = _uid("invitee")
    code = service.initialize_invite_profile(inviter)["inviteCode"]
    service.initialize_invite_profile(invitee, "첫닉네임")
    service.apply_invite_code(invitee, code)

    status = service.get_invite_status(inviter)
    assert set(status) == {"invitations"}
    assert len(status["invitations"]) == 1
    assert status["invitations"][0]["inviteeNickname"] == "첫닉네임"
    assert status["invitations"][0]["inviterRewardStatus"] == STATUS_PENDING

    service.update_invite_nickname(invitee, "새닉네임")
    updated_status = service.get_invite_status(inviter)
    assert updated_status["invitations"][0]["inviteeNickname"] == "새닉네임"
    assert db.collection(COLLECTION_USERS).document(invitee).get().to_dict()["nickname"] == "새닉네임"

    service.claim_invite_reward(inviter, grant_id_for(invitee, "inviter"))
    synced = service.sync_invite_rewards(inviter)
    assert set(synced) == {"claimed"}
    assert len(synced["claimed"]) == 1
    invitee_sync = service.sync_invite_rewards(invitee)
    assert "amount" not in invitee_sync["claimed"][0]


# 동시 요청 시에도 단 하나의 초대 관계 문서만 생성되는지 원자성을 검증하는 테스트
def test_concurrent_apply_creates_single_invitation(service, db):
    inviter = _uid("inviter")
    invitee = _uid("invitee")
    code = service.initialize_invite_profile(inviter)["inviteCode"]
    service.initialize_invite_profile(invitee, "동시요청")
    errors = []

    # 동시 실행 스레드에서 초대 코드를 적용하는 작업 함수
    def worker():
        try:
            service.apply_invite_code(invitee, code)
        except Exception as error:  # noqa: BLE001
            errors.append(error)

    threads = [threading.Thread(target=worker) for _ in range(8)]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()

    assert db.collection(COLLECTION_INVITATIONS).document(invitee).get().exists
    assert errors == []
    user_doc = db.collection(COLLECTION_USERS).document(invitee).get().to_dict()
    assert user_doc["dailyAttemptCount"] == 1


# Firestore 문서에 클라이언트 로컬 전용 재화 필드가 저장되지 않는지 검증하는 테스트
def test_user_and_code_documents_do_not_store_wallet(service, db):
    uid = _uid("issuer")
    code = service.initialize_invite_profile(uid)["inviteCode"]
    user_doc = db.collection(COLLECTION_USERS).document(uid).get().to_dict()
    code_doc = db.collection(COLLECTION_INVITE_CODES).document(code).get().to_dict()
    _assert_no_wallet_fields(user_doc)
    _assert_no_wallet_fields(code_doc)


# 문서 데이터에 지갑 및 다이아몬드, 보상 수량 관련 필드가 포함되지 않았는지 단언하는 헬퍼 함수
def _assert_no_wallet_fields(data: dict | None):
    assert data is not None
    assert WALLET_KEYS.isdisjoint(set(data.keys()))
    serialized = str(data).lower()
    assert "diamond" not in serialized
    assert "wallet" not in serialized
    assert "amount" not in serialized
