//
//  QuizAnswerResult.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/22/26.
//

enum QuizAnswerResult {
    /// 정답
    case correct
    /// 오답
    case incorrect
    /// 시간 초과
    case timeout

    /// 정답 여부
    var isCorrect: Bool {
        return self == .correct
    }
}
