# 친구 초대 도메인 전용 예외 클래스 정의 모듈
class InviteError(Exception):
    # 초대 에러의 오류 코드, HTTP 상태 코드 및 메시지를 초기화하는 생성자
    def __init__(self, error_code: str, http_code: str, message: str):
        super().__init__(message)
        self.error_code = error_code
        self.http_code = http_code
        self.message = message


class UnauthenticatedError(InviteError):
    # 미인증 사용자 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("UNAUTHENTICATED", "unauthenticated", "Authentication is required.")


class InvalidInviteCodeError(InviteError):
    # 잘못된 초대 코드 형식 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("INVALID_INVITE_CODE", "invalid-argument", "Invite code format is invalid.")


class InviteCodeNotFoundError(InviteError):
    # 존재하지 않는 초대 코드 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("INVITE_CODE_NOT_FOUND", "not-found", "Invite code does not exist.")


class OwnInviteCodeError(InviteError):
    # 본인의 초대 코드 입력 불가 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("OWN_INVITE_CODE", "failed-precondition", "Cannot apply your own invite code.")


class AlreadyAppliedError(InviteError):
    # 이미 초대 코드를 등록한 사용자 오류를 생성하는 생성자
    def __init__(self):
        super().__init__(
            "ALREADY_APPLIED",
            "already-exists",
            "This user has already registered an invite code.",
        )


class NotNewUserError(InviteError):
    # 신규 사용자가 아닌 경우 발생하는 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("NOT_NEW_USER", "failed-precondition", "Invite codes can only be applied by new users.")


class DailyAttemptLimitError(InviteError):
    # 일일 초대 코드 입력 시도 횟수 초과 오류를 생성하는 생성자
    def __init__(self):
        super().__init__(
            "DAILY_ATTEMPT_LIMIT",
            "resource-exhausted",
            "Daily invite code attempt limit exceeded.",
        )


class RewardNotFoundError(InviteError):
    # 보상 지급 내역을 찾을 수 없을 때 발생하는 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("REWARD_NOT_FOUND", "not-found", "Reward grant was not found.")


class RewardAlreadyClaimedError(InviteError):
    # 이미 수령한 보상 재수령 시 발생하는 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("REWARD_ALREADY_CLAIMED", "already-exists", "Reward has already been claimed.")


class ForbiddenRewardError(InviteError):
    # 타인의 보상을 수령하려고 할 때 발생하는 권한 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("FORBIDDEN", "permission-denied", "Cannot claim another user's reward.")


class InviteCodeGenerationError(InviteError):
    # 고유 초대 코드 생성 실패 시 발생하는 내부 오류를 생성하는 생성자
    def __init__(self):
        super().__init__("INTERNAL", "internal", "Failed to allocate a unique invite code.")
