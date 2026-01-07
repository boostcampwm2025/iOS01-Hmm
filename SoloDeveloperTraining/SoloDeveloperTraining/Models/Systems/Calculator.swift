//
//  Calculator.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//


class Calculator {
    func calculateGoldGained(game: GameKind, user: User, feverMultiplier: Double, buffMultiplier: Double) -> Int {
        let actionPerGainGold = 1
        
        let result = Double(actionPerGainGold) * feverMultiplier * buffMultiplier
        return Int(result)
    }
}
