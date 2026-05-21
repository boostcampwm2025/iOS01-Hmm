//
//  PolicyDTO.swift
//  SoloDeveloperTraining
//

import Foundation

enum PolicyDataField: String {
    case career, fever, game, skill, consumable, equipment, housing, system
}

struct PolicyDTO: Codable {
    var version: String
    var career: CareerPolicyDTO
    var fever: FeverPolicyDTO
    var game: GamePolicyDTO
    var skill: SkillPolicyDTO
    var consumable: ConsumablePolicyDTO
    var equipment: EquipmentPolicyDTO
    var housing: HousingPolicyDTO
    var system: SystemPolicyDTO
}
