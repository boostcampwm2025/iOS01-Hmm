//
//  Skill.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class Skill: Identifiable {
    /// 미니게임 종류
    let game: GameType
    /// 스킬 등급
    var tier: SkillTier
    /// 스킬 레벨
    var level: Int

    /// 가중치
    var multiplier: Double {
        switch game {
        case .tap:
            switch tier {
            case .beginner:
                return Double(1 * level)
            case .intermediate:
                return Double(2 * level)
            case .advanced:
                return Double(3 * level)
            }
        case .language:
            switch tier {
            case .beginner:
                return Double(1 * level)
            case .intermediate:
                return Double(2 * level)
            case .advanced:
                return Double(3 * level)
            }
        case .dodge:
            switch tier {
            case .beginner:
                return Double(1 * level)
            case .intermediate:
                return Double(2 * level)
            case .advanced:
                return Double(3 * level)
            }
        case .stack:
            switch tier {
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
        // TODO: 리소스 추가 후 수정 필요
        "background_street"
    }

    /// 스킬 타이틀
    var title: String {
        return "\(game.displayTitle) \(tier.displayTitle) Lv.\(level)"
    }

    var description: String {
        // TODO: 현재는 가중치로 적용되었지만, Calculator 혹은 정확한 추가 골드를 표시하게 해야 하는지.
        return "획득 골드 +\(Int(multiplier))"
    }

    /// 업그레이드 비용
    var upgradeCost: Cost {
        switch tier {
        case .beginner:
            return .init(gold: (10 * level))
        case .intermediate:
            return .init(gold: (20 * level))
        case .advanced:
            return .init(gold: (30 * level))
        }
    }

    init(game: GameType, tier: SkillTier, level: Int) {
        self.game = game
        self.tier = tier
        self.level = level
    }

    /// 해당 스킬의 레벨을 1 상승 시킵니다.
    func upgrade() {
        guard level < 9999 else { return }
        level += 1
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
