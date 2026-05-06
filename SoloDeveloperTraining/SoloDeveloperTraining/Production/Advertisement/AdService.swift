//
//  AdService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/6/26.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency

enum AdType {
    case interstitial
}

final class AdService {

    static let shared = AdService()

    private var loadedAds: [AdType: AdUnit] = [:]

    private init() {}

    // 광고 로드
    func loadAd(_ type: AdType) async {
        let ad: AdUnit

        switch type {
        case .interstitial:
            ad = InterstitialAdUnit()
        }

        do {
            try await ad.load()
            loadedAds[type] = ad
        } catch {
            print("❌ Ad load failed: \(error.localizedDescription)")
        }
    }

    // 광고 표시
    func showAd(_ type: AdType) {
        guard let ad = loadedAds[type], ad.isReady else {
            print("⚠️ Ad not ready")
            return
        }

        ad.show()
        loadedAds.removeValue(forKey: type)

        // 다음 광고 preload
        Task {
            await loadAd(type)
        }
    }
}
