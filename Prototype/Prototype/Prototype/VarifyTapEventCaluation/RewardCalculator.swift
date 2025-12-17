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
        return 1.0
    }
}
