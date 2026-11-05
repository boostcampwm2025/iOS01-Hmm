# 친구 초대 코드 생성, 정규화 및 유효성 검증 함수 모듈
from __future__ import annotations

import secrets
import string

from .constants import INVITE_CODE_ALPHABET, INVITE_CODE_LENGTH


# 혼동하기 쉬운 문자를 제외하고 지정된 길이의 고유 초대 코드를 무작위 생성하는 함수
def generate_invite_code(length: int = INVITE_CODE_LENGTH) -> str:
    return "".join(secrets.choice(INVITE_CODE_ALPHABET) for _ in range(length))


# 입력 문자열을 대문자 및 영숫자만 남겨 정규화된 초대 코드로 변환하는 함수
def normalize_invite_code(raw: str | None) -> str:
    if raw is None:
        return ""
    return "".join(ch for ch in str(raw).upper() if ch in string.ascii_uppercase + string.digits)


# 초대 코드가 정해진 길이와 허용 문자 집합 규칙에 부합하는지 검증하는 함수
def is_valid_invite_code_format(code: str) -> bool:
    return len(code) == INVITE_CODE_LENGTH and all(ch in INVITE_CODE_ALPHABET for ch in code)
