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
    private let user: User

    /// 상점 시스템 초기화
    init(user: User) {
        self.user = user
    }

    /// 상점에 표시될 아이템 목록 생성
    func itemList(itemTypes: [ItemCategory]) -> [DisplayItem] {
        return itemTypes.map { makeDisplayItemList(itemType: $0)}.flatMap { $0 }
    }

    func buy(item: DisplayItem) throws {
        // 구매 가능 여부 확인
        guard user.wallet.canAfford(item.cost) else {
            if item.cost.gold > 0 {
                throw ShopSystemError.insufficientGold
            } else {
                throw ShopSystemError.insufficientDiamond
            }
        }

        // 아이템 타입별 처리
        switch item.category {
        case .consumable:
            try buyConsumable(item: item)
        case .equipment:
            try buyEquipment(item: item)
        case .housing:
            try buyHousing(item: item)
        }
    }
}

private extension ShopSystem {
    func makeDisplayItemList(itemType: ItemCategory) -> [DisplayItem] {
        switch itemType {
        case .consumable:
            let consumableList = user.inventory.consumableItems
            let displayList = consumableList.map {
                DisplayItem(
                    item: $0,
                    isEquipped: true,
                    isPurchasable: user.wallet.canAfford($0.cost)
                )
            }
            return displayList
        case .equipment:
            let equipmentList = user.inventory.equipmentItems
            let displayList = equipmentList.map {
                DisplayItem(
                    item: $0,
                    isEquipped: true,
                    isPurchasable: user.wallet.canAfford($0.cost)
                )
            }
            return displayList
        case .housing:
            let currentHousing = user.inventory.housing.tier.rawValue
            let housingList = HousingTier.allCases.map { Housing(tier: $0) }
            let displayList = housingList.map {
                DisplayItem(
                    item: $0,
                    isEquipped: $0.tier.rawValue == currentHousing,
                    isPurchasable: user.wallet.canAfford($0.cost)
                )
            }
            return displayList
        }
    }

    /// 소비 아이템 구매
    func buyConsumable(item: DisplayItem) throws {
        guard let consumable = item.item as? Consumable else {
            throw ShopSystemError.purchaseFailed
        }

        // 비용 지불
        let cost = item.cost
        if cost.gold > 0 {
            user.wallet.spendGold(cost.gold)
        }
        if cost.diamond > 0 {
            user.wallet.spendDiamond(cost.diamond)
        }

        // 아이템 추가
        user.inventory.gain(consumable: consumable.type)
    }

    /// 장비 아이템 구매 (강화)
    func buyEquipment(item: DisplayItem) throws {
        guard let equipment = item.item as? Equipment else {
            throw ShopSystemError.purchaseFailed
        }

        // 비용 지불
        let cost = item.cost
        if cost.gold > 0 {
            user.wallet.spendGold(cost.gold)
        }
        if cost.diamond > 0 {
            user.wallet.spendDiamond(cost.diamond)
        }

        // 강화 시도
        equipment.upgraded()
    }

    /// 부동산 아이템 구매
    func buyHousing(item: DisplayItem) throws {
        guard let newHousing = item.item as? Housing else {
            throw ShopSystemError.purchaseFailed
        }

        // 현재 부동산 정보
        let currentHousing = user.inventory.housing

        // 비용 지불 (새 부동산 비용 - 현재 부동산 환불)
        let refund = currentHousing.cost.gold / 2
        let actualCost = item.cost.gold - refund

        if actualCost > 0 {
            user.wallet.spendGold(actualCost)
        } else {
            // 환불액이 더 큰 경우 (일반적으로는 발생하지 않음)
            user.wallet.addGold(-actualCost)
        }

        if item.cost.diamond > 0 {
            user.wallet.spendDiamond(item.cost.diamond)
        }

        // 부동산 변경
        user.inventory.housing = newHousing
    }
}
