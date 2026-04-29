//
//  EquipmentPolicyDTO.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/25/26.
//

struct EquipmentPolicyDTO: Codable {
    let brokenUpgradeCost: Int
    let cheapUpgradeCost: Int
    let vintageUpgradeCost: Int
    let decentUpgradeCost: Int
    let premiumUpgradeCost: Int
    let diamondUpgradeCost: Int
    let limitedUpgradeCost: Int
    let nationalTreasureUpgradeCost: Int

    let brokenUpgradeDiamond: Int
    let cheapUpgradeDiamond: Int
    let vintageUpgradeDiamond: Int
    let decentUpgradeDiamond: Int
    let premiumUpgradeDiamond: Int
    let diamondUpgradeDiamond: Int
    let limitedUpgradeDiamond: Int
    let nationalTreasureUpgradeDiamond: Int

    let brokenSuccessRate: Double
    let cheapSuccessRate: Double
    let vintageSuccessRate: Double
    let decentSuccessRate: Double
    let premiumSuccessRate: Double
    let diamondSuccessRate: Double
    let limitedSuccessRate: Double
    let nationalTreasureSuccessRate: Double

    let keyboard: EquipmentItemDTO
    let mouse: EquipmentItemDTO
    let monitor: EquipmentItemDTO
    let chair: EquipmentItemDTO
}

struct EquipmentItemDTO: Codable {
    let brokenGoldPerSecond: Int
    let cheapGoldPerSecond: Int
    let vintageGoldPerSecond: Int
    let decentGoldPerSecond: Int
    let premiumGoldPerSecond: Int
    let diamondGoldPerSecond: Int
    let limitedGoldPerSecond: Int
    let nationalTreasureGoldPerSecond: Int
}
