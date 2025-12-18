//
//  RewardCalculator.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

struct RewardCalculator {
    private let user: User
    private let feverSystem: FeverSystem
    private let buffSystem: BuffSystem

    init(user: User, feverSystem: FeverSystem, buffSystem: BuffSystem) {
        self.user = user
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
    }

    /// 탭 당 획득 가능한 재산을 계산합니다.
    /// - Returns: 탭 당 재산
    func calculateMoneyPerTap() async -> Double {
        let skillLevels = await user.skillSet.currentSkillLevels
        let weights = Policy.skillUpgradeWeights

        var totalWeight = 0

        for (skillName, level) in skillLevels {
            guard
                let skillWeights = weights[skillName],
                let weight = skillWeights[level]
            else {
                continue
            }

            totalWeight += weight
        }

        // 기본 값에 스킬 가중치를 더하고 피버 배율, 버프 배율 적용
        let baseAmount = Double(totalWeight)
        let feverMultiplier = feverSystem.getCurrentMultiplier()
        let buffMultiplier = buffSystem.currentMultiplier

        return baseAmount * feverMultiplier * buffMultiplier
    }
}
