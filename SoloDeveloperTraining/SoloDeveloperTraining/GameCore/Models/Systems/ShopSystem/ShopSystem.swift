//
//  ShopSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 상점 시스템 관리 클래스
final class ShopSystem {

    /// 사용자 정보
    let user: User

    /// 상점 시스템 초기화
    init(user: User) {
        self.user = user
    }

    /// 상점에 표시될 아이템 목록 생성
    func itemList() -> [Item] {
        let consumableItems: [Item] = user.inventory.consumableItems.map {
            .init(
                title: $0.displayTitle,
                description: "temp",
                cost: $0.type.cost,
                type: .consumable($0)
            )
        }
        let equipmentItems: [Item] = user.inventory.equipmentItems.map {
            .init(
                title: $0.displayTitle,
                description: "강화 확률: \(Int($0.upgradeSuccessRate * 100)) %",
                cost: $0.upgradeCost,
                type: .equipment($0)
            )
        }
        return consumableItems + equipmentItems
    }

    func housingList() -> [Item] {
        let housingItems: [Item] = Housing.allCases.map {
            .init(
                title: $0.displayTitle,
                description: "temp",
                cost: $0.cost,
                type: .housing($0)
            )
        }
        return housingItems
    }

    /// 장비 아이템 업그레이드 시도
    /// - Parameter equipment: 장비 아이템
    /// - Returns: 시도 결과
    private func upgrade(equipment: Equipment) -> Bool {
        guard let targetItem = user.inventory.equipmentItems.filter({ $0.type == equipment.type }).first else { return false }
        return targetItem.upgraded()
    }

    /// 소비 아이템 구매
    /// - Parameter consumable: 소비 아이템
    /// - Returns: 구입 결과
    private func buy(consumable: Consumable) -> Bool {
        user.inventory.gain(consumable: consumable.type)
        return true
    }

    /// 부동산 아이템 구매
    /// - Parameter housing: 부동산 아이템
    /// - Returns: 구입 결과
    private func buy(housing: Housing) -> Bool {
        guard housing != user.inventory.housing else { return false }
        user.wallet.addGold(user.inventory.housing.cost.gold / 2)
        user.inventory.housing = housing
        return true
    }

    /// 아이템 구매
    func buy(item: Item) throws {
        guard item.cost.gold <= user.wallet.gold else { throw ShopSystemError.insufficientGold }
        guard item.cost.diamond <= user.wallet.diamond else { throw ShopSystemError.insufficientDiamond }

        var buyResult: Bool
        switch item.type {
        case .equipment(let equipment):
            buyResult = upgrade(equipment: equipment)

        case .consumable(let consumable):
            buyResult = buy(consumable: consumable)

        case .housing(let housing):
            buyResult = buy(housing: housing)
        }

        if buyResult {
            pay(item: item)
        } else {
            throw ShopSystemError.purchaseFailed
        }
    }

    /// 유저의 지갑에서 요금이 결제됩니다.
    /// - Parameter item: 아이템
    func pay(item: Item) {
        user.wallet.spendGold(item.cost.gold)
        user.wallet.spendDiamond(item.cost.diamond)
    }
}
