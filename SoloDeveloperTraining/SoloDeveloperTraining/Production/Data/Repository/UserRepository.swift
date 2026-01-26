//
//  UserRepository.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 1/26/26.
//

import Foundation

protocol UserRepository {
    func save(_ user: User) async throws
    func load() async throws -> User?
}

final class FileManagerUserRepository: UserRepository {
    private let fileManager = FileManager()
    private let fileName = "user_data.json"

    private var fileURL: URL {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }

    func save(_ user: User) async throws {
        let id = user.id
        let nickname = user.nickname
        let career = await user.career
        let wallet = user.wallet
        let inventory = user.inventory
        let record = user.record
        let skills = Array(user.skills)

        let userDTO = UserDTO(
            id: id,
            nickname: nickname,
            career: CareerDTO(from: career),
            wallet: WalletDTO(from: wallet),
            inventory: InventoryDTO(from: inventory),
            record: RecordDTO(from: record),
            skills: skills.map { SkillDTO(from: $0) }
        )

        let data = try JSONEncoder().encode(userDTO)
        try data.write(to: fileURL, options: [.atomic])
    }

    func load() async throws -> User? {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }

        let data = try Data(contentsOf: fileURL)
        let userDTO = try JSONDecoder().decode(UserDTO.self, from: data)

        return User(
            id: userDTO.id,
            nickname: userDTO.nickname,
            career: userDTO.career.toCareer(),
            wallet: userDTO.wallet.toWallet(),
            inventory: userDTO.inventory.toInventory(),
            record: userDTO.record.toRecord(),
            skills: Set(userDTO.skills.map { $0.toSkill() })
        )
    }
}
