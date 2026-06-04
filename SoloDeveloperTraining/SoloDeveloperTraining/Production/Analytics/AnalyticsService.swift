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
}

// MARK: - 광고
extension AnalyticsService {

    /// 광고 흐름 (광고 제안 → 클릭 → 시작 → 완료 → 보상) 식별자 생성
    func makeAdRewardFlowID() -> String {
        "ad_reward_\(UUID().uuidString)"
    }

    /// 광고 보기 버튼/팝업이 사용자에게 노출될 때
    func logAdOfferViewed(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int
    ) {
        Analytics.logEvent("ad_offer_viewed", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.adRewardFlowID: adRewardFlowID,
            AP.adPlacement: adPlacement.rawValue,
            AP.rewardType: rewardType.rawValue,
            AP.rewardAmount: rewardAmount,
            AP.adFormat: AdType.interstitial.rawValue,
            AP.adNetwork: "admob",
            AP.adUnitID: Bundle.main.adMobInterstitialAdUnitID
        ])
    }

    /// 광고 보기를 클릭했을 때
    func logAdWatchClicked(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: String,
        rewardAmount: Int
    ) {
        Analytics.logEvent("ad_watch_clicked", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.adRewardFlowID: adRewardFlowID,
            AP.adPlacement: adPlacement,
            AP.rewardType: rewardType,
            AP.rewardAmount: rewardAmount,
            AP.adFormat: AdType.interstitial,
            AP.adNetwork: "admob",
            AP.adUnitID: Bundle.main.adMobInterstitialAdUnitID
        ])
    }

    /// 광고 시청을 완료했을 때
    func logAdWatchCompleted(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: String,
        rewardAmount: Int,
        adWatchDurationSec: Int
    ) {
        Analytics.logEvent("ad_watch_completed", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.adRewardFlowID: adRewardFlowID,
            AP.adPlacement: adPlacement,
            AP.rewardType: rewardType,
            AP.rewardAmount: rewardAmount,
            AP.adFormat: AdType.interstitial,
            AP.adNetwork: "admob",
            AP.adUnitID: Bundle.main.adMobInterstitialAdUnitID,
            AP.adWatchDurationSec: adWatchDurationSec
        ])
    }
}
