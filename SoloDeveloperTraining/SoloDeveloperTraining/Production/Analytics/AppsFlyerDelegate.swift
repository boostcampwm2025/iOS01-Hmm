//
//  AppsFlyerDelegate.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/16/26.
//

import AppsFlyerLib

final class AppsFlyerDelegate: NSObject, AppsFlyerLibDelegate {
    static let shared = AppsFlyerDelegate()
    private override init() {}

    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        guard let status = conversionInfo["af_status"] as? String,
              status == "Non-organic",
              let isFTD = conversionInfo["is_first_launch"] as? Bool,
              isFTD else { return }

        let referrerShareID = conversionInfo["share_id"] as? String ?? ""
        let referrerDeviceID = conversionInfo["device_id"] as? String ?? ""
        let resultID = conversionInfo["result_id"] as? String ?? ""
        let entrySource = conversionInfo["entry_source"] as? String ?? "unknown"

        AnalyticsService.shared.logDeferredDeeplinkOpened(
            entrySource: entrySource,
            referrerShareID: referrerShareID,
            referrerDeviceID: referrerDeviceID,
            isDeferredDeeplink: true,
            resultID: resultID
        )
    }

    func onConversionDataFail(_ error: any Error) {
        print("❌ AppsFlyer 전환 데이터 실패: \(error)")
    }
}
