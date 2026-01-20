//
//  SkillSystem.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/20/26.
//

import Foundation

struct SkillState {
    let skill: Skill
    let canUnlock: Bool
}

final class SkillSystem {
    private let user: User

    init(user: User) {
        self.user = user
    }

    /// 유저의 스킬 리스트를 정렬하여 반환
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
            .compactMap{ $0 }
            .map{
                skill in SkillState(
                    skill: skill,
                    canUnlock: canUnlock(skill: skill)
                )
            }
    }
}

private extension SkillSystem {
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
            guard let intermediateSkill = getPreviousTierSkill(key: .init(game: skill.key.game, tier: .beginner)) else {
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
