//
//  SkillSystem.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/20/26.
//

import Foundation

struct SkillState {
    let skill: Skill
    let itemState: ItemState
}

final class SkillSystem {
    private let user: User

    init(user: User) {
        self.user = user
    }

    /// 스킬 리스트를 정렬하여 반환
    func skillList() -> [SkillState] {
        let gameTypeCount = GameType.allCases.count
        let skillTierCount = SkillTier.allCases.count

        var buckets: [Skill?] = Array(
            repeating: nil,
            count: gameTypeCount * skillTierCount
        )
        for skill in user.skills {
            let gameIndex = skill.key.game.rawValue
            let tierIndex = skill.key.tier.rawValue
            let bucketIndex = gameIndex * skillTierCount + tierIndex
            buckets[bucketIndex] = skill
        }
        return buckets
            .compactMap { $0 }
            .map { skill in SkillState(
                skill: skill,
                itemState: getItemState(for: skill))
            }
    }

    /// 스킬 항목을 구매하여 레벨 업그레이드
    func upgrade(skill: Skill) throws {
        guard canUnlock(skill: skill) else {
            throw PurchasingError.locked
        }
        guard skill.upgradeCost.gold <= user.wallet.gold else {
            throw PurchasingError.insufficientGold
        }
        guard skill.upgradeCost.diamond <= user.wallet.diamond else {
            throw PurchasingError.insufficientDiamond
        }

        let costBeforeUpgrade = skill.upgradeCost
        try skill.upgrade()
        pay(cost: costBeforeUpgrade)
    }
}

private extension SkillSystem {
    func pay(cost: Cost) {
        user.wallet.spendGold(cost.gold)
        user.wallet.spendDiamond(cost.diamond)
    }

    func getItemState(for skill: Skill) -> ItemState {
        let canUnlock = canUnlock(skill: skill)
        let cost = skill.upgradeCost
        let canAfford = cost.gold <= user.wallet.gold && cost.diamond <= user.wallet.diamond
        
        return ItemState(canUnlock: canUnlock, canAfford: canAfford)
    }

    func canUnlock(skill: Skill) -> Bool {
        let unlockLevel: Int

        switch skill.key.game {
        case .tap:
            switch skill.key.tier {
            case .beginner:
                return true
            case .intermediate:
                unlockLevel = Policy.Skill.Tap.intermediateUnlockLevel
            case .advanced:
                unlockLevel = Policy.Skill.Tap.advancedUnlockLevel
            }
        case .language:
            switch skill.key.tier {
            case .beginner:
                return true
            case .intermediate:
                unlockLevel = Policy.Skill.Language.intermediateUnlockLevel
            case .advanced:
                unlockLevel = Policy.Skill.Language.advancedUnlockLevel
            }
        case .dodge:
            switch skill.key.tier {
            case .beginner:
                return true
            case .intermediate:
                unlockLevel = Policy.Skill.Dodge.intermediateUnlockLevel
            case .advanced:
                unlockLevel = Policy.Skill.Dodge.advancedUnlockLevel
            }
        case .stack:
            switch skill.key.tier {
            case .beginner:
                return true
            case .intermediate:
                unlockLevel = Policy.Skill.Stack.intermediateUnlockLevel
            case .advanced:
                unlockLevel = Policy.Skill.Stack.advancedUnlockLevel
            }
        }

        // intermediate나 advanced인 경우
        let previousTier: SkillTier = skill.key.tier == .intermediate ? .beginner : .intermediate
        guard let previousSkill = getPreviousTierSkill(key: .init(game: skill.key.game, tier: previousTier)) else {
            return false
        }
        return previousSkill.level >= unlockLevel
    }

    func getPreviousTierSkill(key: SkillKey) -> Skill? {
        guard let previousTierSkill = user.skills.first(where: {$0.key == key}) else {
            return nil
        }
        return previousTierSkill
    }
}
