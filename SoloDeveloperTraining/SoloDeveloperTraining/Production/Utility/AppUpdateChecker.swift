//
//  AppUpdateChecker.swift
//  SoloDeveloperTraining
//

import Foundation
import UIKit

enum AppUpdateType {
    case none
    case optional
    case force
}

struct AppUpdateChecker {

    private static let appStoreID = "6758282441"
    private static let appStoreURL = URL(string: "https://apps.apple.com/kr/app/id\(appStoreID)")!
    private static let lookupURL = URL(string: "https://itunes.apple.com/lookup?id=\(appStoreID)&country=kr")!

    // MARK: - Public

    static func checkUpdate() async -> AppUpdateType {
        guard let storeVersion = await fetchStoreVersion() else { return .none }
        let currentVersion = currentAppVersion()
        return compareVersions(current: currentVersion, store: storeVersion)
    }

    static func openAppStore() {
        UIApplication.shared.open(appStoreURL)
    }

    static func snoozeOptionalUpdate() {
        AppPreferences.shared.optionalUpdateSnoozedUntil = Date().addingTimeInterval(60 * 60 * 24 * 7)
    }

    static func isOptionalUpdateSnoozed() -> Bool {
        guard let snoozedUntil = AppPreferences.shared.optionalUpdateSnoozedUntil else { return false }
        return Date() < snoozedUntil
    }

    // MARK: - Private

    private static func fetchStoreVersion() async -> String? {
        guard let (data, _) = try? await URLSession.shared.data(from: lookupURL),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let first = results.first,
              let version = first["version"] as? String else {
            return nil
        }
        return version
    }

    private static func currentAppVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    private static func compareVersions(current: String, store: String) -> AppUpdateType {
        let currentParts = current.split(separator: ".").compactMap { Int($0) }
        let storeParts = store.split(separator: ".").compactMap { Int($0) }

        let currentMajor = currentParts.count > 0 ? currentParts[0] : 0
        let storeMajor = storeParts.count > 0 ? storeParts[0] : 0

        let currentMinor = currentParts.count > 1 ? currentParts[1] : 0
        let storeMinor = storeParts.count > 1 ? storeParts[1] : 0

        let currentPatch = currentParts.count > 2 ? currentParts[2] : 0
        let storePatch = storeParts.count > 2 ? storeParts[2] : 0

        if storeMajor != currentMajor {
            return storeMajor > currentMajor ? .force : .none
        }
        if storeMinor != currentMinor {
            return storeMinor > currentMinor ? .optional : .none
        }
        if storePatch != currentPatch {
            return storePatch > currentPatch ? .optional : .none
        }
        return .none
    }
}
