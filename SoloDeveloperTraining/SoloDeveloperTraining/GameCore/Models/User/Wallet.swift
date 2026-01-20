//
//  Wallet.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

/// 게임 내 재화 관리 클래스
@Observable
final class Wallet {

    // MARK: - Properties
    /// 현재 보유 골드
    private(set) var gold: Int
    /// 현재 보유 다이아몬드
    private(set) var diamond: Int

    // MARK: - Initialization
    /// 지갑 초기화
    init(gold: Int = 0, diamond: Int = 0) {
        self.gold = gold
        self.diamond = diamond
    }

    /// 비용 지불 가능 여부 확인
    func canAfford(_ cost: Cost) -> Bool {
        return gold >= cost.gold && diamond >= cost.diamond
    }

    /// 골드 획득
    func addGold(_ amount: Int) {
        guard amount > 0 else { return }
        gold += amount
    }

    /// 골드 소모
    /// - Returns: 성공 여부
    @discardableResult
    func spendGold(_ amount: Int) -> Bool {
        guard amount > 0 else { return false }
        guard gold >= amount else { return false }
        gold -= amount
        return true
    }

    /// 다이아몬드 획득
    func addDiamond(_ amount: Int) {
        guard amount > 0 else { return }
        diamond += amount
    }

    /// 다이아몬드 소모
    /// - Returns: 성공 여부
    @discardableResult
    func spendDiamond(_ amount: Int) -> Bool {
        guard amount > 0 else { return false }
        guard diamond >= amount else { return false }
        diamond -= amount
        return true
    }
}
