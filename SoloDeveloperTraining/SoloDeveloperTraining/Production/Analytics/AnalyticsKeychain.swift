//
//  AnalyticsKeychain.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/1/26.
//

import Foundation

enum AnalyticsKeychain {

    private static let deviceIDKey = "analytics_device_id"

    /// Keychain에 저장된 device_id 반환, 없으면 UUID 생성 후 저장
    @discardableResult
    static func getOrCreateDeviceID() -> String {
        if let existing = load(key: deviceIDKey) {
            return existing
        }
        let newID = UUID().uuidString
        save(key: deviceIDKey, value: newID)
        return newID
    }

    /// Keychain에 device_id가 없었으면 true (신규/재설치 유저)
    static func isNewInstall() -> Bool {
        return load(key: deviceIDKey) == nil
    }

    // MARK: - Private

    private static func save(key: String, value: String) {
        let data = Data(value.utf8)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private static func load(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
