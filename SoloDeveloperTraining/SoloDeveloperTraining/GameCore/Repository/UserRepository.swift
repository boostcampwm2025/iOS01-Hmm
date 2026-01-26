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
        let dto = try await createDTO(from: user)
        let data = try JSONEncoder().encode(dto)
        try data.write(to: fileURL, options: [.atomic])
    }

    func load() async throws -> User? {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }

        let data = try Data(contentsOf: fileURL)
        let dto = try JSONDecoder().decode(UserDTO.self, from: data)
        return try await createUser(from: dto)
    }

    private func createDTO(from user: User) async throws -> UserDTO {
        let id = user.id
        let nickname = user.nickname
        let career = await user.career
        let wallet = user.wallet
        let inventory = user.inventory
        let record = user.record
        let skills = user.skills

        return UserDTO(
            id: id,
            nickname: nickname,
            career: CareerDTO(from: career),
            wallet: WalletDTO(from: wallet),
            inventory: InventoryDTO(from: inventory),
            record: RecordDTO(from: record),
            skills: skills.map { SkillDTO(from: $0) }
        )
    }

    private func createUser(from dto: UserDTO) async throws -> User {
        let wallet = dto.wallet.toWallet()
        let inventory = dto.inventory.toInventory()
        let record = dto.record.toRecord()
        let skills = Set(dto.skills.map { $0.toSkill() })

        return User(
            id: dto.id,
            nickname: dto.nickname,
            career: dto.career.toCareer(),
            wallet: wallet,
            inventory: inventory,
            record: record,
            skills: skills
        )
    }
}
