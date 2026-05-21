//
//  FeverPolicyDTO.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/24/26.
//

import Foundation

struct FeverPolicyDTO: Codable {
    let maxPercent: Double
    let decreaseInterval: TimeInterval
    let stageThreshold: FeverStageThresholdDTO
    let multiplier: FeverMultiplierDTO
    let tap: FeverTapDTO
    let language: FeverLanguageDTO
    let dodge: FeverDodgeDTO
    let stack: FeverStackDTO
}

struct FeverStageThresholdDTO: Codable {
    let stage0: Double
    let stage1: Double
    let stage2: Double
    let stage3: Double
}

struct FeverMultiplierDTO: Codable {
    let stage0: Double
    let stage1: Double
    let stage2: Double
    let stage3: Double
}

struct FeverTapDTO: Codable {
    let decreasePercent: Double
    let gainPerTap: Double
}

struct FeverLanguageDTO: Codable {
    let decreasePercent: Double
    let gainPerCorrect: Double
    let lossPerIncorrect: Double
}

struct FeverDodgeDTO: Codable {
    let decreasePercent: Double
    let gainPerSmallGold: Double
    let gainPerLargeGold: Double
    let gainPerBugDodge: Double
    let lossPerBugHit: Double
}

struct FeverStackDTO: Codable {
    let decreasePercent: Double
    let gainPerSuccess: Double
    let lossPerFailure: Double
}
