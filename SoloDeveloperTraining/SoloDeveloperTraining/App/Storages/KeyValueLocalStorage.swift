//
//  KeyValueLocalStorage.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/27/26.
//

import Foundation

protocol KeyValueLocalStorage {
    func register(defaults: [String: Any])
    func set(_ value: Any, forKey: String)
    func integer(key: String) -> Int
    func bool(key: String) -> Bool
    func any(key: String) -> Any?
}
