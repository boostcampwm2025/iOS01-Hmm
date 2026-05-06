//
//  InterstitialAdUnit.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/6/26.
//

import GoogleMobileAds

final class InterstitialAdUnit: NSObject, AdUnit {
    private var interstitialAd: InterstitialAd?

    var adUnitID: String = "ca-app-pub-3940256099942544/4411468910"

    var isReady: Bool {
        return interstitialAd != nil
    }

    func load() async throws {
        interstitialAd = try await InterstitialAd.load(
            with: adUnitID,
            request: Request()
        )
        interstitialAd?.fullScreenContentDelegate = self
    }

    func show() {
        guard let interstitialAd else {
            print("❌ Ad not ready")
            return
        }
        interstitialAd.present(from: nil)
    }
}

// MARK: - 광고 표시/진행/노출 콜백 메서드
extension InterstitialAdUnit: FullScreenContentDelegate {
    // 광고 표시에 실패한 경우
    func ad(
        _ ads: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("\(#function) called")
        interstitialAd = nil
    }

    // 광고 화면이 닫혔을 경우
    func adDidDismissFullScreenContent(_ ads: FullScreenPresentingAd) {
        print("\(#function) called")
        interstitialAd = nil
    }
}
