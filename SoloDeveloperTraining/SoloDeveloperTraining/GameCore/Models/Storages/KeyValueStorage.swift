//
//  KeyValueStorage.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/27/26.
//

protocol KeyValueStorage {
    func set(key: String, value: Any)
    func integer(key: String) -> Int
    func register(defaults: [String: Any])
}
