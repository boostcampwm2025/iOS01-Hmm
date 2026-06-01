//
//  AnalyticsKeychain.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/1/26.
//

import Foundation

enum AnalyticsKeychain {

    private static let firstOpenKey = "first_open_logged"

    static func hasLoggedFirstOpen() -> Bool {
        return load(key: firstOpenKey) != nil
    }

    static func markFirstOpenLogged() {
        save(key: firstOpenKey, value: "true")
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
