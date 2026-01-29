//
//  QuizGameState.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/22/26.
//

struct QuizGameState {
    /// 현재 세션에서 획득한 총 다이아 개수
    let totalDiamondsEarned: Int
    /// 진행도 텍스트 (예: "1/3", "2/3")
    let progressText: String
    /// 다음 버튼의 텍스트 ("다음" 또는 "결과 보기")
    let nextButtonTitle: String
    /// 제출 버튼 활성화 여부
    let isSubmitEnabled: Bool
    /// 타이머 프로그래스 바 값 (0.0 ~ 1.0)
    let timerProgress: Double
    /// 게임 진행 단계
    let phase: QuizGamePhase
    /// 현재 문제
    let currentQuestion: QuizQuestion?
    /// 선택한 답안 인덱스
    let selectedAnswerIndex: Int?
    /// 현재 답안 결과
    let currentAnswerResult: QuizAnswerResult?
    /// 남은 시간 (초)
    let remainingSeconds: Int
    /// 맞춘 문제 개수
    let correctAnswersCount: Int
}
