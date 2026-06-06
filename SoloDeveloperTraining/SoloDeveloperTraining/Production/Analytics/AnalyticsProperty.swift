//
//  AnalyticsProperty.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/1/26.
//

import UIKit

enum AnalyticsProperty {

    // MARK: - User Properties

    /// 기기 고유 식별자
    static let deviceID = "device_id"
    /// 앱 사용 세션 식별자
    static let sessionID = "session_id"
    /// 앱 버전
    static let appVersion = "app_version"
    /// 사용 중인 iOS 버전
    static let osVersion = "os_version"
    /// 사용 기기 모델
    static let deviceModel = "device_model"
    /// 현재 사용자 레벨
    static let level = "level"
    /// 사용자 닉네임
    static let nickname = "nickname"

    // MARK: - Event Properties

    /// 유입 경로
    static let entrySource = "entry_source"
    /// 유입을 만든 원 공유 ID
    static let referrerShareID = "referrer_share_id"
    /// 설치 후 딥링크 유입 여부
    static let isDeferredDeeplink = "is_deferred_deeplink"
    /// 세션 체류시간
    static let sessionDurationSec = "session_duration_sec"
    /// 세션 종료 전 마지막 화면
    static let lastScreen = "last_screen"
    /// 공유 1건 식별자
    static let shareID = "share_id"
    /// 엔딩/결과 식별자
    static let resultID = "result_id"
    /// 공유 채널
    static let shareChannel = "share_channel"

}

// MARK: - Device Values
extension AnalyticsProperty {
    /// Keychain 기반 앱 고유 식별자 (UUID)
    static var deviceIDValue: String {
        AnalyticsKeychain.getOrCreateDeviceID()
    }

    /// CFBundleShortVersionString 기반 앱 버전
    static var appVersionValue: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }

    /// UIDevice.systemVersion 기반 iOS 버전
    static var osVersionValue: String {
        "iOS \(UIDevice.current.systemVersion)"
    }

    /// UIDevice.localizedModel 기반 기기 모델명
    static var deviceModelValue: String {
        UIDevice.current.localizedModel
    }
}
