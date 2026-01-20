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

final class Skill: Hashable, Identifiable {
    /// 고유 스킬 정보 (게임 종류, 스킬 티어)
    let key: SkillKey

    /// 스킬 레벨
    private(set) var level: Int

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

        return "enhance_\(gameName)_\(tierNumber)"
    }

    /// 스킬 타이틀
    var title: String {
        return "\(key.game.displayTitle) \(key.tier.displayTitle) Lv.\(level)"
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
        self.level = key.tier.levelRange.clamped(level)
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
