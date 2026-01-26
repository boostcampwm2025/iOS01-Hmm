//
//  MissionSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

@Observable
final class MissionSystem {
    /// 모든 미션
    private(set) var missions: [Mission]
    /// 완료된 미션 유무 플래그
    private(set) var hasCompletedMission: Bool = false

    /// 총 미션 수
    var allCount: Int {
        missions.count
    }
    /// 획득한 미션 수
    var claimedCount: Int {
        missions.count { $0.state == .claimed }
    }

    init(missions: [Mission]) {
        self.missions = missions
        sortMissions()
    }

    /// 기록을 통하여 현재 미션의 상태들을 업데이트 합니다.
    func updateCompletedMissions(record: Record) {
        missions
            .filter { $0.state == .inProgress }
            .forEach { $0.update(record: record) }

        sortMissions()
        checkHasCompletedMission()
    }

    func claimMissionReward(mission: Mission, wallet: Wallet) {
        let reward = mission.claim()
        wallet.addGold(reward.gold)
        wallet.addDiamond(reward.diamond)

        sortMissions()
        checkHasCompletedMission()
    }

    private func checkHasCompletedMission() {
        hasCompletedMission = missions.contains { $0.state == .claimable }
    }

    private func sortMissions() {
        missions.sort { $0.state.rawValue < $1.state.rawValue }
    }
}
