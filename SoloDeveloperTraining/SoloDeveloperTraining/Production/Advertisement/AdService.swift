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
    private var loadingTasks: [AdType: Task<AdUnit?, Never>] = [:]
    private var isShowing = false

    init(factory: AdFactory) {
        self.factory = factory
    }

    // 광고 로드
    func loadAd(_ type: AdType) async {
        await loadAdIfNeeded(type)
    }

    // 광고 표시 후 결과 반환 (true: 정상 시청 완료, false: 실패)
    func showAdWithResult(_ type: AdType) async -> Bool {
        guard !isShowing else { return false }
        isShowing = true
        defer { isShowing = false }

        await requestTrackingAuthorizationIfNeeded()

        guard let ads = await loadAdIfNeeded(type) else {
            print("⚠️ Ad not ready")
            return false
        }

        loadedAds.removeValue(forKey: type)
        let result = await ads.showWithResult()

        Task {
            await loadAd(type)
        }

        return result
    }
}

private extension AdService {
    @discardableResult
    func loadAdIfNeeded(_ type: AdType) async -> AdUnit? {
        if let ads = loadedAds[type], ads.isReady {
            return ads
        }

        // 이미 로딩중인 광고가 있는 경우, 추가 요청 없이 기다린 후 받아옵니다.
        if let loadingTask = loadingTasks[type] {
            let ads = await loadingTask.value
            if let ads {
                loadedAds[type] = ads
            }
            return ads
        }

        let loadingTask = Task<AdUnit?, Never> {
            let ads = self.factory.makeAdUnit(for: type)
            do {
                try await ads.load()
                return ads
            } catch {
                print("❌ Ad load failed: \(error.localizedDescription)")
                return nil
            }
        }

        loadingTasks[type] = loadingTask

        let ads = await loadingTask.value
        loadingTasks[type] = nil

        if let ads {
            loadedAds[type] = ads
        } else {
            loadedAds.removeValue(forKey: type)
        }

        return ads
    }

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
