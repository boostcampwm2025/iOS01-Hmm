//
//  Calculator.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import Foundation

class Calculator {
    /// 게임 액션당 획득 골드 계산
    func calculateGoldGained(game: GameType, user: User, feverMultiplier: Double, buffMultiplier: Double) -> Int {
        let actionPerGainGold = user.skills.filter { $0.game == .tap }.map { $0.multiplier }.reduce(0, +)
        let result = Double(actionPerGainGold) * feverMultiplier * buffMultiplier
        return Int(result)
    }

    /// 초당 획득 골드 계산
    func calculateGoldPerSecond(user: User) -> Int {
        let goldPerSecond = user.inventory.equipmentItems.map { $0.goldPerSecond }.reduce(0, +)
        let housingGoldPerSecond = user.inventory.housing.goldPerSecond
        // 장비 아이템 + 부동산 아이템 초당 골드
        return Int(goldPerSecond) + housingGoldPerSecond
    }
}
