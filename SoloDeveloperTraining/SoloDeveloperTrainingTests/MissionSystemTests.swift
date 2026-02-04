//
//  MissionSystemTests.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 2/4/26.
//

import Testing
import Foundation
@testable import SoloDeveloperTraining

@MainActor
struct MissionSystemTests {

    @Test("기본 미션 업데이트 동작 검증")
    func testBasicMissionUpdate() async throws {
        // Given: 목표 10인 언어 미션 생성
        let mission = Mission(
            id: 1,
            type: .languageMatch(.bronze),
            title: "언어 10회 성공",
            description: "언어 게임 10회 성공하기",
            targetValue: 10,
            updateCondition: { $0.languageCorrectCount },
            reward: Cost(gold: 100)
        )
        let missionSystem = MissionSystem(missions: [mission])
        let record = Record(missionSystem: missionSystem)

        // When: 10번 정답 기록
        for _ in 1...10 {
            record.record(.languageCorrect)
        }

        // 비동기 처리 완료 대기
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1초

        // Then: 미션 완료되어야 함
        #expect(mission.currentValue == 10, "미션 값이 10이어야 함")
        #expect(mission.state == .claimable, "미션이 완료 상태여야 함")
        #expect(missionSystem.hasCompletedMission == true, "완료된 미션이 있어야 함")
    }

    @Test("연속 업데이트 시 누락 방지 - 100회 연속 기록")
    func testConsecutiveUpdateGuarantee() async throws {
        // Given: 목표 100인 언어 미션
        let mission = Mission(
            id: 2,
            type: .languageMatch(.silver),
            title: "언어 100회 성공",
            description: "언어 게임 100회 성공하기",
            targetValue: 100,
            updateCondition: { $0.languageCorrectCount },
            reward: Cost(gold: 1000)
        )
        let missionSystem = MissionSystem(missions: [mission])
        let record = Record(missionSystem: missionSystem)

        // When: 100번 빠르게 연속 기록
        for _ in 1...100 {
            record.record(.languageCorrect)
        }

        // 비동기 처리 완료 대기
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1초

        // Then: 정확히 100이어야 함 (누락 없음)
        #expect(record.languageCorrectCount == 100, "레코드가 정확히 100이어야 함")
        #expect(mission.currentValue == 100, "미션 값이 정확히 100이어야 함")
        #expect(mission.state == .claimable, "미션이 완료되어야 함")
    }

    @Test("여러 미션 동시 업데이트 시 누락 방지 - 30개 미션")
    func testMultipleMissionsUpdateWithoutLoss() async throws {
        // Given: 30개의 미션 생성
        let missions = (1...30).map { idx in
            Mission(
                id: idx,
                type: .languageMatch(.bronze),
                title: "미션 \(idx)",
                description: "테스트 미션",
                targetValue: 1,
                updateCondition: { $0.languageCorrectCount },
                reward: Cost(gold: 100)
            )
        }
        let missionSystem = MissionSystem(missions: missions)
        let record = Record(missionSystem: missionSystem)

        // When: 1번만 기록
        record.record(.languageCorrect)

        // 비동기 처리 완료 대기
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1초

        // Then: 모든 미션이 완료되어야 함 (누락 없음)
        let completedCount = missions.filter { $0.state == .claimable }.count
        #expect(completedCount == 30, "30개 미션 모두 완료되어야 함 - 누락 없음")
        #expect(missionSystem.hasCompletedMission == true, "완료 플래그가 true여야 함")
    }

    @Test("earnMoney 이벤트로 누적 골드 미션 업데이트")
    func testEarnMoneyEventMissionUpdate() async throws {
        // Given: 누적 골드 미션
        let mission = Mission(
            id: 100,
            type: .tap(.gold),
            title: "1000골드 획득",
            description: "누적 1000골드 벌기",
            targetValue: 1000,
            updateCondition: { $0.totalEarnedMoney },
            reward: Cost(gold: 500, diamond: 10)
        )
        let missionSystem = MissionSystem(missions: [mission])
        let record = Record(missionSystem: missionSystem)

        // When: 여러 번 골드 획득
        record.record(.earnMoney(300))
        record.record(.earnMoney(400))
        record.record(.earnMoney(300))

        // 비동기 처리 완료 대기
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1초

        // Then: 정확히 1000이어야 함
        #expect(record.totalEarnedMoney == 1000, "총 획득 골드가 1000이어야 함")
        #expect(mission.currentValue == 1000, "미션 값이 1000이어야 함")
        #expect(mission.state == .claimable, "미션이 완료되어야 함")
    }
}
