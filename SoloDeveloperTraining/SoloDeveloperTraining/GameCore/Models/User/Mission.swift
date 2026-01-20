//
//  Mission.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

enum MissionState {
    /// "달성 완료"
    case claimed
    /// "획득하기"
    case claimable
    /// "진행중"
    case inProgress
}

@Observable
final class Mission {
    /// 미션 아이디
    var id: Int
    /// 업적 제목
    var title: String
    /// 업적 설명
    var description: String
    /// 목표 수치
    var targetValue: Int
    /// 현재 수치
    var currentValue: Int
    /// 진행 상태
    var progress: Double {
        min(Double(currentValue) / Double(targetValue), 1.0)
    }
    /// 현재 미션 상태
    var state: MissionState = .inProgress
    /// 업데이트 조건
    var updateCondition: (Record) -> Int
    /// 달성 조건
    var completeCondition: ((Record) -> Bool)?
    /// 보상
    var reward: Cost

    init(
        id: Int,
        title: String,
        description: String,
        targetValue: Int,
        currentValue: Int = 0,
        state: MissionState = .inProgress,
        updateCondition: @escaping (Record) -> Int,
        completeCondition: ((Record) -> Bool)? = nil,
        reward: Cost
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.state = state
        self.updateCondition = updateCondition
        self.completeCondition = completeCondition
        self.reward = reward
    }

    /// 최신 기록으로 업데이트하고, 완료 조건을 체크
    func update(record: Record) {
        guard state == .inProgress else { return }

        // 현재 값 업데이트
        currentValue = updateCondition(record)

        // 완료 조건 체크
        let isComplete = completeCondition?(record) ?? (currentValue >= targetValue)

        if isComplete {
            state = .claimable
        }
    }

    /// 미션을 완료하고 보상을 리턴합니다.
    func claim() -> Cost {
        guard state == .claimable else { return Cost() }
        state = .claimed

        return reward
    }
}
