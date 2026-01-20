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
                    isEquipped: nil,
                    isPurchasable: user.wallet.canAfford($0.cost)
                )
            }
            return displayList
        case .equipment:
            let equipmentList = user.inventory.equipmentItems
            let displayList = equipmentList.map {
                DisplayItem(
                    item: $0,
                    isEquipped: nil,
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
}
