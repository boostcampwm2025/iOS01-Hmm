//
//  Skill.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 스킬 정보를 키로 식별하여 관리
struct SkillKey: Hashable {
    let game: GameType
    let tier: SkillTier
}

final class Skill: Hashable {
    /// 고유 스킬 정보 (게임 종류, 스킬 티어)
    let key: SkillKey

    /// 스킬 레벨
    private(set) var level: Int

    /// 획득 재화량
    var gainGold: Double {
        let baseGold: Int
        let multiplier: Int

        switch key.game {
        case .tap:
            baseGold = Policy.Skill.Tap.baseGold
            switch key.tier {
            case .beginner:
                multiplier = Policy.Skill.Tap.beginnerGoldMultiplier
            case .intermediate:
                multiplier = Policy.Skill.Tap.intermediateGoldMultiplier
            case .advanced:
                multiplier = Policy.Skill.Tap.advancedGoldMultiplier
            }
        case .language:
            baseGold = Policy.Skill.Language.baseGold
            switch key.tier {
            case .beginner:
                multiplier = Policy.Skill.Language.beginnerGoldMultiplier
            case .intermediate:
                multiplier = Policy.Skill.Language.intermediateGoldMultiplier
            case .advanced:
                multiplier = Policy.Skill.Language.advancedGoldMultiplier
            }
        case .dodge:
            baseGold = Policy.Skill.Dodge.baseGold
            switch key.tier {
            case .beginner:
                multiplier = Policy.Skill.Dodge.beginnerGoldMultiplier
            case .intermediate:
                multiplier = Policy.Skill.Dodge.intermediateGoldMultiplier
            case .advanced:
                multiplier = Policy.Skill.Dodge.advancedGoldMultiplier
            }
        case .stack:
            baseGold = Policy.Skill.Stack.baseGold
            switch key.tier {
            case .beginner:
                multiplier = Policy.Skill.Stack.beginnerGoldMultiplier
            case .intermediate:
                multiplier = Policy.Skill.Stack.intermediateGoldMultiplier
            case .advanced:
                multiplier = Policy.Skill.Stack.advancedGoldMultiplier
            }
        }

        return Double(baseGold + multiplier * level)
    }

    /// 이미지 리소스
    var imageName: String {
        let gameName: String = {
            switch key.game {
            case .tap: return "tap"
            case .language: return "language"
            case .dodge: return "dodge"
            case .stack: return "stack"
            }
        }()

        let tierNumber: Int = {
            switch key.tier {
            case .beginner: return 1
            case .intermediate: return 2
            case .advanced: return 3
            }
        }()

        return "skill_\(gameName)_\(tierNumber)"
    }

    /// 스킬 타이틀
    var title: String {
        return "\(key.game.displayTitle) \(key.tier.displayTitle) Lv.\(level)"
    }

    /// 업그레이드 비용
    var upgradeCost: Cost {
        let goldCostMultiplier: Int
        let diamondCostDivider: Int
        let diamondCostMultiplier: Int

        switch key.game {
        case .tap:
            switch key.tier {
            case .beginner:
                goldCostMultiplier = Policy.Skill.Tap.beginnerGoldCostMultiplier
            case .intermediate:
                goldCostMultiplier = Policy.Skill.Tap.intermediateGoldCostMultiplier
            case .advanced:
                goldCostMultiplier = Policy.Skill.Tap.advancedGoldCostMultiplier
            }
            diamondCostDivider = Policy.Skill.Tap.diamondCostDivider
            diamondCostMultiplier = Policy.Skill.Tap.diamondCostMultiplier
        case .language:
            switch key.tier {
            case .beginner:
                goldCostMultiplier = Policy.Skill.Language.beginnerGoldCostMultiplier
            case .intermediate:
                goldCostMultiplier = Policy.Skill.Language.intermediateGoldCostMultiplier
            case .advanced:
                goldCostMultiplier = Policy.Skill.Language.advancedGoldCostMultiplier
            }
            diamondCostDivider = Policy.Skill.Language.diamondCostDivider
            diamondCostMultiplier = Policy.Skill.Language.diamondCostMultiplier
        case .dodge:
            switch key.tier {
            case .beginner:
                goldCostMultiplier = Policy.Skill.Dodge.beginnerGoldCostMultiplier
            case .intermediate:
                goldCostMultiplier = Policy.Skill.Dodge.intermediateGoldCostMultiplier
            case .advanced:
                goldCostMultiplier = Policy.Skill.Dodge.advancedGoldCostMultiplier
            }
            diamondCostDivider = Policy.Skill.Dodge.diamondCostDivider
            diamondCostMultiplier = Policy.Skill.Dodge.diamondCostMultiplier
        case .stack:
            switch key.tier {
            case .beginner:
                goldCostMultiplier = Policy.Skill.Stack.beginnerGoldCostMultiplier
            case .intermediate:
                goldCostMultiplier = Policy.Skill.Stack.intermediateGoldCostMultiplier
            case .advanced:
                goldCostMultiplier = Policy.Skill.Stack.advancedGoldCostMultiplier
            }
            diamondCostDivider = Policy.Skill.Stack.diamondCostDivider
            diamondCostMultiplier = Policy.Skill.Stack.diamondCostMultiplier
        }

        return .init(
            gold: goldCostMultiplier * level,
            diamond: ((level+1) % diamondCostDivider == 0) ? diamondCostMultiplier : 0
        )
    }

    init(key: SkillKey, level: Int? = nil) {
        self.key = key
        self.level = key.tier.levelRange.clamped(level ?? key.tier.levelRange.minValue)
    }

    /// 해당 스킬의 레벨을 1 상승 시킵니다.
    func upgrade() throws {
        guard key.tier.levelRange.canUpgrade(from: level) else {
            throw SkillError.levelExceeded
        }
        level += 1
    }

    static func == (lhs: Skill, rhs: Skill) -> Bool {
        lhs.key == rhs.key
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}
