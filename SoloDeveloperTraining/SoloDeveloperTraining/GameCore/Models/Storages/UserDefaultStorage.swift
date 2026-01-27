//
//  UserDefaultStorage.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/27/26.
//

import Foundation

struct UserDefaultStorage: KeyValueLocalStorage {
    func set(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func integer(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func bool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    func register(defaults: [String: Any]) {
        UserDefaults.standard.register(defaults: defaults)
    }
 }
