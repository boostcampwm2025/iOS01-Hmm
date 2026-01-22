//
//  QuizGameState.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/22/26.
//

enum QuizGameState: Equatable {
    /// 문제 로딩 중
    case loading
    /// 게임 시작 준비 완료
    case ready
    /// 문제 풀이 진행 중 (타이머 작동)
    case questionInProgress
    /// 해설 표시 중
    case showingExplanation
    /// 게임 완료 (모든 문제 풀이 완료)
    case completed
    /// 에러 발생
    case error(String)
}
