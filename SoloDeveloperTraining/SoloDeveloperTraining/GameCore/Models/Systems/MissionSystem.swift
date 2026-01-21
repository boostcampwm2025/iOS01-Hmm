//
//  MissionSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

@Observable
final class MissionSystem {
    /// 모든 미션
    private(set) var missions: [Mission]
    /// 완료된 미션 유무 플래그
    private(set) var hasCompletedMission: Bool = false

    init(missions: [Mission]) {
        self.missions = missions
    }

    /// 기록을 통하여 현재 미션의 상태들을 업데이트 합니다.
    func updateCompletedMissions(record: Record) {
        missions
            .filter { $0.state == .inProgress }
            .forEach { $0.update(record: record) }

        checkHasCompletedMission()
    }

    func claimMissionReward(mission: Mission, wallet: Wallet) {
        let reward = mission.claim()
        wallet.addGold(reward.gold)
        wallet.addDiamond(reward.diamond)

        checkHasCompletedMission()
    }

    private func checkHasCompletedMission() {
        hasCompletedMission = missions.contains { $0.state == .claimable }
    }
}
