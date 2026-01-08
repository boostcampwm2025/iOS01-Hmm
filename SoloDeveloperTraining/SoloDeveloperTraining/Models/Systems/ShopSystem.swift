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
        return []
    }
    
    func upgrade(equipment: Equipment, wallet: Wallet) -> Bool { return false }
    func buyConsumable(item: Int, wallet: Wallet, inventory: Inventory) {}
    func buyHousing(item: Housing, wallet: Wallet, inventory: Inventory) {}
}

struct Item {
    let title: String
    let count: Int
    let description: String
    let cost: Cost
    let unlockCareer: Career?
    let unlockSkill: Skill?
}
