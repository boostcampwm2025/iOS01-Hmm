//
//  AdService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/6/26.
//

import Foundation
import AppTrackingTransparency

enum AdType {
    case interstitial // 추가 ..
}

final class AdService {
    static let shared = AdService()

    private let hasATTRequestedKey = "AdService.hasATTRequested"
    private var hasATTRequested: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasATTRequestedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasATTRequestedKey)
        }
    }

    func showAd(of type: AdType) {
        requestTrackingAuthorizationIfNeeded()

        switch type {
        case .interstitial:
            loadInterstitialAd()
        }
    }
}

private extension AdService {
    func requestTrackingAuthorizationIfNeeded() {
        // 이미 ATT 요청했거나, iOS 14 미만이면 무시
        guard #available(iOS 14.5, *), !hasATTRequested else { return }

        Task {
            await MainActor.run {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        self.hasATTRequested = true
                        print("정보 추적 허용됨")
                    case .denied, .restricted, .notDetermined:
                        self.hasATTRequested = true
                        print("정보 추적 거부됨")
                    @unknown default:
                        break
                    }
                }
            }
        }
    }

    private func loadInterstitialAd() {
        print("전면 광고 로드")
    }
}
