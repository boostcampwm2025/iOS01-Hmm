//
//  ShopSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//


class ShopSystem {
    func upgrade(skill: Skill, wallet: Wallet) {}
    func upgrade(equipment: Equipment, wallet: Wallet) -> Bool { return false }
    func buyConsumable(item: Int, wallet: Wallet, inventory: Inventory) {}
    func buyHousing(item: Housing, wallet: Wallet, inventory: Inventory) {}
}
