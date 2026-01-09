//
//  AchievementSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

@Observable
final class AchievementSystem {
    /// 모든 미션
    private(set) var allAchievements: [Achievement]
    /// 완료된 미션 유무 플래그
    private(set) var hasCompletedAchievement: Bool = false

    init(allAchievements: [Achievement]) {
        self.allAchievements = allAchievements
    }

    /// 기록을 통하여 현재 미션의 상태들을 업데이트 합니다.
    func updateCompletedAchievements(record: Record) {
        let inProgress = allAchievements.filter { $0.state == .inProgress }
        inProgress.forEach { achievement in
            achievement.update(record: record)
            if achievement.completeCondition(record) {
                achievement.complete()
            }
        }

        checkHasCompletedAchievement()
    }

    func claimAchievement(achievement: Achievement, wallet: Wallet) {
        let reward = achievement.claim()
        wallet.addGold(reward.gold)
        wallet.addDiamond(reward.diamond)

        checkHasCompletedAchievement()
    }

    private func checkHasCompletedAchievement() {
        hasCompletedAchievement = allAchievements.contains { $0.state == .unclaimed }
    }
}
