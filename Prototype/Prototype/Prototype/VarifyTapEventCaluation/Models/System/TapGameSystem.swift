//
//  TapGameSystem.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

final class TapGameSystem {
    let user: User
    let rewardCalculator: RewardCalculator
    let feverSystem: FeverSystem
    
    init(user: User, rewardCalculator: RewardCalculator, feverSystem: FeverSystem) {
        self.user = user
        self.rewardCalculator = rewardCalculator
        self.feverSystem = feverSystem
    }
    
    /// 탭 이벤트를 수행하고 획득한 재산을 반환합니다.
    /// - Returns: 탭 당 획득한 돈
    func tap() async -> Double {
        let earnedMoney = await rewardCalculator.calculateMoneyPerTap()
        await user.wallet.money.earn(earnedMoney)
        return earnedMoney
    }
}
