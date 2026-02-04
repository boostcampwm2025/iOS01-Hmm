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
    /// - Note: 비동기로 처리되어 즉시 반환
    /// - Parameter record: 업데이트할 Record
    func updateCompletedMissions(record: Record) {
        // 메인 큐에 비동기로 추가 (즉시 반환, 순서 보장, 누락 없음)
        DispatchQueue.main.async { [weak self] in
            self?.performMissionUpdate(record: record)
        }
    }

    func claimMissionReward(mission: Mission, wallet: Wallet) {
        let reward = mission.claim()
        wallet.addGold(reward.gold)
        wallet.addDiamond(reward.diamond)

        sortMissions()
        checkHasCompletedMission()
    }
}

// MARK: - Helper
private extension MissionSystem {
    /// 실제 미션 업데이트 수행 (메인 스레드, 비동기)
    func performMissionUpdate(record: Record) {
        missions
            .filter { $0.state == .inProgress }
            .forEach { $0.update(record: record) }

        sortMissions()
        checkHasCompletedMission()
    }

    func checkHasCompletedMission() {
        hasCompletedMission = missions.contains { $0.state == .claimable }
    }

    func sortMissions() {
        missions.sort { $0.state.rawValue < $1.state.rawValue }
    }
}
