//
//  Money.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

struct Money: Currency {
    private(set) var amount: Double
    
    mutating func earn(_ value: Double) {
        amount += value
    }
    
    mutating func spend(_ value: Double) -> Bool {
        guard amount >= value else { return false }
        amount -= value
        return true
    }
}
