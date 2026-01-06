//
//  Skill.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class Skill {
    /// 미니게임 종류
    let game: GameKind
    /// 스킬 등급
    var tier: SkillTier
    /// 스킬 레벨
    var level: Int
    
    init(game: GameKind, tier: SkillTier, level: Int) {
        self.game = game
        self.tier = tier
        self.level = level
    }
}

/// 스킬 등급
enum SkillTier: Int {
    case beginner = 0
    case intermediate = 1
    case advanced = 2
    
    var displayTitle: String {
        switch self {
        case .beginner: "초급"
        case .intermediate: "중급"
        case .advanced: "고급"
        }
    }
}
