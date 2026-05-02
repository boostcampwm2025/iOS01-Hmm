//
//  UserDTO.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-26.
//

import Foundation

struct UserDTO: Codable {
    let id: UUID
    let nickname: String
    let career: CareerDTO
    let wallet: WalletDTO
    let inventory: InventoryDTO
    let record: RecordDTO
    let skills: [SkillDTO]
}
