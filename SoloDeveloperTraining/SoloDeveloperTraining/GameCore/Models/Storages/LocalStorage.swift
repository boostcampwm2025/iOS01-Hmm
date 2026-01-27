//
//  LocalStorage.swift
//  SoloDeveloperTraining
//
//  Created by Claude Code on 1/27/26.
//

import Foundation

/// KeyValueLocalStorage를 활용한 프로퍼티 래퍼
/// 영구 저장이 필요한 프로퍼티에 사용
@propertyWrapper
struct LocalStorage<T> {
    let key: String
    let defaultValue: T
    let storage: KeyValueLocalStorage

    init(key: String, defaultValue: T, storage: KeyValueLocalStorage = UserDefaultsStorage()) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }

    var wrappedValue: T {
        get {
            switch T.self {
            case is Int.Type:
                return storage.integer(key: key) as? T ?? defaultValue
            case is Bool.Type:
                return storage.bool(key: key) as? T ?? defaultValue
            default:
                return storage.any(key: key) as? T ?? defaultValue
            }
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}
