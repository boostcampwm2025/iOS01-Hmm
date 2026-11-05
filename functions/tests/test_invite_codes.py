# 초대 코드 생성, 포맷 검증 및 정규화 기능 단위 테스트 모듈
from invite.invite_codes import generate_invite_code, is_valid_invite_code_format, normalize_invite_code
from invite.constants import INVITE_CODE_ALPHABET, INVITE_CODE_LENGTH


# 생성된 초대 코드가 요구된 길이와 허용 문자 집합 규칙을 만족하는지 검증하는 테스트
def test_generated_code_has_expected_format():
    code = generate_invite_code()
    assert is_valid_invite_code_format(code)
    assert len(code) == INVITE_CODE_LENGTH
    assert all(ch in INVITE_CODE_ALPHABET for ch in code)


# 생성된 초대 코드에 혼동하기 쉬운 문자가 제외되는지 검증하는 테스트
def test_generated_code_excludes_confusing_characters():
    confusing = set("0O1IL")
    for _ in range(200):
        code = generate_invite_code()
        assert confusing.isdisjoint(code)


# 초대 코드 정규화 및 잘못된 형식 거부 처리가 올바르게 동작하는지 검증하는 테스트
def test_normalize_and_reject_invalid_format():
    assert normalize_invite_code(" ab-c12 ") == "ABC12"
    assert not is_valid_invite_code_format("ABC12")
    assert not is_valid_invite_code_format("ABC10O")
    assert not is_valid_invite_code_format("abcdef")
