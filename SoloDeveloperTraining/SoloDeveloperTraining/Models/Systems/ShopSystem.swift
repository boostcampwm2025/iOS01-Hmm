//
//  ShopSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 상점 시스템 관련 에러
enum ShopSystemError: Error {
    /// 골드 부족
    case insufficientGold
    /// 다이아몬드 부족
    case insufficientDiamond
}

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

    /// 장비 아이템 업그레이드 시도
    private func upgrade(equipment: Equipment) {
        let targetItem = user.inventory.equipmentItems.filter { $0.type == equipment.type }.first
        targetItem?.upgraded()
    }

    /// 소비 아이템 구매
    private func buyConsumable(type: ConsumableType) {
        user.inventory.gain(consumable: type)
    }

    /// 아이템 구매
    func buy(item: Item) throws {
        guard item.cost.gold <= user.wallet.gold else { throw ShopSystemError.insufficientGold }
        guard item.cost.diamond <= user.wallet.diamond else { throw ShopSystemError.insufficientDiamond }
        
        user.wallet.spendGold(item.cost.gold)
        user.wallet.spendDiamond(item.cost.diamond)
        
        switch item.type {
        case .equipment(let equipment):
            upgrade(equipment: equipment)
            
        case .consumable(let consumable):
            buyConsumable(type: consumable.type)
        }
    }
}

/// 상점 아이템 모델
struct Item: Identifiable {
    /// 아이템 고유 ID
    var id: UUID = .init()
    /// 아이템 제목
    let title: String
    /// 아이템 설명
    let description: String
    /// 아이템 가격
    let cost: Cost
    /// 아이템 타입
    let type: ItemType
}

/// 아이템 타입 구분
enum ItemType {
    /// 장비 아이템
    case equipment(Equipment)
    /// 소비 아이템
    case consumable(Consumable)
}
