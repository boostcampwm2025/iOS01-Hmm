//
//  SkillDTO.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-26.
//

import Foundation

struct SkillDTO: Codable {
    let game: GameTypeDTO
    let tier: SkillTierDTO
    let level: Int

    init(from skill: Skill) {
        self.game = GameTypeDTO(from: skill.key.game)
        self.tier = SkillTierDTO(from: skill.key.tier)
        self.level = skill.level
    }

    func toSkill() -> Skill {
        Skill(key: SkillKey(game: game.toGameType(), tier: tier.toSkillTier()), level: level)
    }
}

struct GameTypeDTO: Codable {
    let rawValue: Int

    init(from type: GameType) {
        self.rawValue = type.rawValue
    }

    func toGameType() -> GameType {
        GameType(rawValue: rawValue) ?? .tap
    }
}

struct SkillTierDTO: Codable {
    let rawValue: Int

    init(from tier: SkillTier) {
        self.rawValue = tier.rawValue
    }

    func toSkillTier() -> SkillTier {
        SkillTier(rawValue: rawValue) ?? .beginner
    }
}
