//
//  Calculator.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import Foundation

class Calculator {
    func calculateGoldGained(game: GameType, user: User, feverMultiplier: Double, buffMultiplier: Double) -> Int {
        let actionPerGainGold = user.skills.filter { $0.game == .tap }.map { $0.multiplier }.reduce(0, +)
        let result = Double(actionPerGainGold) * feverMultiplier * buffMultiplier
        return Int(result)
    }
    
    func calculateGoldPerSecond(user: User) -> Int {
        let goldPerSecond = user.inventory.equipmentItems.map { $0.goldPerSecond }.reduce(0, +)
        return Int(goldPerSecond)
    }
}
