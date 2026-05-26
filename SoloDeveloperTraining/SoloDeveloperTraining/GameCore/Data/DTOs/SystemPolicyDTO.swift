//
//  SystemPolicyDTO.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/25/26.
//

struct SystemPolicyDTO: Codable {
    let autoGain: AutoGainDTO
    let buff: BuffDTO
    let scenario: ScenarioPolicyDTO?
    let offlineReward: OfflineRewardDTO?
}

struct AutoGainDTO: Codable {
    let interval: Double
}

struct BuffDTO: Codable {
    let decreaseInterval: Double
}

struct ScenarioPolicyDTO: Codable {
    let maxLevelupQueueSize: Int
}

struct OfflineRewardDTO: Codable {
    let minimumHours: Double
    let serverTimeTimeout: Double
    let allowedTimeDrift: Double
}
