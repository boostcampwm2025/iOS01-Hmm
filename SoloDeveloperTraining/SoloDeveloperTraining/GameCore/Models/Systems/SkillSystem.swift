//
//  SkillSystem.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/20/26.
//

import Foundation

struct SkillState {
    let skill: Skill
    let locked: Bool
}

final class SkillSystem {
    private let user: User

    init(user: User) {
        self.user = user
    }

    /// 스킬 리스트를 정렬하여 반환
    func skillList() -> [SkillState] {
        var buckets: [Skill?] = Array(
            repeating: nil,
            count: GameType.allCases.count * SkillTier.allCases.count
        )
        for skill in user.skills {
            let gameIndex = skill.key.game.rawValue
            let tierIndex = skill.key.tier.rawValue
            let bucketIndex = gameIndex * SkillTier.allCases.count + tierIndex
            buckets[bucketIndex] = skill
        }
        return buckets
            .compactMap { $0 }
            .map { skill in SkillState(
                skill: skill,
                locked: !canUnlock(skill: skill))
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
        guard skill.upgradeCost.diamond <= user.wallet.diamond else { throw PurchasingError.insufficientDiamond }

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

    func canUnlock(skill: Skill) -> Bool {
        switch skill.key.tier {
        case .beginner:
            // TODO: - 각 게임의 해금 조건과 동일하도록 수정
            return true
        case .intermediate:
            guard let beginnerSkill = getPreviousTierSkill(key: .init(game: skill.key.game, tier: .beginner)) else {
                return false
            }
            return beginnerSkill.level >= 1000
        case .advanced:
            guard let intermediateSkill = getPreviousTierSkill(key: .init(game: skill.key.game, tier: .intermediate)) else {
                return false
            }
            return intermediateSkill.level >= 1000
        }
    }

    func getPreviousTierSkill(key: SkillKey) -> Skill? {
        guard let previousTierSkill = user.skills.first(where: {$0.key == key}) else {
            return nil
        }
        return previousTierSkill
    }
}
