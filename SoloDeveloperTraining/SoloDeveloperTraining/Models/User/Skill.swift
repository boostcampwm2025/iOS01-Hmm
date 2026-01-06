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

/// 업무 종류
enum GameKind {
    case tap
    case language
    case dodge
    case stack
    
    var displayTitle: String {
        switch self {
        case .tap: "코드짜기"
        case .language: "언어 맞추기"
        case .dodge: "버그 피하기"
        case .stack: "물건 쌓기"
        }
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
