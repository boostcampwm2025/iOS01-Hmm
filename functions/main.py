# Firebase Cloud Functions HTTP 호출 진입점 모듈
from firebase_admin import initialize_app, firestore
from firebase_functions import https_fn
from firebase_functions.options import set_global_options

from invite.errors import InviteError, UnauthenticatedError
from invite.services import InviteService

set_global_options(max_instances=10, region="asia-northeast3")
initialize_app()


# Firestore 클라이언트가 연결된 InviteService 인스턴스를 반환하는 헬퍼 함수
def _service() -> InviteService:
    return InviteService(firestore.client())


# 호출 요청에서 인증된 사용자의 UID를 추출하고 검증하는 헬퍼 함수
def _uid_from(req: https_fn.CallableRequest) -> str:
    if req.auth is None or not req.auth.uid:
        raise UnauthenticatedError()
    return req.auth.uid


# 호출 요청 페이로드를 딕셔너리 형태로 안전하게 파싱하여 반환하는 헬퍼 함수
def _data(req: https_fn.CallableRequest) -> dict:
    payload = req.data
    return payload if isinstance(payload, dict) else {}


# 도메인 예외를 Firebase Functions의 표준 HttpsError로 변환하는 함수
def _https_error(error: InviteError) -> https_fn.HttpsError:
    code_map = {
        "unauthenticated": https_fn.FunctionsErrorCode.UNAUTHENTICATED,
        "invalid-argument": https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        "not-found": https_fn.FunctionsErrorCode.NOT_FOUND,
        "failed-precondition": https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        "already-exists": https_fn.FunctionsErrorCode.ALREADY_EXISTS,
        "resource-exhausted": https_fn.FunctionsErrorCode.RESOURCE_EXHAUSTED,
        "permission-denied": https_fn.FunctionsErrorCode.PERMISSION_DENIED,
        "internal": https_fn.FunctionsErrorCode.INTERNAL,
    }
    return https_fn.HttpsError(
        code=code_map.get(error.http_code, https_fn.FunctionsErrorCode.INTERNAL),
        message=error.error_code,
        details={"errorCode": error.error_code, "message": error.message},
    )


# 사용자 초대 프로필을 초기화하고 고유 초대 코드를 발급하는 Cloud Function
@https_fn.on_call()
def initialize_invite_profile(req: https_fn.CallableRequest) -> dict:
    try:
        return _service().initialize_invite_profile(_uid_from(req))
    except InviteError as error:
        raise _https_error(error) from error


# 입력받은 친구 초대 코드를 검증하고 등록하는 Cloud Function
@https_fn.on_call()
def apply_invite_code(req: https_fn.CallableRequest) -> dict:
    try:
        data = _data(req)
        return _service().apply_invite_code(
            _uid_from(req),
            data.get("inviteCode"),
            data.get("inputMethod"),
        )
    except InviteError as error:
        raise _https_error(error) from error


# 사용자의 초대 코드, 초대 현황 및 보상 상태를 조회하는 Cloud Function
@https_fn.on_call()
def get_invite_status(req: https_fn.CallableRequest) -> dict:
    try:
        return _service().get_invite_status(_uid_from(req))
    except InviteError as error:
        raise _https_error(error) from error


# 지급 대기 상태의 초대 보상을 수령 처리하는 Cloud Function
@https_fn.on_call()
def claim_invite_reward(req: https_fn.CallableRequest) -> dict:
    try:
        data = _data(req)
        target_id = data.get("invitationId") or data.get("grantId")
        return _service().claim_invite_reward(_uid_from(req), target_id)
    except InviteError as error:
        raise _https_error(error) from error


# 사용자의 대기 및 수령 완료된 모든 초대 보상 내역을 동기화 조회하는 Cloud Function
@https_fn.on_call()
def sync_invite_rewards(req: https_fn.CallableRequest) -> dict:
    try:
        return _service().sync_invite_rewards(_uid_from(req))
    except InviteError as error:
        raise _https_error(error) from error
