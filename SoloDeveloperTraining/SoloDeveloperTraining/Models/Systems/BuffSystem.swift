//
//  BuffSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 버프 시스템 관리 클래스
final class BuffSystem {
    /// 감소 주기 (초 단위)
    private let decreaseInterval: TimeInterval = 1
    /// 버프 시간 감소 타이머
    private var decreaseTimer: Timer?
    /// 버프  시스템 실행 중 여부
    private(set) var isRunning: Bool = false
    /// 버프 배수
    var multiplier: Double = 1

    /// 남은 버프 시간 (초)
    var duration: Int = 0

    /// 소비 아이템 사용
    func useConsumableItem(type: ConsumableType) {
        isRunning = true
        duration = type.duration
        multiplier = type.buffMultiplier
        decreaseTimer = Timer.scheduledTimer(
            withTimeInterval: decreaseInterval,
            repeats: true
        ) { [weak self] _ in
            self?.duration -= 1
            if self?.duration == 0 {
                self?.stopTimer()
            }
        }
    }

    /// 버프 타이머 종료
    private func stopTimer() {
        decreaseTimer?.invalidate()
        decreaseTimer = nil
        multiplier = 1
    }
}
