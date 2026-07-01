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

    /// 공유하기 중복 로깅 방지
    private var loggedShareCompletions: Set<String> = []
    private var loggedAppOpenedFromDeeplinkSessions: Set<String> = []

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

    /// 공유 완료 감지
    func logShareCompleted(
        shareID: String,
        shareChannel: String,
        resultID: String,
        referrerShareID: String,
        referrerDeviceID: String
    ) {
        let key = "\(shareID)_\(shareChannel)"
        guard loggedShareCompletions.insert(key).inserted else { return }

        Analytics.logEvent("share_completed", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.shareID: shareID,
            AP.shareChannel: shareChannel,
            AP.resultID: resultID,
            AP.referrerShareID: referrerShareID,
            AP.referrerDeviceID: referrerDeviceID
        ])
    }

    /// 딥링크로 앱 실행
    func logAppOpenedFromDeeplink(
        entrySource: String,
        referrerShareID: String,
        isDeferredDeeplink: Bool,
        resultID: String
    ) {
        let sessionID = SessionManager.shared.sessionID
        guard loggedAppOpenedFromDeeplinkSessions.insert(sessionID).inserted else { return }

        Analytics.logEvent("app_opened_from_deeplink", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.entrySource: entrySource,
            AP.referrerShareID: referrerShareID,
            AP.isDeferredDeeplink: isDeferredDeeplink,
            AP.resultID: resultID
        ])
    }

    /// 앱 설치 후 딥링크 유입
    func logDeferredDeeplinkOpened(
        entrySource: String,
        referrerShareID: String,
        referrerDeviceID: String,
        isDeferredDeeplink: Bool,
        resultID: String
    ) {
        Analytics.logEvent("deferred_deeplink_opened", parameters: [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.entrySource: entrySource,
            AP.referrerShareID: referrerShareID,
            AP.referrerDeviceID: referrerDeviceID,
            AP.isDeferredDeeplink: isDeferredDeeplink,
            AP.resultID: resultID
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
        logAdEvent(
            .offerViewed,
            adRewardFlowID: adRewardFlowID,
            adPlacement: adPlacement,
            rewardType: rewardType,
            rewardAmount: rewardAmount
        )
    }

    /// 광고 보기를 클릭했을 때
    func logAdWatchClicked(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int
    ) {
        logAdEvent(
            .watchClicked,
            adRewardFlowID: adRewardFlowID,
            adPlacement: adPlacement,
            rewardType: rewardType,
            rewardAmount: rewardAmount
        )
    }

    /// 광고 시청을 완료했을 때
    func logAdWatchCompleted(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int,
        adWatchDurationSec: Int
    ) {
        logAdEvent(
            .watchCompleted,
            adRewardFlowID: adRewardFlowID,
            adPlacement: adPlacement,
            rewardType: rewardType,
            rewardAmount: rewardAmount,
            additionalParameters: [
                AP.adWatchDurationSec: adWatchDurationSec
            ]
        )
    }

    /// 광고 완료 후 보상이 실제 지급 완료될 때
    func logAdRewardClaimed(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int
    ) {
        logAdEvent(
            .rewardClaimed,
            adRewardFlowID: adRewardFlowID,
            adPlacement: adPlacement,
            rewardType: rewardType,
            rewardAmount: rewardAmount
        )
    }

    /// 사용자가 광고 제안을 닫거나 보지 않기로 선택 시
    func logAdOfferDismissed(
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType,
        rewardAmount: Int,
        dismissReason: AdOfferDismissReasonType
    ) {
        logAdEvent(
            .offerDismissed,
            adRewardFlowID: adRewardFlowID,
            adPlacement: adPlacement,
            rewardType: rewardType,
            rewardAmount: rewardAmount,
            includesAdInfo: false,
            additionalParameters: [
                AP.dismissReason: dismissReason.rawValue
            ]
        )
    }

    private func logAdEvent(
        _ event: AdAnalyticsEvent,
        adRewardFlowID: String,
        adPlacement: AdPlacementType,
        rewardType: AdRewardType? = nil,
        rewardAmount: Int? = nil,
        includesReward: Bool = true,
        includesAdInfo: Bool = true,
        additionalParameters: [String: Any] = [:]
    ) {
        guard registerAdEventOnce(event, adRewardFlowID: adRewardFlowID) else { return }

        var parameters = baseAdEventParameters(
            adRewardFlowID: adRewardFlowID,
            adPlacement: adPlacement.screenID,
            includesAdInfo: includesAdInfo
        )
        if includesReward, let rewardType, let rewardAmount {
            parameters[AP.rewardType] = rewardType.rawValue
            parameters[AP.rewardAmount] = rewardAmount
        }
        additionalParameters.forEach { parameters[$0.key] = $0.value }

        Analytics.logEvent(event.rawValue, parameters: parameters)
    }

    private func baseAdEventParameters(
        adRewardFlowID: String,
        adPlacement: String,
        includesAdInfo: Bool
    ) -> [String: Any] {
        var parameters: [String: Any] = [
            AP.deviceID: AP.deviceIDValue,
            AP.sessionID: SessionManager.shared.sessionID,
            AP.adRewardFlowID: adRewardFlowID,
            AP.adPlacement: adPlacement
        ]

        if includesAdInfo {
            parameters[AP.adFormat] = AdType.interstitial.rawValue
            parameters[AP.adNetwork] = "admob"
            parameters[AP.adUnitID] = Bundle.main.adMobInterstitialAdUnitID
        }
        return parameters
    }

    private func registerAdEventOnce(_ event: AdAnalyticsEvent, adRewardFlowID: String) -> Bool {
        var loggedFlowIDs = loggedAdRewardFlowIDsByEvent[event, default: []]
        guard loggedFlowIDs.insert(adRewardFlowID).inserted else { return false }
        loggedAdRewardFlowIDsByEvent[event] = loggedFlowIDs
        return true
    }
}
