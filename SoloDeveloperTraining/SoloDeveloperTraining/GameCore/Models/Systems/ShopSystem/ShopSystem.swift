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
    /// - Parameter itemTypes: 표시할 아이템 카테고리 목록
    /// - Returns: 화면에 표시할 DisplayItem 배열
    func itemList(itemTypes: [ItemCategory]) -> [DisplayItem] {
        return itemTypes.map { makeDisplayItems(for: $0)}.flatMap { $0 }
    }

    /// 아이템 구매
    /// - Parameter item: 구매할 아이템
    /// - Throws:
    ///   - ShopSystemError.insufficientGold: 골드 부족
    ///   - ShopSystemError.insufficientDiamond: 다이아몬드 부족
    ///   - ShopSystemError.purchaseFailed: 구매 처리 실패
    func buy(item: DisplayItem) throws {
        // 구매 가능 여부 확인 (골드 및 다이아몬드)
        guard user.wallet.canAfford(item.cost) else {
            if item.cost.gold > 0 {
                throw ShopSystemError.insufficientGold
            } else {
                throw ShopSystemError.insufficientDiamond
            }
        }

        // 아이템 카테고리에 따른 구매 로직 실행
        switch item.category {
        case .consumable:
            try buyConsumable(displayItem: item)
        case .equipment:
            try buyEquipment(displayItem: item)
        case .housing:
            try buyHousing(displayItem: item)
        }
    }
}

private extension ShopSystem {
    /// 아이템 카테고리에 따른 DisplayItem 목록 생성
    /// - Parameter category: 아이템 카테고리
    /// - Returns: 해당 카테고리의 DisplayItem 배열
    func makeDisplayItems(for category: ItemCategory) -> [DisplayItem] {
        switch category {
        case .consumable:
            // 소비 아이템 목록 생성
            let consumables = user.inventory.consumableItems
            return consumables.map { consumable in
                DisplayItem(
                    item: consumable,
                    isEquipped: true,
                    isPurchasable: user.wallet.canAfford(consumable.cost)
                )
            }

        case .equipment:
            // 장비 아이템 목록 생성
            let equipments = user.inventory.equipmentItems
            return equipments.map { equipment in
                DisplayItem(
                    item: equipment,
                    isEquipped: true,
                    isPurchasable: user.wallet.canAfford(equipment.cost)
                )
            }

        case .housing:
            // 부동산 아이템 목록 생성 (모든 티어 표시)
            let currentHousingTier = user.inventory.housing.tier.rawValue
            let allHousings = HousingTier.allCases.map { Housing(tier: $0) }
            return allHousings.map { housing in
                DisplayItem(
                    item: housing,
                    isEquipped: housing.tier.rawValue == currentHousingTier,
                    isPurchasable: user.wallet.canAfford(housing.cost)
                )
            }
        }
    }

    /// 소비 아이템 구매 (개수 증가)
    /// - Parameter displayItem: 구매할 소비 아이템
    /// - Throws: ShopSystemError.purchaseFailed - 아이템 타입 변환 실패
    func buyConsumable(displayItem: DisplayItem) throws {
        // DisplayItem을 Consumable로 변환
        guard let consumable = displayItem.item as? Consumable else {
            throw ShopSystemError.purchaseFailed
        }

        // 재화 지불 (골드/다이아몬드)
        let cost = displayItem.cost
        if cost.gold > 0 {
            user.wallet.spendGold(cost.gold)
        }
        if cost.diamond > 0 {
            user.wallet.spendDiamond(cost.diamond)
        }

        // 인벤토리에 소비 아이템 개수 증가
        user.inventory.gain(consumable: consumable.type)
    }

    /// 장비 아이템 구매 (강화 시도)
    /// - Parameter displayItem: 구매할 장비 아이템
    /// - Throws: ShopSystemError.purchaseFailed - 아이템 타입 변환 실패
    /// - Note: 비용 지불 후 강화를 시도하며, 성공 여부는 티어의 강화 확률에 따라 결정됨
    func buyEquipment(displayItem: DisplayItem) throws {
        // DisplayItem을 Equipment로 변환
        guard let equipment = displayItem.item as? Equipment else {
            throw ShopSystemError.purchaseFailed
        }

        // 재화 지불 (골드/다이아몬드)
        let cost = displayItem.cost
        if cost.gold > 0 {
            user.wallet.spendGold(cost.gold)
        }
        if cost.diamond > 0 {
            user.wallet.spendDiamond(cost.diamond)
        }

        // 장비 강화 시도 (성공 확률은 티어마다 다름)
        equipment.upgraded()
    }

    /// 부동산 아이템 구매 (교체 및 환불)
    /// - Parameter displayItem: 구매할 부동산 아이템
    /// - Throws: ShopSystemError.purchaseFailed - 아이템 타입 변환 실패
    /// - Note: 기존 부동산 구입 금액의 50%를 환불받고, 실제 비용만 지불함
    func buyHousing(displayItem: DisplayItem) throws {
        // DisplayItem을 Housing으로 변환
        guard let newHousing = displayItem.item as? Housing else {
            throw ShopSystemError.purchaseFailed
        }

        // 현재 보유 중인 부동산 정보
        let currentHousing = user.inventory.housing

        // 기존 부동산 환불 금액 계산 (구입가의 50%)
        let refundAmount = currentHousing.cost.gold / 2

        // 실제 지불 금액 = 새 부동산 가격 - 환불 금액
        let netGoldCost = displayItem.cost.gold - refundAmount

        // 골드 지불 또는 환불
        if netGoldCost > 0 {
            user.wallet.spendGold(netGoldCost)
        } else {
            // 환불액이 더 큰 경우 골드 추가 (다운그레이드 시)
            user.wallet.addGold(-netGoldCost)
        }

        // 다이아몬드 비용 지불
        if displayItem.cost.diamond > 0 {
            user.wallet.spendDiamond(displayItem.cost.diamond)
        }

        // 인벤토리의 부동산을 새 부동산으로 교체
        user.inventory.housing = newHousing
    }
}
