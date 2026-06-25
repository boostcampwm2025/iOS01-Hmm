//
//  UserRepository.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 1/26/26.
//

import Foundation

enum UserLoadResult {
    case current(User)
    case legacy(Career?)
    case empty
}

protocol UserRepository {
    func save(_ user: User) async throws
    func load() async throws -> UserLoadResult
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
        let career = user.career
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

        let url = fileURL
        let data = try JSONEncoder().encode(userDTO)

        Task.detached {
            try data.write(to: url, options: [.atomic])
        }
    }

    func load() async throws -> UserLoadResult {
        guard fileManager.fileExists(atPath: fileURL.path) else { return .empty }

        let data = try Data(contentsOf: fileURL)
        do {
            let userDTO = try JSONDecoder().decode(UserDTO.self, from: data)
            return .current(
                User(
                    id: userDTO.id,
                    nickname: userDTO.nickname,
                    career: userDTO.career.toCareer(),
                    wallet: userDTO.wallet.toWallet(),
                    inventory: userDTO.inventory.toInventory(),
                    record: userDTO.record.toRecord(),
                    skills: Set(userDTO.skills.map { $0.toSkill() })
                ))
        } catch is DecodingError {
            let legacyCareer = try loadLegacyCareer(data: data)
            return .legacy(legacyCareer)
        }
    }
}

extension FileManagerUserRepository {
    /// 이전 버전의 커리어 정보를 반환합니다.
    func loadLegacyCareer(data: Data) throws -> Career? {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let careerRaw = (json?["career"] as? [String: Any])?["rawValue"] as? String
        return careerRaw.flatMap { Career(rawValue: $0) }
    }
}
