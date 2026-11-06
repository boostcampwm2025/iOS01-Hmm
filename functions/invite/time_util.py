# KST(한국 표준시) 기준 날짜 및 시간 변환 유틸리티 모듈
from datetime import datetime

from .constants import KST


# 현재 시각을 타임존이 포함된 UTC datetime 객체로 반환하는 함수
def now_utc() -> datetime:
    return datetime.now(tz=KST).astimezone(tz=KST).astimezone()


# 지정된 시각 또는 현재 시각을 KST 기준의 'YYYY-MM-DD' 문자열로 변환하는 함수
def kst_date_string(moment: datetime | None = None) -> str:
    current = moment.astimezone(KST) if moment is not None else datetime.now(tz=KST)
    return current.date().isoformat()


# 밀리초 단위 타임스탬프를 datetime 객체로 변환하는 함수
def millis_to_datetime(millis: int | None) -> datetime | None:
    if millis is None:
        return None
    return datetime.fromtimestamp(millis / 1000, tz=KST).astimezone()
