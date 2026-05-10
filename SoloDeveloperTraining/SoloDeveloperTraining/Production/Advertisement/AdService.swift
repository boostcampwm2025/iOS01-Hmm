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

@MainActor
final class AdService {
    static let shared: AdService = {
        AdService(factory: DefaultAdFactory())
    }()

    private let factory: AdFactory
    private var loadedAds: [AdType: AdUnit] = [:]
    private var isShowing = false

    init(factory: AdFactory) {
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

    // 광고 표시 후 결과 반환 (true: 정상 시청 완료, false: 실패)
    func showAdWithResult(_ type: AdType) async -> Bool {
        guard !isShowing else { return false }
        isShowing = true
        defer { isShowing = false }

        await requestTrackingAuthorizationIfNeeded()

        guard let ads = await getOrLoadAd(type) else {
            print("⚠️ Ad not ready")
            return false
        }

        let result = await ads.showWithResult()
        loadedAds.removeValue(forKey: type)

        Task {
            await loadAd(type)
        }

        return result
    }

    // 광고 표시
    func showAd(_ type: AdType) async {
        guard !isShowing else { return }
        isShowing = true
        defer { isShowing = false }

        await requestTrackingAuthorizationIfNeeded()

        guard let ads = await getOrLoadAd(type) else {
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

    func getOrLoadAd(_ type: AdType) async -> AdUnit? {
        if let ads = loadedAds[type], ads.isReady {
            return ads
        }
        await loadAd(type)
        return loadedAds[type]
    }
}
