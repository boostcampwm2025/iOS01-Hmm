//
//  Inventory.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

class Inventory {
    let equipment: [Equipment]
    let consumable: [Consumable]
    let housing: Housing

    init(equipment: [Equipment] = [], consumable: [Consumable] = [], housing: Housing) {
        self.equipment = equipment
        self.consumable = consumable
        self.housing = housing
    }
}
