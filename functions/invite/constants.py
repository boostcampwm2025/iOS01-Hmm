# 친구 초대 시스템에서 사용하는 상수, 컬렉션 이름 및 상태 값 정의 모듈
from datetime import timedelta, timezone

KST = timezone(timedelta(hours=9))

INVITE_CODE_LENGTH = 6
# 시각적 혼동을 줄 수 있는 문자는 제외합니다. (0/O, 1/I/L)
INVITE_CODE_ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789"

# 일일 최대 입력 가능 횟수
MAX_DAILY_ATTEMPTS = 5
# 초대 코드 생성 최대 시도 횟수
CODE_GENERATION_MAX_ATTEMPTS = 20

COLLECTION_USERS = "users"
COLLECTION_INVITE_CODES = "inviteCodes"
COLLECTION_INVITATIONS = "invitations"

STATUS_PENDING = "PENDING"
STATUS_CLAIMED = "CLAIMED"

ROLE_INVITER = "inviter"
ROLE_INVITEE = "invitee"
