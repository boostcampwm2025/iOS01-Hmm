//
//  User.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

@MainActor
final class User {
    /// 유저 식별용 ID
    let id: UUID
    /// 유저 닉네임
    let nickname: String
    /// 커리어
    var career: Career
    /// 지갑 [재산, 다이아]
    let wallet: Wallet
    /// 인벤토리 [장비, 소비, 부동산] 아이템
    let inventory: Inventory
    /// 게임 기록
    let record: Record

    /// 보유 스킬
    let skills: Set<Skill>

    init(
        id: UUID = UUID(),
        nickname: String,
        career: Career = .unemployed,
        wallet: Wallet,
        inventory: Inventory,
        record: Record,
        skills: Set<Skill> = []
    ) {
        self.id = id
        self.nickname = nickname
        self.career = career
        self.wallet = wallet
        self.inventory = inventory
        self.record = record
        self.skills = skills
    }

    func updateCareer(to newCareer: Career) {
        career = newCareer
    }

    convenience init(nickname: String) {
        self.init(
            nickname: nickname,
            wallet: .init(),
            inventory: .init(
                equipmentItems: [
                    .init(type: .chair, tier: .broken),
                    .init(type: .keyboard, tier: .broken),
                    .init(type: .monitor, tier: .broken),
                    .init(type: .mouse, tier: .broken)
                ],
                housing: .init(tier: .street)
            ),
            record: .init(),
            skills: [
                .init(key: SkillKey(game: .tap, tier: .beginner)),
                .init(key: SkillKey(game: .tap, tier: .intermediate)),
                .init(key: SkillKey(game: .tap, tier: .advanced)),
                .init(key: SkillKey(game: .language, tier: .beginner)),
                .init(key: SkillKey(game: .language, tier: .intermediate)),
                .init(key: SkillKey(game: .language, tier: .advanced)),
                .init(key: SkillKey(game: .dodge, tier: .beginner)),
                .init(key: SkillKey(game: .dodge, tier: .intermediate)),
                .init(key: SkillKey(game: .dodge, tier: .advanced)),
                .init(key: SkillKey(game: .stack, tier: .beginner)),
                .init(key: SkillKey(game: .stack, tier: .intermediate)),
                .init(key: SkillKey(game: .stack, tier: .advanced))
            ]
        )
    }

    // MARK: - Rebirth

    /// 환생: 게임 상태를 초기화하고 환생 기록을 업데이트
    /// - Parameter ending: 달성한 최종 엔딩
    func resetForRebirth(ending: Ending) {
        // 환생 기록 업데이트 (초기화 전에 먼저 기록)
        record.rebirthCount += 1
        record.allEndingsAchieved.insert(ending)

        // 커리어 초기화
        career = .unemployed

        // 재화 초기화
        wallet.reset()

        // 인벤토리 초기화
        inventory.resetToInitial()

        // 스킬 초기화
        for skill in skills {
            skill.resetLevel()
        }

        // 게임 기록 초기화 (환생 기록 제외)
        record.resetForRebirth()
    }
}
