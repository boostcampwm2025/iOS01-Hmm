//
//  ShopSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

enum ShopSystemError: Error {
    case insufficientGold
    case insufficientDiamond
}

final class ShopSystem {
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
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
    
    func upgrade(equipment: Equipment) {
        let targetItem = user.inventory.equipmentItems.filter { $0.type == equipment.type }.first
        targetItem?.upgraded()
    }
    
    func buyConsumable(type: ConsumableType) {
        user.inventory.gain(consumable: type)
    }
    
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

struct Item: Identifiable {
    var id: UUID = .init()
    let title: String
    let description: String
    let cost: Cost
    let type: ItemType
}

enum ItemType {
    case equipment(Equipment)
    case consumable(Consumable)
}
