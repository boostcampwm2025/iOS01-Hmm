//
//  Wallet.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

class Wallet {
    private(set) var gold: Int
    private(set) var diamond: Int

    init(gold: Int = 0, diamond: Int = 0) {
        self.gold = gold
        self.diamond = diamond
    }

    func addGold(_ amount: Int) {
        guard amount > 0 else { return }
        gold += amount
    }
}
