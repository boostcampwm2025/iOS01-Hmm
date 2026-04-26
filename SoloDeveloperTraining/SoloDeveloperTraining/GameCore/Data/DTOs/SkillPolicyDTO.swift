//
//  SkillPolicyDTO.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/25/26.
//

struct SkillPolicyDTO: Codable {
    let beginnerMinLevel: Int
    let beginnerMaxLevel: Int
    let intermediateMinLevel: Int
    let intermediateMaxLevel: Int
    let advancedMinLevel: Int
    let advancedMaxLevel: Int

    let tap: SkillTapDTO
    let language: SkillLanguageDTO
    let dodge: SkillDodgeDTO
    let stack: SkillStackDTO
}

struct SkillTapDTO: Codable {
    let baseGold: Int

    let beginnerGoldMultiplier: Int
    let intermediateGoldMultiplier: Int
    let advancedGoldMultiplier: Int

    let beginnerGoldCostMultiplier: Int
    let intermediateGoldCostMultiplier: Int
    let advancedGoldCostMultiplier: Int
    let diamondCostDivider: Int
    let diamondCostMultiplier: Int

    let intermediateUnlockLevel: Int
    let advancedUnlockLevel: Int
}

struct SkillLanguageDTO: Codable {
    let baseGold: Int

    let beginnerGoldMultiplier: Int
    let intermediateGoldMultiplier: Int
    let advancedGoldMultiplier: Int

    let beginnerGoldCostMultiplier: Int
    let intermediateGoldCostMultiplier: Int
    let advancedGoldCostMultiplier: Int
    let diamondCostDivider: Int
    let diamondCostMultiplier: Int

    let intermediateUnlockLevel: Int
    let advancedUnlockLevel: Int
}

struct SkillDodgeDTO: Codable {
    let baseGold: Int

    let beginnerGoldMultiplier: Int
    let intermediateGoldMultiplier: Int
    let advancedGoldMultiplier: Int

    let beginnerGoldCostMultiplier: Int
    let intermediateGoldCostMultiplier: Int
    let advancedGoldCostMultiplier: Int
    let diamondCostDivider: Int
    let diamondCostMultiplier: Int

    let intermediateUnlockLevel: Int
    let advancedUnlockLevel: Int
}

struct SkillStackDTO: Codable {
    let baseGold: Int

    let beginnerGoldMultiplier: Int
    let intermediateGoldMultiplier: Int
    let advancedGoldMultiplier: Int

    let beginnerGoldCostMultiplier: Int
    let intermediateGoldCostMultiplier: Int
    let advancedGoldCostMultiplier: Int
    let diamondCostDivider: Int
    let diamondCostMultiplier: Int

    let intermediateUnlockLevel: Int
    let advancedUnlockLevel: Int
}
