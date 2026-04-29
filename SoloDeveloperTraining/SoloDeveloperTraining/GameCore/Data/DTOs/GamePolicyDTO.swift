//
//  GamePlicy.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/24/26.
//

struct GameUnlockPolicyDTO: Codable {
    let tap: Int
    let language: Int
    let dodge: Int
    let stack: Int
}

struct GamePolicyDTO: Codable {
    let language: GameLanguageDTO
    let dodge: GameDodgeDTO
    let stack: GameStackDTO
    let quiz: GameQuizDTO
}

struct GameLanguageDTO: Codable {
    let incorrectGoldLossMultiplier: Double
}

struct GameDodgeDTO: Codable {
    let smallGoldMultiplier: Double
    let largeGoldMultiplier: Double
    let bugHitLossGoldMultiplier: Double
    let bugDodgeGoldMultiplier: Double

    let updateFPS: Double
    let spawnInterval: Double
    let fallSpeed: Double

    let smallGoldSpawnRate: Int
    let largeGoldSpawnRate: Int
    let bugSpawnRate: Int

    let motion: MotionDTO

    struct MotionDTO: Codable {
        let deadZoneThreshold: Double
        let maxSpeed: Double
        let minSpeed: Double
    }
}

struct GameStackDTO: Codable {
    let failureGoldLossMultiplier: Double
}

struct GameQuizDTO: Codable {
    let questionsPerGame: Int
    let secondsPerQuestion: Int
    let diamondsPerCorrect: Int
}
