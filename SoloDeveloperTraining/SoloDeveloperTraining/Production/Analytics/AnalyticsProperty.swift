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

}

// MARK: - Device Values
extension AnalyticsProperty {
    /// UIDevice.identifierForVendor 기반 기기 고유 식별자
    static var deviceIDValue: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
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
