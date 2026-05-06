//
//  AdService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/6/26.
//

import AppTrackingTransparency

enum AdType {
    case interstitial
}

final class AdService {
    static let shared = AdService()

    private let factory: AdFactory
    private var loadedAds: [AdType: AdUnit] = [:]

    init(factory: AdFactory = DefaultAdFactory()) {
        self.factory = factory
    }

    // 광고 로드
    func loadAd(_ type: AdType) async {
        let ads = factory.makeAdUnit(for: type)
        do {
            try await ads.load()
            loadedAds[type] = ads
        } catch {
            print("❌ Ad load failed: \(error.localizedDescription)")
        }
    }

    // 광고 표시
    func showAd(_ type: AdType) async {
        await requestTrackingAuthorizationIfNeeded()

        guard let ads = loadedAds[type], ads.isReady else {
            print("⚠️ Ad not ready")
            return
        }

        await ads.show()
        loadedAds.removeValue(forKey: type)

        // 다음 광고 preload
        Task {
            await loadAd(type)
        }
    }
}

private extension AdService {
    func requestTrackingAuthorizationIfNeeded() async {
        // 이미 ATT 요청했거나, iOS 14.5 미만이면 무시
        guard #available(iOS 14.5, *), ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            return
        }
        let status = await ATTrackingManager.requestTrackingAuthorization()
        switch status {
        case .authorized:
            print("정보 추적 허용됨")
        case .denied, .restricted, .notDetermined:
            print("정보 추적 거부됨")
        @unknown default:
            break
        }
    }
}
