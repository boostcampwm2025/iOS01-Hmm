import Foundation
import FirebaseFirestore

private enum Constant {
    static let versionsCollection = "versions"
    static let testCollection = "test"
    static let liveCollection = "live"
    static let currentDocID = "current"
    static let dataCollection = "Data"
    static let versionField = "version"
    static let modifiedByField = "modifiedBy"
    static let modifiedAtField = "modifiedAt"
    static let formulasField = "formulas"
    static let testDeploymentsField = "testDeployments"
    static let liveDeploymentsField = "liveDeployments"
    static let deployedByKey = "deployedBy"
    static let deployedAtKey = "deployedAt"
}

enum RepositoryError: LocalizedError {
    case invalidData(String)
    var errorDescription: String? {
        switch self {
        case .invalidData(let doc): return "문서 파싱 실패: \(doc)"
        }
    }
}

final class DefaultAdminPolicyRepository: AdminPolicyRepository {
    private let db = Firestore.firestore()

    // MARK: - 최신 버전 조회

    func fetchLatestVersion() async throws -> (meta: PolicyVersionMeta, policy: PolicyDTO, formulas: [String: String])? {
        let snapshot = try await db.collection(Constant.versionsCollection)
            .order(by: Constant.versionField, descending: true)
            .limit(to: 1)
            .getDocuments()

        guard let doc = snapshot.documents.first else { return nil }

        let deployed = try await fetchDeployedVersionNumbers()
        let meta = try parseMeta(from: doc, deployedTest: deployed.test, deployedLive: deployed.live)
        let formulas = extractFormulas(from: doc.data())
        let policy = try await fetchPolicyData(from: doc.reference.collection(Constant.dataCollection))
        return (meta, policy, formulas)
    }

    // MARK: - 버전 목록 조회

    func fetchVersionList() async throws -> [PolicyVersionMeta] {
        async let snapshotTask = db.collection(Constant.versionsCollection)
            .order(by: Constant.versionField, descending: true)
            .getDocuments()
        async let deployedTask = fetchDeployedVersionNumbers()

        let (snapshot, deployed) = try await (snapshotTask, deployedTask)

        return try snapshot.documents.compactMap { doc in
            try parseMeta(from: doc, deployedTest: deployed.test, deployedLive: deployed.live)
        }
    }

    // MARK: - 특정 버전 조회

    func fetchVersion(_ version: Int) async throws -> (policy: PolicyDTO, formulas: [String: String]) {
        let ref = db.collection(Constant.versionsCollection).document("v\(version)")
        async let policyTask = fetchPolicyData(from: ref.collection(Constant.dataCollection))
        async let docTask = ref.getDocument()

        let (policy, doc) = try await (policyTask, docTask)
        let formulas = extractFormulas(from: doc.data() ?? [:])
        return (policy, formulas)
    }

    // MARK: - 버전 저장

    func saveVersion(fields: [PolicyField], modifiedBy: String) async throws -> Int {
        let snapshot = try await db.collection(Constant.versionsCollection)
            .order(by: Constant.versionField, descending: true)
            .limit(to: 1)
            .getDocuments()

        let nextVersion = (snapshot.documents.first.flatMap { $0.data()[Constant.versionField] as? Int } ?? 0) + 1

        let policy = try PolicyFieldMeta.makePolicy(from: fields)
        let formulas = buildFormulasMap(from: fields)

        var metadata: [String: Any] = [
            Constant.versionField: nextVersion,
            Constant.modifiedByField: modifiedBy,
            Constant.modifiedAtField: Timestamp(date: Date())
        ]
        if !formulas.isEmpty {
            metadata[Constant.formulasField] = formulas
        }

        let batch = db.batch()
        let versionRef = db.collection(Constant.versionsCollection).document("v\(nextVersion)")
        batch.setData(metadata, forDocument: versionRef)
        try writePolicyData(batch: batch, collection: versionRef.collection(Constant.dataCollection), policy: policy)

        try await batch.commit()
        return nextVersion
    }

    // MARK: - 배포 버전 조회

    func fetchDeployedVersionNumbers() async throws -> (test: Int?, live: Int?) {
        async let testDoc = db.collection(Constant.testCollection).document(Constant.currentDocID).getDocument()
        async let liveDoc = db.collection(Constant.liveCollection).document(Constant.currentDocID).getDocument()

        let (t, l) = try await (testDoc, liveDoc)
        return (
            t.data()?[Constant.versionField] as? Int,
            l.data()?[Constant.versionField] as? Int
        )
    }

    // MARK: - 배포

    func deploy(version: Int, to env: PolicyEnvironment, deployedBy: String) async throws {
        let now = Timestamp(date: Date())
        let envRef = db.collection(env.rawValue).document(Constant.currentDocID)
        let versionRef = db.collection(Constant.versionsCollection).document("v\(version)")
        let deploymentsField = env == .test ? Constant.testDeploymentsField : Constant.liveDeploymentsField

        let newRecord: [String: Any] = [
            Constant.deployedByKey: deployedBy,
            Constant.deployedAtKey: now
        ]

        let batch = db.batch()
        batch.setData([Constant.versionField: version], forDocument: envRef)
        batch.updateData([
            deploymentsField: FieldValue.arrayUnion([newRecord])
        ], forDocument: versionRef)

        try await batch.commit()
    }

    // MARK: - Private

    private func parseMeta(from doc: QueryDocumentSnapshot, deployedTest: Int?, deployedLive: Int?) throws -> PolicyVersionMeta {
        let data = doc.data()
        guard let version = data[Constant.versionField] as? Int,
              let modifiedBy = data[Constant.modifiedByField] as? String,
              let modifiedAt = (data[Constant.modifiedAtField] as? Timestamp)?.dateValue()
        else { throw RepositoryError.invalidData(doc.documentID) }

        return PolicyVersionMeta(
            id: doc.documentID,
            version: version,
            modifiedBy: modifiedBy,
            modifiedAt: modifiedAt,
            isDeployedToTest: deployedTest == version,
            isDeployedToLive: deployedLive == version,
            testDeployments: parseDeployRecords(from: data[Constant.testDeploymentsField]),
            liveDeployments: parseDeployRecords(from: data[Constant.liveDeploymentsField])
        )
    }

    /// Firestore 배열 필드를 DeployRecord 배열로 파싱합니다.
    private func parseDeployRecords(from value: Any?) -> [DeployRecord] {
        guard let arr = value as? [[String: Any]] else { return [] }
        return arr.compactMap { dict in
            guard let by = dict[Constant.deployedByKey] as? String,
                  let at = (dict[Constant.deployedAtKey] as? Timestamp)?.dateValue()
            else { return nil }
            return DeployRecord(deployedBy: by, deployedAt: at)
        }
    }

    /// Firestore 문서 data()에서 formulas 맵을 추출합니다. 없으면 빈 맵 반환.
    private func extractFormulas(from data: [String: Any]) -> [String: String] {
        data[Constant.formulasField] as? [String: String] ?? [:]
    }

    /// PolicyField 배열에서 수식 필드만 [id: rawInput] 맵으로 추출합니다.
    private func buildFormulasMap(from fields: [PolicyField]) -> [String: String] {
        fields
            .filter { $0.hasFormula }
            .reduce(into: [String: String]()) { $0[$1.id] = $1.rawInput }
    }

    private func fetchPolicyData(from collection: CollectionReference) async throws -> PolicyDTO {
        async let career     = collection.document(PolicyDataField.career.rawValue).getDocument(as: CareerPolicyDTO.self)
        async let fever      = collection.document(PolicyDataField.fever.rawValue).getDocument(as: FeverPolicyDTO.self)
        async let game       = collection.document(PolicyDataField.game.rawValue).getDocument(as: GamePolicyDTO.self)
        async let skill      = collection.document(PolicyDataField.skill.rawValue).getDocument(as: SkillPolicyDTO.self)
        async let consumable = collection.document(PolicyDataField.consumable.rawValue).getDocument(as: ConsumablePolicyDTO.self)
        async let equipment  = collection.document(PolicyDataField.equipment.rawValue).getDocument(as: EquipmentPolicyDTO.self)
        async let housing    = collection.document(PolicyDataField.housing.rawValue).getDocument(as: HousingPolicyDTO.self)
        async let system     = collection.document(PolicyDataField.system.rawValue).getDocument(as: SystemPolicyDTO.self)

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
