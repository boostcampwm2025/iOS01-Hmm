//
//  Wallet.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

final class Wallet {
    private(set) var money: Money
    private(set) var diamond: Diamond
    
    init(money: Money, diamond: Diamond) {
        self.money = money
        self.diamond = diamond
    }
}
