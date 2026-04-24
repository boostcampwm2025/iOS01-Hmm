//
//  AnalyticsService.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/15/26.
//

import FirebaseAnalytics

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    // MARK: - Screen View

    /// 화면 조회 이벤트
    /// 사용 위치: 주요 View의 .onAppear
    func logScreenView(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }

    // MARK: - Game Events

    /// 게임 시작 이벤트
    /// 사용 위치: 각 게임 View에서 게임 시작 시
    func logGameStart(gameType: GameType) {
        Analytics.logEvent("game_start", parameters: [
            "game_type": gameType.analyticsValue
        ])
    }

    // MARK: - User Engagement

    /// 튜토리얼 완료 이벤트
    /// 사용 위치: TutorialView 완료 시
    func logTutorialComplete() {
        Analytics.logEvent(AnalyticsEventTutorialComplete, parameters: nil)
    }
}

// MARK: - Analytics Extensions

private extension GameType {
    var analyticsValue: String {
        switch self {
        case .tap: return "tap"
        case .language: return "language"
        case .dodge: return "dodge"
        case .stack: return "stack"
        }
    }
}
