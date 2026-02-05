//
//  BuffSystem.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/18/25.
//

import Foundation

/// 버프 효과를 관리하는 시스템
final class BuffSystem {
    /// 현재 활성화된 버프의 배율
    private(set) var currentMultiplier: Double = 1.0

    /// 버프 타이머
    private var buffTimer: Timer?

    /// 버프가 활성화되어 있는지 확인
    var isActive: Bool {
        buffTimer != nil
    }

    /// 남은 버프 시간 (초)
    private(set) var remainingTime: TimeInterval = 0

    /// 버프를 활성화합니다.
    /// - Parameter item: 사용할 소비 아이템
    /// - Returns: 활성화 성공 시 `true`, 이미 버프가 활성화된 경우 `false`
    @discardableResult
    func activate(item: ConsumableItem) -> Bool {
        // 이미 버프가 활성화되어 있으면 실패
        guard !isActive else {
            return false
        }

        currentMultiplier = item.multiplier
        remainingTime = item.duration

        // 1초마다 남은 시간 감소
        buffTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.remainingTime -= 1

            if self.remainingTime <= 0 {
                self.deactivate()
            }
        }

        return true
    }

    /// 버프를 비활성화합니다.
    func deactivate() {
        buffTimer?.invalidate()
        buffTimer = nil
        currentMultiplier = 1.0
        remainingTime = 0
    }

    deinit {
        deactivate()
    }
}
