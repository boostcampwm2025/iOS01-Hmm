//
//  ShopSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class ShopSystem {
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func itemList() -> [Item] {
        let equipmentItems: [Item] = user.inventory.equipmentItems.map {
            .init(
                title: $0.displayTitle,
                description: "temp",
                cost: $0.upgradeCost,
                unlockCareer: nil,
                unlockSkill: nil,
                type: .equipment($0)
            )
        }
        let consumableItems: [Item] = user.inventory.consumableItems.map {
            .init(
                title: $0.displayTitle,
                description: "temp",
                cost: $0.type.cost,
                unlockCareer: nil,
                unlockSkill: nil,
                type: .consumable($0)
            )
        }
        return equipmentItems + consumableItems
    }
    
    func upgrade(equipment: Equipment, wallet: Wallet) -> Bool { return false }
    func buyConsumable(item: Int, wallet: Wallet, inventory: Inventory) {}
    func buyHousing(item: Housing, wallet: Wallet, inventory: Inventory) {}
}

struct Item: Identifiable {
    var id: UUID = .init()
    let title: String
    let description: String
    let cost: Cost
    let unlockCareer: Career?
    let unlockSkill: Skill?
    let type: ItemType
}

enum ItemType {
    case equipment(Equipment)
    case consumable(Consumable)
    case housing(Housing)
}
