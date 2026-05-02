import Foundation
import FirebaseFirestore

private enum Constant {
    static let dataCollection = "Data"
    static let latestDocID = "latest"
    static let versionField = "version"
    static let modifiedByField = "modifiedBy"
    static let modifiedAtField = "modifiedAt"
}

final class DefaultAdminPolicyRepository: AdminPolicyRepository {
    private let db = Firestore.firestore()

    func fetchLatest(env: PolicyEnvironment) async throws -> (meta: PolicyVersionMeta, policy: PolicyDTO)? {
        let ref = db.collection(env.rawValue).document(Constant.latestDocID)
        let doc = try await ref.getDocument()
        guard doc.exists,
              let data = doc.data(),
              let version = data[Constant.versionField] as? Int,
              let modifiedBy = data[Constant.modifiedByField] as? String,
              let modifiedAt = (data[Constant.modifiedAtField] as? Timestamp)?.dateValue()
        else { return nil }

        let policy = try await fetchPolicyData(from: ref.collection(Constant.dataCollection))
        let meta = PolicyVersionMeta(id: Constant.latestDocID, version: version, modifiedBy: modifiedBy, modifiedAt: modifiedAt)
        return (meta, policy)
    }

    func fetchVersionList(env: PolicyEnvironment) async throws -> [PolicyVersionMeta] {
        let snapshot = try await db.collection(env.rawValue).getDocuments()
        return snapshot.documents
            .filter { $0.documentID != Constant.latestDocID }
            .compactMap { doc -> PolicyVersionMeta? in
                let data = doc.data()
                guard let version = data[Constant.versionField] as? Int,
                      let modifiedBy = data[Constant.modifiedByField] as? String,
                      let modifiedAt = (data[Constant.modifiedAtField] as? Timestamp)?.dateValue()
                else { return nil }
                return PolicyVersionMeta(id: doc.documentID, version: version, modifiedBy: modifiedBy, modifiedAt: modifiedAt)
            }
            .sorted { $0.version > $1.version }
    }

    func fetchPolicy(env: PolicyEnvironment, version: Int) async throws -> PolicyDTO {
        let ref = db.collection(env.rawValue).document("v\(version)")
        return try await fetchPolicyData(from: ref.collection(Constant.dataCollection))
    }

    func savePolicy(env: PolicyEnvironment, policy: PolicyDTO, modifiedBy: String) async throws {
        let versions = try await fetchVersionList(env: env)
        let currentLatest = try await fetchLatest(env: env)
        let nextVersion = max(versions.map(\.version).max() ?? 0, currentLatest?.meta.version ?? 0) + 1

        let metadata: [String: Any] = [
            Constant.versionField: nextVersion,
            Constant.modifiedByField: modifiedBy,
            Constant.modifiedAtField: Timestamp(date: Date())
        ]

        let batch = db.batch()

        let latestRef = db.collection(env.rawValue).document(Constant.latestDocID)
        batch.setData(metadata, forDocument: latestRef, merge: false)
        try writePolicyData(batch: batch, collection: latestRef.collection(Constant.dataCollection), policy: policy)

        let versionRef = db.collection(env.rawValue).document("v\(nextVersion)")
        batch.setData(metadata, forDocument: versionRef, merge: false)
        try writePolicyData(batch: batch, collection: versionRef.collection(Constant.dataCollection), policy: policy)

        try await batch.commit()
    }

    // MARK: - Private

    private func fetchPolicyData(from collection: CollectionReference) async throws -> PolicyDTO {
        async let career    = collection.document(PolicyDataField.career.rawValue).getDocument(as: CareerPolicyDTO.self)
        async let fever     = collection.document(PolicyDataField.fever.rawValue).getDocument(as: FeverPolicyDTO.self)
        async let game      = collection.document(PolicyDataField.game.rawValue).getDocument(as: GamePolicyDTO.self)
        async let skill     = collection.document(PolicyDataField.skill.rawValue).getDocument(as: SkillPolicyDTO.self)
        async let consumable = collection.document(PolicyDataField.consumable.rawValue).getDocument(as: ConsumablePolicyDTO.self)
        async let equipment = collection.document(PolicyDataField.equipment.rawValue).getDocument(as: EquipmentPolicyDTO.self)
        async let housing   = collection.document(PolicyDataField.housing.rawValue).getDocument(as: HousingPolicyDTO.self)
        async let system    = collection.document(PolicyDataField.system.rawValue).getDocument(as: SystemPolicyDTO.self)

        return PolicyDTO(
            version: "",
            career: try await career,
            fever: try await fever,
            game: try await game,
            skill: try await skill,
            consumable: try await consumable,
            equipment: try await equipment,
            housing: try await housing,
            system: try await system
        )
    }

    private func writePolicyData(batch: WriteBatch, collection: CollectionReference, policy: PolicyDTO) throws {
        try batch.setData(from: policy.career,     forDocument: collection.document(PolicyDataField.career.rawValue))
        try batch.setData(from: policy.fever,      forDocument: collection.document(PolicyDataField.fever.rawValue))
        try batch.setData(from: policy.game,       forDocument: collection.document(PolicyDataField.game.rawValue))
        try batch.setData(from: policy.skill,      forDocument: collection.document(PolicyDataField.skill.rawValue))
        try batch.setData(from: policy.consumable, forDocument: collection.document(PolicyDataField.consumable.rawValue))
        try batch.setData(from: policy.equipment,  forDocument: collection.document(PolicyDataField.equipment.rawValue))
        try batch.setData(from: policy.housing,    forDocument: collection.document(PolicyDataField.housing.rawValue))
        try batch.setData(from: policy.system,     forDocument: collection.document(PolicyDataField.system.rawValue))
    }
}
