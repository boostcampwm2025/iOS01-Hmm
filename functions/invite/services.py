# 친구 초대 비즈니스 로직 및 Firestore 트랜잭션 처리 서비스 모듈
from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from firebase_admin import firestore as admin_firestore
from google.cloud.firestore_v1 import transactional
from google.cloud.firestore_v1.base_query import FieldFilter

from . import constants as const
from . import errors
from invite.invite_codes import (
    generate_invite_code,
    normalize_invite_code,
    is_valid_invite_code_format,
)

from .time_util import kst_date_string


# 초대 ID와 역할을 조합하여 보상 식별자를 반환하는 헬퍼 함수
def grant_id_for(invitation_id: str, role: str = const.ROLE_INVITER) -> str:
    return f"{invitation_id}_{role}"


# 보상 식별자에서 원본 초대 ID를 추출하는 헬퍼 함수
def _invitation_id_from(grant_id: str) -> str:
    inviter_suffix = f"_{const.ROLE_INVITER}"
    invitee_suffix = f"_{const.ROLE_INVITEE}"
    if grant_id.endswith(invitee_suffix):
        raise errors.RewardNotFoundError()
    if grant_id.endswith(inviter_suffix):
        invitation_id = grant_id[: -len(inviter_suffix)]
        if not invitation_id:
            raise errors.RewardNotFoundError()
        return invitation_id
    raise errors.RewardNotFoundError()


# 사용자 UID 유효성을 검증하고 없을 경우 미인증 예외를 발생시키는 함수
def require_uid(uid: str | None) -> str:
    if not uid:
        raise errors.UnauthenticatedError()
    return uid


class InviteService:
    # Firestore 클라이언트를 주입받아 초기화하는 생성자
    def __init__(self, db):
        self.db = db

    # 사용자 초대 프로필을 확인하고 고유 초대 코드가 없으면 새로 발급하는 메서드
    def initialize_invite_profile(
        self,
        uid: str | None,
        nickname: str | None = None,
    ) -> dict[str, Any]:
        uid = require_uid(uid)
        existing = self.db.collection(const.COLLECTION_USERS).document(uid).get()
        if existing.exists:
            code = existing.to_dict().get("inviteCode")
            if isinstance(code, str) and code:
                if nickname is not None:
                    self.update_invite_nickname(uid, nickname)
                return {"inviteCode": code}

        for _ in range(const.CODE_GENERATION_MAX_ATTEMPTS):
            code = generate_invite_code()
            allocated = self._try_create_profile(uid, code, nickname)
            if allocated:
                return {"inviteCode": allocated}

        raise errors.InviteCodeGenerationError()

    # 사용자 프로필 닉네임과 초대 문서의 조회용 복제본을 하나의 트랜잭션으로 갱신하는 메서드
    def update_invite_nickname(self, uid: str | None, nickname: str | None) -> dict[str, Any]:
        uid = require_uid(uid)
        user_ref = self.db.collection(const.COLLECTION_USERS).document(uid)
        invitation_ref = self.db.collection(const.COLLECTION_INVITATIONS).document(uid)

        @transactional
        def commit(transaction) -> None:
            invitation_snap = invitation_ref.get(transaction=transaction)
            transaction.set(
                user_ref,
                {"nickname": nickname},
                merge=True,
            )
            if invitation_snap.exists:
                transaction.update(
                    invitation_ref,
                    {"inviteeNickname": nickname},
                )

        commit(self.db.transaction())
        return {}

    # 시도 횟수 및 고유성을 검증한 후 초대 코드를 등록하고 보상을 생성하는 메서드
    def apply_invite_code(
        self,
        uid: str | None,
        invite_code: str | None,
    ) -> dict[str, Any]:
        uid = require_uid(uid)
        code = normalize_invite_code(invite_code)

        existing_invitation = self.db.collection(const.COLLECTION_INVITATIONS).document(uid).get()
        if existing_invitation.exists:
            data = existing_invitation.to_dict() or {}
            if data.get("inviteCode") == code:
                return self._apply_success_payload(uid)
            raise errors.AlreadyAppliedError()

        if not is_valid_invite_code_format(code):
            self._consume_attempt(uid)
            raise errors.InvalidInviteCodeError()

        code_snap = self.db.collection(const.COLLECTION_INVITE_CODES).document(code).get()
        if not code_snap.exists:
            self._consume_attempt(uid)
            raise errors.InviteCodeNotFoundError()

        inviter_uid = (code_snap.to_dict() or {}).get("uid")
        if not isinstance(inviter_uid, str) or not inviter_uid:
            self._consume_attempt(uid)
            raise errors.InviteCodeNotFoundError()
        if inviter_uid == uid:
            self._consume_attempt(uid)
            raise errors.OwnInviteCodeError()

        self._create_invitation_and_consume_attempt(
            invitee_uid=uid,
            inviter_uid=inviter_uid,
            invite_code=code,
        )
        return self._apply_success_payload(uid)

    # 사용자의 초대 목록과 보상 상태를 조회하는 메서드
    def get_invite_status(self, uid: str | None) -> dict[str, Any]:
        uid = require_uid(uid)
        invitations_query = (
            self.db.collection(const.COLLECTION_INVITATIONS)
            .where(filter=FieldFilter("inviterUid", "==", uid))
            .order_by("createdAt", direction=admin_firestore.Query.DESCENDING)
        )
        invitation_docs = list(invitations_query.stream())
        invitations = [_invitation_status(doc.id, doc.to_dict() or {}) for doc in invitation_docs]

        return {"invitations": invitations}

    # 초대 문서를 검증하고 트랜잭션을 통해 보상을 수령 완료 상태로 변경하는 메서드
    def claim_invite_reward(self, uid: str | None, grant_id: str | None) -> dict[str, Any]:
        uid = require_uid(uid)
        if not grant_id or not isinstance(grant_id, str):
            raise errors.RewardNotFoundError()

        invitation_id = _invitation_id_from(grant_id)
        invitation_ref = self.db.collection(const.COLLECTION_INVITATIONS).document(invitation_id)

        # 초대 문서의 보상 상태를 수령 완료로 갱신하는 Firestore 트랜잭션 함수
        @transactional
        def commit(transaction) -> dict[str, Any]:
            snap = invitation_ref.get(transaction=transaction)
            if not snap.exists:
                raise errors.RewardNotFoundError()
            invitation = snap.to_dict() or {}
            if invitation.get("inviterUid") != uid:
                raise errors.ForbiddenRewardError()
            current_status = invitation.get("inviterRewardStatus")
            if current_status == const.STATUS_CLAIMED:
                raise errors.RewardAlreadyClaimedError()
            if current_status != const.STATUS_PENDING:
                raise errors.RewardNotFoundError()

            transaction.update(
                invitation_ref,
                {"inviterRewardStatus": const.STATUS_CLAIMED},
            )
            return invitation

        commit(self.db.transaction())
        return {
            "grantId": grant_id_for(invitation_id, const.ROLE_INVITER),
            "role": const.ROLE_INVITER,
        }

    # 사용자의 대기 및 수령 완료된 모든 보상 내역을 invitations 컬렉션에서 동기화 조회하는 메서드
    def sync_invite_rewards(self, uid: str | None) -> dict[str, Any]:
        uid = require_uid(uid)
        docs = (
            self.db.collection(const.COLLECTION_INVITATIONS)
            .where(filter=FieldFilter("inviterUid", "==", uid))
            .stream()
        )
        claimed = []
        for doc in docs:
            data = doc.to_dict() or {}
            if data.get("inviterRewardStatus") == const.STATUS_CLAIMED:
                claimed.append(_invitation_grant_payload(doc.id))

        # 피초대자로서의 보상(가입 시 즉시 수령) 내역 포함
        invitee_doc = self.db.collection(const.COLLECTION_INVITATIONS).document(uid).get()
        if invitee_doc.exists:
            claimed.append({
                "grantId": grant_id_for(uid, const.ROLE_INVITEE),
                "role": const.ROLE_INVITEE,
            })

        return {"claimed": claimed}

    # 트랜잭션 내에서 프로필과 초대 코드의 중복을 확인하고 새 프로필을 생성하는 메서드
    def _try_create_profile(self, uid: str, code: str, nickname: str | None = None) -> bool:
        user_ref = self.db.collection(const.COLLECTION_USERS).document(uid)
        code_ref = self.db.collection(const.COLLECTION_INVITE_CODES).document(code)

        # 프로필 및 코드 문서를 원자적으로 생성하는 Firestore 트랜잭션 함수
        @transactional
        def commit(transaction) -> str:
            user_snap = user_ref.get(transaction=transaction)
            if user_snap.exists:
                existing_code = (user_snap.to_dict() or {}).get("inviteCode")
                if isinstance(existing_code, str) and existing_code:
                    return existing_code

            code_snap = code_ref.get(transaction=transaction)
            if code_snap.exists:
                return ""

            user_payload = {
                "inviteCode": code,
            }
            if nickname is not None:
                user_payload["nickname"] = nickname
            transaction.set(user_ref, user_payload, merge=True)
            transaction.set(
                code_ref,
                {"uid": uid},
            )
            return code

        return commit(self.db.transaction())

    # 일일 초대 코드 입력 시도 횟수를 users 문서에서 확인하고 1회 카운트하는 메서드
    def _consume_attempt(self, uid: str) -> None:
        ref = self.db.collection(const.COLLECTION_USERS).document(uid)

        # 시도 횟수 검증 및 업데이트를 원자적으로 수행하는 Firestore 트랜잭션 함수
        @transactional
        def commit(transaction) -> None:
            snap = ref.get(transaction=transaction)
            today = kst_date_string()
            data = snap.to_dict() if snap.exists else {}
            count = 0
            if data.get("dailyAttemptDate") == today:
                count = int(data.get("dailyAttemptCount") or 0)
            if count >= const.MAX_DAILY_ATTEMPTS:
                raise errors.DailyAttemptLimitError()
            payload = {
                "dailyAttemptDate": today,
                "dailyAttemptCount": count + 1,
            }
            if snap.exists:
                transaction.update(ref, payload)
            else:
                transaction.set(ref, payload)

        commit(self.db.transaction())

    # 일일 시도 횟수 반영과 초대 관계 생성을 하나의 트랜잭션으로 처리하는 메서드
    def _create_invitation_and_consume_attempt(
        self,
        *,
        invitee_uid: str,
        inviter_uid: str,
        invite_code: str,
    ) -> None:
        invitation_id = invitee_uid
        invitation_ref = self.db.collection(const.COLLECTION_INVITATIONS).document(invitation_id)
        user_ref = self.db.collection(const.COLLECTION_USERS).document(invitee_uid)

        # 동일 요청의 동시 재시도는 기존 초대를 반환하고 시도 횟수를 중복 차감하지 않는다.
        @transactional
        def commit(transaction) -> None:
            existing = invitation_ref.get(transaction=transaction)
            if existing.exists:
                data = existing.to_dict() or {}
                if data.get("inviteCode") == invite_code:
                    return
                raise errors.AlreadyAppliedError()

            user_snap = user_ref.get(transaction=transaction)
            today = kst_date_string()
            user_data = user_snap.to_dict() if user_snap.exists else {}
            invitee_nickname = user_data.get("nickname")
            if not isinstance(invitee_nickname, str) or not invitee_nickname:
                raise errors.NicknameRequiredError()
            count = 0
            if user_data.get("dailyAttemptDate") == today:
                count = int(user_data.get("dailyAttemptCount") or 0)
            if count >= const.MAX_DAILY_ATTEMPTS:
                raise errors.DailyAttemptLimitError()

            now = admin_firestore.SERVER_TIMESTAMP
            attempt_payload = {
                "dailyAttemptDate": today,
                "dailyAttemptCount": count + 1,
            }
            transaction.set(user_ref, attempt_payload, merge=True)

            invitation = {
                "inviterUid": inviter_uid,
                "inviteeNickname": invitee_nickname,
                "inviteCode": invite_code,
                "inviterRewardStatus": const.STATUS_PENDING,
                "createdAt": now,
            }
            transaction.set(invitation_ref, invitation)

        commit(self.db.transaction())

    # 초대 코드 등록 성공 시 클라이언트에 반환할 응답 페이로드를 생성하는 메서드
    def _apply_success_payload(
        self,
        invitee_uid: str,
    ) -> dict[str, Any]:
        return {
            "inviteeGrant": {
                "grantId": grant_id_for(invitee_uid, const.ROLE_INVITEE),
                "role": const.ROLE_INVITEE,
            },
        }


# 다양한 형식의 타임스탬프 또는 날짜 값을 UTC datetime 객체로 변환하는 헬퍼 함수
def _as_datetime(value: Any) -> datetime | None:
    if value is None:
        return None
    if isinstance(value, datetime):
        if value.tzinfo is None:
            return value.replace(tzinfo=timezone.utc)
        return value
    if hasattr(value, "timestamp"):
        return datetime.fromtimestamp(value.timestamp(), tz=timezone.utc)
    return None


# Firestore 초대 문서 데이터를 클라이언트 조회용 응답 포맷으로 변환하는 헬퍼 함수
def _invitation_status(invitation_id: str, data: dict[str, Any]) -> dict[str, Any]:
    created_at = _as_datetime(data.get("createdAt"))
    return {
        "invitationId": invitation_id,
        "inviteeNickname": data.get("inviteeNickname") or "친구",
        "createdAt": created_at.isoformat() if created_at else None,
        "inviterRewardStatus": data.get("inviterRewardStatus", const.STATUS_PENDING),
    }


# Firestore 초대 문서 데이터를 클라이언트 보상 동기화용 응답 포맷으로 변환하는 헬퍼 함수
def _invitation_grant_payload(invitation_id: str) -> dict[str, Any]:
    return {
        "grantId": grant_id_for(invitation_id, const.ROLE_INVITER),
        "role": const.ROLE_INVITER,
    }
