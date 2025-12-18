//
//  RewardCalculator.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

struct RewardCalculator {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    /// 탭 당 획득 가능한 재산을 계산합니다.
    /// - Returns: 탭 당 재산
    func calculateMoneyPerTap() async -> Double {
        let skillLevels = await user.skillSet.currentSkillLevels
        let weights = Policy.skillUpgradeWeights
        
        var totalWeight = 0
        
        for (skillName, level) in skillLevels {
            guard let skillWeights = weights[skillName],
                  let weight = skillWeights[level],
                  skillName.contains("웹 개발")
            else { continue }
            
            totalWeight += weight
        }
        
        // 기본 탭 수익 1.0 + 스킬 가중치
        return Double(totalWeight)
    }
}

