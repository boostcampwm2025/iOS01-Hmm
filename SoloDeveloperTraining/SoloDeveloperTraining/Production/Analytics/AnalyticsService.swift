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
        Analytics.logEvent("my_app_first_open", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.appVersion: AP.appVersionValue,
            AP.osVersion: AP.osVersionValue,
            AP.deviceModel: AP.deviceModelValue,
            AP.level: level
        ])
    }

    /// 매 실행마다 카운트
    func logAppOpened(
        nickname: String,
        level: Int,
        entrySource: String,
        referrerShareID: String,
        isDeferredDeeplink: Bool
    ) {
        Analytics.logEvent("app_opened", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.nickname: nickname,
            AP.appVersion: AP.appVersionValue,
            AP.osVersion: AP.osVersionValue,
            AP.deviceModel: AP.deviceModelValue,
            AP.entrySource: entrySource,
            AP.referrerShareID: referrerShareID,
            AP.isDeferredDeeplink: isDeferredDeeplink,
            AP.level: level
        ])
    }

    /// 사용자가 앱 사용을 종료하거나 세션 만료
    func logSessionEnded(level: Int, lastScreen: String) {
        Analytics.logEvent("session_ended", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.sessionDurationSec: SessionManager.shared.sessionDurationSec,
            AP.lastScreen: lastScreen,
            AP.level: level
        ])
    }

    // MARK: - 공유

    /// 공유 버튼 클릭
    func logShareButtonClicked(
        shareID: String,
        resultID: String,
        shareChannel: String
    ) {
        Analytics.logEvent("share_button_clicked", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.shareID: shareID,
            AP.resultID: resultID,
            AP.shareChannel: shareChannel
        ])
    }
}
