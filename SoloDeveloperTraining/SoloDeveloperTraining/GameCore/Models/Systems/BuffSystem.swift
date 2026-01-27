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
    /// 각 버프의 종료 시각
    private var endTimes: [ConsumableType: TimeInterval] = [:]

    /// 각 버프의 배수
    private var multipliers: [ConsumableType: Double] = [:]

    /// 버프 단일 타이머
    private var timer: Timer?

    /// 버프 시스템 일시정지 여부
    private(set) var isPaused: Bool = false

    /// pause 시작 시각
    private var pauseStartTime: TimeInterval?

    // MARK: - Computed Properties

    /// 하나라도 활성화된 버프가 있는지
    var isRunning: Bool {
        !endTimes.isEmpty
    }

    /// 전체 버프 배수 (모든 활성화된 버프의 배수를 곱한 값)
    var multiplier: Double {
        multipliers.values.reduce(1.0, *)
    }

    /// 커피 버프 남은 시간 (초)
    var coffeeDuration: Int {
        remainingDuration(for: .coffee)
    }

    /// 에너지 드링크 버프 남은 시간 (초)
    var energyDrinkDuration: Int {
        remainingDuration(for: .energyDrink)
    }

    /// 가장 긴 버프 남은 시간 (하위 호환)
    var duration: Int {
        max(coffeeDuration, energyDrinkDuration)
    }

    // MARK: - Public Methods

    /// 소비 아이템 사용
    func useConsumableItem(type: ConsumableType) {
        let now = currentTime
        endTimes[type] = now + TimeInterval(type.duration)
        multipliers[type] = type.buffMultiplier
        startTimer()
    }

    /// 버프 시스템 종료
    func stop() {
        stopTimer()
        endTimes.removeAll()
        multipliers.removeAll()
        isPaused = false
        pauseStartTime = nil
    }

    /// 버프 시스템 일시정지
    func pause() {
        guard isRunning, !isPaused else { return }
        isPaused = true
        pauseStartTime = currentTime
        stopTimer()
    }

    /// 버프 시스템 재개
    func resume() {
        guard isRunning, isPaused, let pauseStartTime else { return }

        let now = currentTime
        let pausedDuration = now - pauseStartTime

        // 모든 버프의 종료 시각을 pause된 시간만큼 뒤로 밀기
        for type in endTimes.keys {
            endTimes[type]! += pausedDuration
        }

        self.pauseStartTime = nil
        isPaused = false
        startTimer()
    }

    // MARK: - Private Helpers

    /// 현재 시간 (절대)
    private var currentTime: TimeInterval {
        Date.timeIntervalSinceReferenceDate
    }

    /// 남은 시간 계산 (초)
    private func remainingDuration(for type: ConsumableType) -> Int {
        guard let endTime = endTimes[type] else { return 0 }
        let remaining = endTime - currentTime
        return max(0, Int(ceil(remaining)))
    }

    /// 타이머 시작
    private func startTimer() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
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

    /// 1초 주기로 종료된 버프 정리
    private func tick() {
        let now = currentTime

        for (type, endTime) in endTimes where now >= endTime {
            stopBuff(for: type)
        }

        if endTimes.isEmpty {
            stopTimer()
        }
    }

    /// 특정 버프 제거
    private func stopBuff(for type: ConsumableType) {
        endTimes.removeValue(forKey: type)
        multipliers.removeValue(forKey: type)
    }
}
