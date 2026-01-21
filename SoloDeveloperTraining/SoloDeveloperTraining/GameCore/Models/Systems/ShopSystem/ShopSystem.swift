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
        return itemTypes.map { makeDisplayItems(for: $0) }.flatMap { $0 }
    }

    /// 부동산 실제 비용 계산
    /// - Parameter item: 부동산 아이템
    /// - Returns: 실제 지불/환불 금액 (양수: 지불, 음수: 환불)
    func calculateHousingNetCost(for item: DisplayItem) -> Int {
        let refundAmount = user.inventory.housing.cost.gold / 2
        return item.cost.gold - refundAmount
    }

    /// 아이템 구매
    /// - Parameter item: 구매할 아이템
    /// - Returns: 구매 성공 여부 (장비의 경우 강화 성공/실패, 다른 아이템은 항상 true)
    /// - Throws:
    ///   - ShopSystemError.insufficientGold: 골드 부족
    ///   - ShopSystemError.insufficientDiamond: 다이아몬드 부족
    ///   - ShopSystemError.purchaseFailed: 구매 처리 실패
    func buy(item: DisplayItem) throws -> Bool {
        // 부동산의 경우 실제 지불 금액으로 구매 가능 여부 확인
        if item.category == .housing {
            let netGoldCost = calculateHousingNetCost(for: item)

            // 실제 지불 금액이 양수일 때만 구매 가능 여부 확인 (음수면 환불이므로 항상 가능)
            if netGoldCost > 0 {
                guard user.wallet.gold >= netGoldCost else {
                    throw PurchasingError.insufficientGold
                }
            }

            // 다이아몬드 비용 확인
            if item.cost.diamond > 0 {
                guard user.wallet.diamond >= item.cost.diamond else {
                    throw PurchasingError.insufficientDiamond
                }
            }
        } else {
            // 장비 및 소비품: 일반 구매 가능 여부 확인
            guard user.wallet.canAfford(item.cost) else {
                if item.cost.gold > 0 {
                    throw PurchasingError.insufficientGold
                } else {
                    throw PurchasingError.insufficientDiamond
                }
            }
        }

        // 아이템 카테고리에 따른 구매 로직 실행
        switch item.category {
        case .consumable:
            return try buyConsumable(displayItem: item)
        case .equipment:
            return try buyEquipment(displayItem: item)
        case .housing:
            return try buyHousing(displayItem: item)
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
    /// - Returns: 항상 true (구매 성공)
    /// - Throws: ShopSystemError.purchaseFailed - 아이템 타입 변환 실패
    func buyConsumable(displayItem: DisplayItem) throws -> Bool {
        // DisplayItem을 Consumable로 변환
        guard let consumable = displayItem.item as? Consumable else {
            throw PurchasingError.purchaseFailed
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

        return true
    }

    /// 장비 아이템 구매 (강화 시도)
    /// - Parameter displayItem: 구매할 장비 아이템
    /// - Returns: 강화 성공 여부 (true: 성공, false: 실패)
    /// - Throws: ShopSystemError.purchaseFailed - 아이템 타입 변환 실패
    /// - Note: 비용 지불 후 강화를 시도하며, 성공 여부는 티어의 강화 확률에 따라 결정됨
    func buyEquipment(displayItem: DisplayItem) throws -> Bool {
        // DisplayItem을 Equipment로 변환
        guard let equipment = displayItem.item as? Equipment else {
            throw PurchasingError.purchaseFailed
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
        return equipment.upgraded()
    }

    /// 부동산 아이템 구매 (교체 및 환불)
    /// - Parameter displayItem: 구매할 부동산 아이템
    /// - Returns: 항상 true (구매 성공)
    /// - Throws: ShopSystemError.purchaseFailed - 아이템 타입 변환 실패
    /// - Note: 기존 부동산 구입 금액의 50%를 환불받고, 실제 비용만 지불함
    func buyHousing(displayItem: DisplayItem) throws -> Bool {
        // DisplayItem을 Housing으로 변환
        guard let newHousing = displayItem.item as? Housing else {
            throw PurchasingError.purchaseFailed
        }

        // 실제 지불 금액 계산
        let netGoldCost = calculateHousingNetCost(for: displayItem)

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

        return true
    }
}
