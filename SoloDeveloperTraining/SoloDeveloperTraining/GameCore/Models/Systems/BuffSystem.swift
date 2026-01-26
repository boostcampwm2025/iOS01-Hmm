//
//  BuffSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

/// 버프 시스템 관리 클래스
@Observable
final class BuffSystem {
    /// 감소 주기 (초 단위)
    private let decreaseInterval: TimeInterval = 1

    /// 각 버프의 남은 시간 (초)
    private var durations: [ConsumableType: Int] = [:]

    /// 각 버프의 배수
    private var multipliers: [ConsumableType: Double] = [:]

    /// 버프 단일 타이머
    private var timer: Timer?

    /// 버프 시스템 일시정지 여부
    private(set) var isPaused: Bool = false

    /// 버프 시스템 자체의 실행 중 여부 (하나라도 버프가 활성화되어 있으면 true)
    var isRunning: Bool {
        !durations.isEmpty
    }

    /// 전체 버프 배수 (모든 활성화된 버프의 배수를 곱한 값)
    var multiplier: Double {
        if multipliers.isEmpty {
            return 1.0
        }
        return multipliers.values.reduce(1.0) { $0 * $1 }
    }

    /// 커피 버프 남은 시간 (초)
    var coffeeDuration: Int {
        durations[.coffee] ?? 0
    }

    /// 에너지 드링크 버프 남은 시간 (초)
    var energyDrinkDuration: Int {
        durations[.energyDrink] ?? 0
    }

    /// 남은 버프 시간 (초) - 가장 긴 시간을 반환 (하위 호환성)
    var duration: Int {
        max(coffeeDuration, energyDrinkDuration)
    }

    /// 소비 아이템 사용
    func useConsumableItem(type: ConsumableType) {
        // 버프 정보 설정
        durations[type] = type.duration
        multipliers[type] = type.buffMultiplier

        // 타이머 시작
        startTimer()
    }

    /// 버프 시스템 종료
    func stop() {
        // 타이머 정리
        stopTimer()
        durations.removeAll()
        multipliers.removeAll()
        isPaused = false
    }

    /// 버프 시스템 일시정지
    func pause() {
        guard isRunning && !isPaused else { return }
        isPaused = true
        stopTimer()
    }

    /// 버프 시스템 재개
    func resume() {
        guard isRunning && isPaused else { return }
        isPaused = false
        startTimer()
    }

    /// 타이머 시작
    private func startTimer() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(
            withTimeInterval: decreaseInterval,
            repeats: true
        ) { [weak self] _ in
            self?.tick()
        }
    }

    /// 타이머 종료
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// 1초마다 각 버프의 정보를 순회하며 시간 감소
    private func tick() {
        let keys = Array(durations.keys)

        for type in keys {
            guard let duration = durations[type] else { continue }

            let newDuration = duration - 1

            if newDuration <= 0 {
                stopBuff(for: type)
            } else {
                durations[type] = newDuration
            }
        }

        if durations.isEmpty {
            stopTimer()
        }
    }

    /// 특정 버프 종료 (제거)
    private func stopBuff(for type: ConsumableType) {
        durations.removeValue(forKey: type)
        multipliers.removeValue(forKey: type)
    }
}
