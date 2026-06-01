//
//  AnalyticsService.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/15/26.
//

import FirebaseAnalytics

private typealias AP = AnalyticsProperty

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    // MARK: - 성장

    /// device_id 기준 첫 앱 실행 (앱 재설치 시에도 1회만)
    func logFirstOpen(level: Int) {
        Analytics.logEvent("first_open", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.appVersion: AP.appVersionValue,
            AP.osVersion: AP.osVersionValue,
            AP.deviceModel: AP.deviceModelValue,
            AP.level: level
        ])
    }
}
