//
//  DevBalanceRepository.swift
//  SoloDeveloperTraining
//

import Foundation
import FirebaseFirestore

private enum Constant {
    static let dataCollectionName = "Data"
    static let latestDocID = "Latest"
    static let versionFieldName = "version"
}

final class DevBalanceRepository: BalanceRepository {
    private let dataBase = Firestore.firestore()

    init() {}

    func fetchPolicy(tab: PolicyTab, version: String) async throws -> PolicyDTO {
        let docID = (tab == .edit) ? Constant.latestDocID : version

        async let career = fetchCareer(tab: tab, docID: docID)
        async let fever = fetchFever(tab: tab, docID: docID)
        async let game = fetchGame(tab: tab, docID: docID)
        async let skill = fetchSkill(tab: tab, docID: docID)
        async let consumable = fetchConsumable(tab: tab, docID: docID)
        async let equipment = fetchEquipment(tab: tab, docID: docID)
        async let housing = fetchHousing(tab: tab, docID: docID)
        async let system = fetchSystem(tab: tab, docID: docID)

        return try await PolicyDTO(
            version: version,
            career: career, fever: fever, game: game, skill: skill,
            consumable: consumable, equipment: equipment, housing: housing, system: system
        )
    }

    func uploadPolicy(tab: PolicyTab, data: PolicyDTO) async throws {
        let batch = dataBase.batch()
        let targetDocID = (tab == .edit) ? Constant.latestDocID : data.version
        let versionDoc = dataBase.collection(tab.firestoreCollectionName).document(targetDocID)
        let dataCollection = versionDoc.collection(Constant.dataCollectionName)

        batch
            .setData(
                [Constant.versionFieldName: data.version],
                forDocument: versionDoc
            )

        try batch.setData(from: data.career, forDocument: dataCollection.document(PolicyDataField.career.rawValue))
        try batch.setData(from: data.fever, forDocument: dataCollection.document(PolicyDataField.fever.rawValue))
        try batch.setData(from: data.game, forDocument: dataCollection.document(PolicyDataField.game.rawValue))
        try batch.setData(from: data.skill, forDocument: dataCollection.document(PolicyDataField.skill.rawValue))
        try batch.setData(from: data.consumable, forDocument: dataCollection.document(PolicyDataField.consumable.rawValue))
        try batch.setData(from: data.equipment, forDocument: dataCollection.document(PolicyDataField.equipment.rawValue))
        try batch.setData(from: data.housing, forDocument: dataCollection.document(PolicyDataField.housing.rawValue))
        try batch.setData(from: data.system, forDocument: dataCollection.document(PolicyDataField.system.rawValue))

        try await batch.commit()
    }

    func fetchActiveVersion(tab: PolicyTab) async throws -> String? {
        if tab == .edit {
            // Edit/Latest의 version 필드를 읽어서 반환
            let doc = try await dataBase.collection(tab.firestoreCollectionName).document(Constant.latestDocID).getDocument()
            return doc.data()?[Constant.versionFieldName] as? String
        } else {
            // Test/Live는 배포된 특정 버전을 활성화해야 하므로 Version 참조 유지
            let doc = try await dataBase.collection(PolicyTab.version.firestoreCollectionName)
                .document(tab.firestoreCollectionName).getDocument()
            return doc.data()?[Constant.versionFieldName] as? String
        }
    }

    func setActiveVersion(tab: PolicyTab, version: String) async throws {
        try await dataBase.collection(PolicyTab.version.firestoreCollectionName)
            .document(tab.firestoreCollectionName)
            .setData([Constant.versionFieldName: version])
    }

    func fetchVersionList(tab: PolicyTab) async throws -> [String] {
        let snapshot = try await dataBase.collection(tab.firestoreCollectionName).getDocuments()
        return snapshot.documents.map { $0.documentID }.sorted(by: >)
    }
}

// MARK: - Private Document Fetchers (No Generic)
private extension DevBalanceRepository {
    func fetchCareer(tab: PolicyTab, docID: String) async throws -> CareerPolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.career.rawValue).getDocument(as: CareerPolicyDTO.self)
    }

    func fetchFever(tab: PolicyTab, docID: String) async throws -> FeverPolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.fever.rawValue).getDocument(as: FeverPolicyDTO.self)
    }

    func fetchGame(tab: PolicyTab, docID: String) async throws -> GamePolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.game.rawValue).getDocument(as: GamePolicyDTO.self)
    }

    func fetchSkill(tab: PolicyTab, docID: String) async throws -> SkillPolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.skill.rawValue).getDocument(as: SkillPolicyDTO.self)
    }

    func fetchConsumable(tab: PolicyTab, docID: String) async throws -> ConsumablePolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.consumable.rawValue).getDocument(as: ConsumablePolicyDTO.self)
    }

    func fetchEquipment(tab: PolicyTab, docID: String) async throws -> EquipmentPolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.equipment.rawValue).getDocument(as: EquipmentPolicyDTO.self)
    }

    func fetchHousing(tab: PolicyTab, docID: String) async throws -> HousingPolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.housing.rawValue).getDocument(as: HousingPolicyDTO.self)
    }

    func fetchSystem(tab: PolicyTab, docID: String) async throws -> SystemPolicyDTO {
        try await dataBase.collection(tab.firestoreCollectionName).document(docID)
            .collection(Constant.dataCollectionName).document(PolicyDataField.system.rawValue).getDocument(as: SystemPolicyDTO.self)
    }
}
