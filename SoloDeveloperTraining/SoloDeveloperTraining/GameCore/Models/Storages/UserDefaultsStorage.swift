//
//  UserDefaultsStorage.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/27/26.
//

import Foundation

struct UserDefaultsStorage: KeyValueLocalStorage {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func register(defaults: [String: Any]) {
        userDefaults.register(defaults: defaults)
    }

    func set(key: String, value: Any) {
        userDefaults.set(value, forKey: key)
    }

    func integer(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    func bool(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    func any(key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
}
