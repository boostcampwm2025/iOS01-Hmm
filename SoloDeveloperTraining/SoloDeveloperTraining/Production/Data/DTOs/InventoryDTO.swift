//
//  InventoryDTO.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-26.
//

import Foundation

struct InventoryDTO: Codable {
    let equipmentItems: [EquipmentDTO]
    let consumableItems: [ConsumableDTO]
    let housing: HousingDTO

    init(from inventory: Inventory) {
        self.equipmentItems = inventory.equipmentItems.map { EquipmentDTO(from: $0) }
        self.consumableItems = inventory.consumableItems.map { ConsumableDTO(from: $0) }
        self.housing = HousingDTO(from: inventory.housing)
    }

    func toInventory() -> Inventory {
        Inventory(
            equipmentItems: equipmentItems.map { $0.toEquipment() },
            consumableItems: consumableItems.map { $0.toConsumable() },
            housing: housing.toHousing()
        )
    }
}

struct EquipmentDTO: Codable {
    let type: EquipmentTypeDTO
    let tier: EquipmentTierDTO

    init(from equipment: Equipment) {
        self.type = EquipmentTypeDTO(from: equipment.type)
        self.tier = EquipmentTierDTO(from: equipment.tier)
    }

    func toEquipment() -> Equipment {
        Equipment(type: type.toEquipmentType(), tier: tier.toEquipmentTier())
    }
}

struct EquipmentTypeDTO: Codable {
    let rawValue: String

    init(from type: EquipmentType) {
        switch type {
        case .keyboard: self.rawValue = "keyboard"
        case .mouse: self.rawValue = "mouse"
        case .monitor: self.rawValue = "monitor"
        case .chair: self.rawValue = "chair"
        }
    }

    func toEquipmentType() -> EquipmentType {
        switch rawValue {
        case "keyboard": return .keyboard
        case "mouse": return .mouse
        case "monitor": return .monitor
        case "chair": return .chair
        default: return .keyboard
        }
    }
}

struct EquipmentTierDTO: Codable {
    let rawValue: Int

    init(from tier: EquipmentTier) {
        self.rawValue = tier.rawValue
    }

    func toEquipmentTier() -> EquipmentTier {
        EquipmentTier(rawValue: rawValue) ?? .broken
    }
}

struct ConsumableDTO: Codable {
    let type: ConsumableTypeDTO
    let count: Int

    init(from consumable: Consumable) {
        self.type = ConsumableTypeDTO(from: consumable.type)
        self.count = consumable.count
    }

    func toConsumable() -> Consumable {
        Consumable(type: type.toConsumableType(), count: count)
    }
}

struct ConsumableTypeDTO: Codable {
    let rawValue: String

    init(from type: ConsumableType) {
        switch type {
        case .coffee: self.rawValue = "coffee"
        case .energyDrink: self.rawValue = "energyDrink"
        }
    }

    func toConsumableType() -> ConsumableType {
        switch rawValue {
        case "coffee": return .coffee
        case "energyDrink": return .energyDrink
        default: return .coffee
        }
    }
}

struct HousingDTO: Codable {
    let tier: HousingTierDTO

    init(from housing: Housing) {
        self.tier = HousingTierDTO(from: housing.tier)
    }

    func toHousing() -> Housing {
        Housing(tier: tier.toHousingTier())
    }
}

struct HousingTierDTO: Codable {
    let rawValue: Int

    init(from tier: HousingTier) {
        self.rawValue = tier.rawValue
    }

    func toHousingTier() -> HousingTier {
        HousingTier(rawValue: rawValue) ?? .street
    }
}
