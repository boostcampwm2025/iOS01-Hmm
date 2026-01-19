//
//  AutoGainSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/8/26.
//

import Foundation

/// 자동 골드 획득 시스템
final class AutoGainSystem {
    /// 사용자 정보
    private let user: User
    /// 계산기
    private let calculator: Calculator = Calculator()
    /// 타이머
    private var timer: Timer?

    /// 자동 획득 시스템 초기화
    init(user: User) {
        self.user = user
    }

    /// 자동 획득 시스템 시작
    func startSystem() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.gainGold()
        }
    }

    /// 초당 골드 획득 처리
    private func gainGold() {
        let goldPerSecond = calculator.calculateGoldPerSecond(user: user)
        user.wallet.addGold(goldPerSecond)
    }
}
