//
//  Skill.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class Skill: Hashable {
    /// 고유 스킬 정보 (게임 종류, 스킬 티어)
    let key: SkillKey
    /// 스킬 레벨
    var level: Int

    /// 획득 재화량
    var gainGold: Double {
        switch key.game {
        case .tap:
            switch key.tier {
            case .beginner:
                return Double(1 * level)
            case .intermediate:
                return Double(2 * level)
            case .advanced:
                return Double(3 * level)
            }
        case .language:
            switch key.tier {
            case .beginner:
                return Double(1 * level)
            case .intermediate:
                return Double(2 * level)
            case .advanced:
                return Double(3 * level)
            }
        case .dodge:
            switch key.tier {
            case .beginner:
                return Double(1 * level)
            case .intermediate:
                return Double(2 * level)
            case .advanced:
                return Double(3 * level)
            }
        case .stack:
            switch key.tier {
            case .beginner:
                return Double(1 * level)
            case .intermediate:
                return Double(2 * level)
            case .advanced:
                return Double(3 * level)
            }
        }
    }

    /// 업그레이드 비용
    var upgradeCost: Cost {
        switch key.tier {
        case .beginner:
            return .init(gold: (10 * level), diamond: level / 1000 * 10)
        case .intermediate:
            return .init(gold: (20 * level), diamond: level / 1000 * 10)
        case .advanced:
            return .init(gold: (30 * level), diamond: level / 1000 * 10)
        }
    }

    init(key: SkillKey, level: Int) {
        self.key = key
        self.level = level
    }

    /// 해당 스킬의 레벨을 1 상승 시킵니다.
    func upgrade() {
        guard level < key.tier.levelRange.maxValue else { return }
        level += 1
    }

    static func == (lhs: Skill, rhs: Skill) -> Bool {
        lhs.key == rhs.key
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

/// 스킬 정보를 키로 식별하여 관리
struct SkillKey: Hashable {
    let game: GameType
    let tier: SkillTier
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

    var levelRange: LevelRange {
        switch self {
        case .beginner: LevelRange(minValue: 1, maxValue: 9999)
        case .intermediate: LevelRange(minValue: 0, maxValue: 9999)
        case .advanced: LevelRange(minValue: 0, maxValue: 9999)
        }
    }
}

/// 레벨 범위 표현을 위한 타입
struct LevelRange {
    let minValue: Int
    let maxValue: Int

    func contains(_ level: Int) -> Bool {
        minValue <= level && level <= maxValue
    }

    func clamped(_ level: Int) -> Int {
        max(minValue, min(level, maxValue))
    }
}
