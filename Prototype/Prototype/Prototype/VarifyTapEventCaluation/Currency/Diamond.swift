//
//  Diamond.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

struct Diamond: Currency {
    private(set) var amount: Int32
    
    mutating func earn(_ value: Int32) {
        amount += value
    }
    
    mutating func spend(_ value: Int32) -> Bool {
        guard amount >= value else { return false }
        amount -= value
        return true
    }
}
