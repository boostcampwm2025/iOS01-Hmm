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

    /// 광고 이벤트별 flow ID 중복 로깅 방지
    private var loggedAdRewardFlowIDsByEvent: [AdAnalyticsEvent: Set<String>] = [:]

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
        let event = AdAnalyticsEvent.offerViewed
        guard shouldLogAdEvent(event, adRewardFlowID: adRewardFlowID) else { return }

        Analytics.logEvent(event.rawValue, parameters: [
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
        rewardType: AdRewardType,
        rewardAmount: Int
    ) {
        let event = AdAnalyticsEvent.watchClicked
        guard shouldLogAdEvent(event, adRewardFlowID: adRewardFlowID) else { return }

        Analytics.logEvent(event.rawValue, parameters: [
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

    /// 광고 시청을 완료했을 때
    func logAdWatchCompleted(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int,
        adWatchDurationSec: Int
    ) {
        let event = AdAnalyticsEvent.watchCompleted
        guard shouldLogAdEvent(event, adRewardFlowID: adRewardFlowID) else { return }

        Analytics.logEvent(event.rawValue, parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.adRewardFlowID: adRewardFlowID,
            AP.adPlacement: adPlacement.rawValue,
            AP.rewardType: rewardType.rawValue,
            AP.rewardAmount: rewardAmount,
            AP.adFormat: AdType.interstitial.rawValue,
            AP.adNetwork: "admob",
            AP.adUnitID: Bundle.main.adMobInterstitialAdUnitID,
            AP.adWatchDurationSec: adWatchDurationSec
        ])
    }

    /// 광고 완료 후 보상이 실제 지급 완료될 때
    func logAdRewardClaimed(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int
    ) {
        let event = AdAnalyticsEvent.rewardClaimed
        guard shouldLogAdEvent(event, adRewardFlowID: adRewardFlowID) else { return }

        Analytics.logEvent(event.rawValue, parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.adRewardFlowID: adRewardFlowID,
            AP.adPlacement: adPlacement.rawValue,
            AP.rewardType: rewardType.rawValue,
            AP.rewardAmount: rewardAmount,
            AP.adFormat: AdType.interstitial.rawValue,
            AP.adNetwork: "admob",
            AP.adUnitID: Bundle.main.adMobInterstitialAdUnitID,
        ])
    }

    /// 사용자가 광고 제안을 닫거나 보지 않기로 선택 시
    func logAdOfferDismissed(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int,
        dismissReason: AdOfferDismissReasonType
    ) {
        let event = AdAnalyticsEvent.offerDismissed
        guard shouldLogAdEvent(event, adRewardFlowID: adRewardFlowID) else { return }

        Analytics.logEvent(event.rawValue, parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.adRewardFlowID: adRewardFlowID,
            AP.adPlacement: adPlacement.rawValue,
            AP.rewardType: rewardType.rawValue,
            AP.rewardAmount: rewardAmount,
            AP.dismissReason: dismissReason.rawValue
        ])
    }

    private func shouldLogAdEvent(_ event: AdAnalyticsEvent, adRewardFlowID: String) -> Bool {
        var loggedFlowIDs = loggedAdRewardFlowIDsByEvent[event, default: []]
        guard loggedFlowIDs.insert(adRewardFlowID).inserted else { return false }
        loggedAdRewardFlowIDsByEvent[event] = loggedFlowIDs
        return true
    }
}
