//
//  DevBalanceRepository.swift
//  SoloDeveloperTraining
//

import Foundation
import FirebaseFirestore

final class DevBalanceRepository: BalanceRepository {
    private let dataBase = Firestore.firestore()

    init() {}

    func fetchPolicy(tab: PolicyTab, version: String) async throws -> PolicyDTO {
        async let careerDoc = fetchCareer(tab: tab, version: version)
        async let feverDoc = fetchFever(tab: tab, version: version)
        async let gameDoc = fetchGame(tab: tab, version: version)
        async let skillDoc = fetchSkill(tab: tab, version: version)
        async let consumableDoc = fetchConsumable(tab: tab, version: version)
        async let equipmentDoc = fetchEquipment(tab: tab, version: version)
        async let housingDoc = fetchHousing(tab: tab, version: version)
        async let systemDoc = fetchSystem(tab: tab, version: version)

        let result = try await PolicyDTO(
            version: version,
            career: careerDoc,
            fever: feverDoc,
            game: gameDoc,
            skill: skillDoc,
            consumable: consumableDoc,
            equipment: equipmentDoc,
            housing: housingDoc,
            system: systemDoc
        )
        return result
    }

    func uploadPolicy(tab: PolicyTab, data: PolicyDTO) async throws {
        let batch = dataBase.batch()
        let versionDoc = dataBase.collection(tab.firestoreCollectionName).document(
            data.version
        )
        let dataCollection = versionDoc.collection("Data")

        // 버전 문서 자체에도 메타데이터(수정일 등)를 저장할 수 있습니다.
        batch.setData(["updatedAt": FieldValue.serverTimestamp()], forDocument: versionDoc)

        try batch
            .setData(
                from: data.career,
                forDocument: dataCollection
                    .document(PolicyDataField.career.rawValue)
            )
        try batch
            .setData(
                from: data.fever,
                forDocument: dataCollection
                    .document(PolicyDataField.fever.rawValue)
            )
        try batch.setData(from: data.game, forDocument: dataCollection.document(PolicyDataField.game.rawValue))
        try batch
            .setData(
                from: data.skill,
                forDocument: dataCollection
                    .document(PolicyDataField.skill.rawValue)
            )
        try batch
            .setData(
                from: data.consumable,
                forDocument: dataCollection
                    .document(PolicyDataField.consumable.rawValue)
            )
        try batch
            .setData(
                from: data.equipment,
                forDocument: dataCollection
                    .document(PolicyDataField.equipment.rawValue)
            )
        try batch
            .setData(
                from: data.housing,
                forDocument: dataCollection
                    .document(PolicyDataField.housing.rawValue)
            )
        try batch
            .setData(
                from: data.system,
                forDocument: dataCollection
                    .document(PolicyDataField.system.rawValue)
            )

        try await batch.commit()
        print("✅ [Dev] Policy \(data.version) 업로드 완료 (PolicyTab: \(tab))")
    }

    func fetchVersionList(tab: PolicyTab) async throws -> [String] {
        let snapshot = try await dataBase.collection(tab.firestoreCollectionName).getDocuments()
        // 문서 ID(버전 이름)들을 추출하여 반환합니다.
        return snapshot.documents.map { $0.documentID }.sorted(by: >) // 최신 버전이 위로 오도록 정렬
    }

    func fetchActiveVersion(tab: PolicyTab) async throws -> String? {
        let doc = try await dataBase.collection(PolicyTab.version.firestoreCollectionName).document(tab.firestoreCollectionName).getDocument()
        return doc.data()?["version"] as? String
    }

    func setActiveVersion(tab: PolicyTab, version: String) async throws {
        try await dataBase
            .collection(PolicyTab.version.firestoreCollectionName)
            .document(tab.firestoreCollectionName)
            .setData([
            "version": version,
            "updatedAt": FieldValue.serverTimestamp()
        ])
    }
}

extension DevBalanceRepository {
    private func fetchCareer(tab: PolicyTab, version: String) async throws -> CareerPolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection(
            "Data"
        )
        return try await dataCollection.document(PolicyDataField.career.rawValue).getDocument(as: CareerPolicyDTO.self)
    }

    private func fetchFever(tab: PolicyTab, version: String) async throws -> FeverPolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection(
            "Data"
        )
        return try await dataCollection.document(PolicyDataField.fever.rawValue).getDocument(as: FeverPolicyDTO.self)
    }

    private func fetchGame(tab: PolicyTab, version: String) async throws -> GamePolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection(
            "Data"
        )
        return try await dataCollection.document(PolicyDataField.game.rawValue).getDocument(as: GamePolicyDTO.self)
    }

    private func fetchSkill(tab: PolicyTab, version: String) async throws -> SkillPolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection(
            "Data"
        )
        return try await dataCollection.document(PolicyDataField.skill.rawValue).getDocument(as: SkillPolicyDTO.self)
    }

    private func fetchConsumable(tab: PolicyTab, version: String) async throws -> ConsumablePolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection("Data")
        return try await dataCollection.document(PolicyDataField.consumable.rawValue).getDocument(as: ConsumablePolicyDTO.self)
    }

    private func fetchEquipment(tab: PolicyTab, version: String) async throws -> EquipmentPolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection("Data")
        return try await dataCollection.document(PolicyDataField.equipment.rawValue).getDocument(as: EquipmentPolicyDTO.self)
    }

    private func fetchHousing(tab: PolicyTab, version: String) async throws -> HousingPolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection("Data")
        return try await dataCollection.document(PolicyDataField.housing.rawValue).getDocument(as: HousingPolicyDTO.self)
    }

    private func fetchSystem(tab: PolicyTab, version: String) async throws -> SystemPolicyDTO {
        let dataCollection = dataBase.collection(tab.firestoreCollectionName).document(version).collection("Data")
        return try await dataCollection.document(PolicyDataField.system.rawValue).getDocument(as: SystemPolicyDTO.self)
    }
}
