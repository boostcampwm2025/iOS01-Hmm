//
//  AnalyticsKeychain.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/1/26.
//

import Foundation

enum AnalyticsKeychain {

    /// first_open 이미 로깅됐는지 확인
    static func hasLoggedFirstOpen(deviceID: String) -> Bool {
        let key = "first_open_logged_\(deviceID)"
        return load(key: key) != nil
    }

    /// first_open 로깅 완료 표시
    static func markFirstOpenLogged(deviceID: String) {
        let key = "first_open_logged_\(deviceID)"
        save(key: key, value: "true")
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
