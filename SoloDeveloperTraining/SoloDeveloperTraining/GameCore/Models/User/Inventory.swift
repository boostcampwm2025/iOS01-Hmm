//
//  Inventory.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

@Observable
final class Inventory {

    /// 장비 아이템
    let equipmentItems: [Equipment]
    /// 소비 아이템
    let consumableItems: [Consumable]
    /// 부동산
    var housing: Housing

    init(
        equipmentItems: [Equipment] = [
            .init(type: .keyboard, tier: .broken),
            .init(type: .mouse, tier: .broken),
            .init(type: .monitor, tier: .broken),
            .init(type: .chair, tier: .broken)
        ],
        consumableItems: [Consumable] = [
            .init(type: .coffee, count: 5),
            .init(type: .energyDrink, count: 5)
        ],
        housing: Housing = .init(tier: .street)
    ) {
        self.equipmentItems = equipmentItems
        self.consumableItems = consumableItems
        self.housing = housing
    }

    /// 소비 아이템을 사용합니다.
    /// - Returns: 사용 성공 여부
    func drink(_ type: ConsumableType) -> Bool {
        guard let targetItem = consumableItems.filter({ $0.type == type }).first else { return false }
        guard targetItem.count > 0 else { return false }
        targetItem.spendItem()
        return true
    }

    /// 소비 아이템 갯수
    /// - Parameter type: 소비 아이템 타입
    /// - Returns: 소비 아이템 갯수
    func count(_ type: ConsumableType) -> Int? {
        guard let targetItem = consumableItems.filter({ $0.type == type }).first else { return nil }
        return targetItem.count
    }

    func gain(consumable: ConsumableType) {
        consumableItems.filter { $0.type == consumable }.first?.addItem()
    }
}
