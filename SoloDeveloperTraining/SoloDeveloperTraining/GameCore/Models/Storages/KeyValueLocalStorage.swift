//
//  KeyValueLocalStorage.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/27/26.
//

protocol KeyValueLocalStorage {
    func set(key: String, value: Any)
    func integer(key: String) -> Int
    func bool(key: String) -> Bool
    func register(defaults: [String: Any])
}
