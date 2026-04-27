//
//  DefaultAdminBalanceRepository.swift
//  SoloDeveloperTraining
//

import Foundation
import FirebaseFirestore

private enum Constant {
    static let dataCollectionName = "Data"
    static let latestDocID = "Latest"
    static let versionFieldName = "version"
}

final class DefaultAdminBalanceRepository: DefaultBalanceRepository, AdminBalanceRepository {
    private let dataBase = Firestore.firestore()

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

    func setActiveVersion(tab: PolicyTab, version: String) async throws {
        try await dataBase.collection(PolicyTab.version.firestoreCollectionName)
            .document(tab.firestoreCollectionName)
            .setData([Constant.versionFieldName: version])
    }
}
