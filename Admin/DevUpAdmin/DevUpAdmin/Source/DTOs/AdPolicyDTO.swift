//
//  AdPolicyDTO.swift
//  DevUpAdmin
//

struct AdPolicyDTO: Codable {
    let skillReward: SkillRewardDTO
}

struct SkillRewardDTO: Codable {
    let dailyLimit: Int
    let rewardMultiplier: Double
    let rewardDuration: Double
}
