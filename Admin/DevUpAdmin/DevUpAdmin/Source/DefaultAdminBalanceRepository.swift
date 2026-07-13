import Foundation
import FirebaseFirestore

private enum Constant {
    enum Collection {
        static let versions = "versions"
        static let test = "test"
        static let live = "live"
        static let data = "Data"
        static let editingSession = "editingSession"
    }

    enum Document {
        static let current = "current"
        static func version(_ v: Int) -> String { "v\(v)" }
    }

    enum Field {
        static let version = "version"
        static let modifiedBy = "modifiedBy"
        static let modifiedAt = "modifiedAt"
        static let formulas = "formulas"
        static let testDeployments = "testDeployments"
        static let liveDeployments = "liveDeployments"
        static let baseVersion = "baseVersion"
        static let changes = "changes"
        // 편집 락
        static let lockedBy = "lockedBy"
        static let sessionId = "sessionId"
        static let lastHeartbeat = "lastHeartbeat"
        static let staleThreshold: TimeInterval = 60
    }

    enum Key {
        static let deployedBy = "deployedBy"
        static let deployedAt = "deployedAt"
        static let changeFieldId = "fieldId"
        static let changeFieldName = "fieldName"
        static let changeBefore = "before"
        static let changeAfter = "after"
        static let changeBeforeInput = "beforeInput"
        static let changeAfterInput = "afterInput"
    }
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
        // snapshot과 배포 버전 번호를 병렬 조회
        async let snapshotTask = db.collection(Constant.Collection.versions)
            .order(by: Constant.Field.version, descending: true)
            .limit(to: 1)
            .getDocuments()
        async let deployedTask = fetchDeployedVersionNumbers()

        let (snapshot, deployed) = try await (snapshotTask, deployedTask)
        guard let doc = snapshot.documents.first else { return nil }

        let meta = try parseMeta(from: doc, deployedTest: deployed.test, deployedLive: deployed.live)
        let formulas = extractFormulas(from: doc.data())
        let policy = try await fetchPolicyData(from: doc.reference.collection(Constant.Collection.data))
        return (meta, policy, formulas)
    }

    // MARK: - 버전 목록 조회

    func fetchVersionList() async throws -> [PolicyVersionMeta] {
        async let snapshotTask = db.collection(Constant.Collection.versions)
            .order(by: Constant.Field.version, descending: true)
            .getDocuments()
        async let deployedTask = fetchDeployedVersionNumbers()

        let (snapshot, deployed) = try await (snapshotTask, deployedTask)

        return try snapshot.documents.compactMap { doc in
            try parseMeta(from: doc, deployedTest: deployed.test, deployedLive: deployed.live)
        }
    }

    // MARK: - 특정 버전 조회

    func fetchVersion(_ version: Int) async throws -> (policy: PolicyDTO, formulas: [String: String]) {
        let ref = db.collection(Constant.Collection.versions).document(Constant.Document.version(version))
        async let policyTask = fetchPolicyData(from: ref.collection(Constant.Collection.data))
        async let docTask = ref.getDocument()

        let (policy, doc) = try await (policyTask, docTask)
        let formulas = extractFormulas(from: doc.data() ?? [:])
        return (policy, formulas)
    }

    // MARK: - 버전 저장

    func saveVersion(fields: [PolicyField], modifiedBy: String, baseVersion: Int?, changes: [FieldChangeRecord]) async throws -> Int {
        let snapshot = try await db.collection(Constant.Collection.versions)
            .order(by: Constant.Field.version, descending: true)
            .limit(to: 1)
            .getDocuments()

        let nextVersion = (snapshot.documents.first.flatMap { $0.data()[Constant.Field.version] as? Int } ?? 0) + 1

        let policy = try PolicyFieldMeta.makePolicy(from: fields)
        let formulas = buildFormulasMap(from: fields)

        var metadata: [String: Any] = [
            Constant.Field.version: nextVersion,
            Constant.Field.modifiedBy: modifiedBy,
            Constant.Field.modifiedAt: Timestamp(date: Date())
        ]
        if !formulas.isEmpty {
            metadata[Constant.Field.formulas] = formulas
        }
        if let baseVersion {
            metadata[Constant.Field.baseVersion] = baseVersion
        }
        if !changes.isEmpty {
            metadata[Constant.Field.changes] = changes.map { c in
                [
                    Constant.Key.changeFieldId: c.fieldId,
                    Constant.Key.changeFieldName: c.fieldName,
                    Constant.Key.changeBefore: c.before,
                    Constant.Key.changeAfter: c.after,
                    Constant.Key.changeBeforeInput: c.beforeInput,
                    Constant.Key.changeAfterInput: c.afterInput
                ] as [String: Any]
            }
        }

        let batch = db.batch()
        let versionRef = db.collection(Constant.Collection.versions).document(Constant.Document.version(nextVersion))
        batch.setData(metadata, forDocument: versionRef)
        try writePolicyData(batch: batch, collection: versionRef.collection(Constant.Collection.data), policy: policy)

        try await batch.commit()
        return nextVersion
    }

    // MARK: - 배포 버전 조회

    func fetchDeployedVersionNumbers() async throws -> (test: Int?, live: Int?) {
        async let testDoc = db.collection(Constant.Collection.test).document(Constant.Document.current).getDocument()
        async let liveDoc = db.collection(Constant.Collection.live).document(Constant.Document.current).getDocument()

        let (t, l) = try await (testDoc, liveDoc)
        return (
            t.data()?[Constant.Field.version] as? Int,
            l.data()?[Constant.Field.version] as? Int
        )
    }

    // MARK: - 배포

    func deploy(version: Int, to env: PolicyEnvironment, deployedBy: String) async throws {
        let now = Timestamp(date: Date())
        let envRef = db.collection(env.rawValue).document(Constant.Document.current)
        let versionRef = db.collection(Constant.Collection.versions).document(Constant.Document.version(version))
        let deploymentsField = env == .test ? Constant.Field.testDeployments : Constant.Field.liveDeployments

        let newRecord: [String: Any] = [
            Constant.Key.deployedBy: deployedBy,
            Constant.Key.deployedAt: now
        ]

        let batch = db.batch()
        batch.setData([Constant.Field.version: version], forDocument: envRef)
        batch.updateData([
            deploymentsField: FieldValue.arrayUnion([newRecord])
        ], forDocument: versionRef)

        try await batch.commit()
    }

    // MARK: - Private

    private func parseMeta(from doc: QueryDocumentSnapshot, deployedTest: Int?, deployedLive: Int?) throws -> PolicyVersionMeta {
        let data = doc.data()
        guard let version = data[Constant.Field.version] as? Int,
              let modifiedBy = data[Constant.Field.modifiedBy] as? String,
              let modifiedAt = (data[Constant.Field.modifiedAt] as? Timestamp)?.dateValue()
        else { throw RepositoryError.invalidData(doc.documentID) }

        return PolicyVersionMeta(
            id: doc.documentID,
            version: version,
            modifiedBy: modifiedBy,
            modifiedAt: modifiedAt,
            isDeployedToTest: deployedTest == version,
            isDeployedToLive: deployedLive == version,
            testDeployments: parseDeployRecords(from: data[Constant.Field.testDeployments]),
            liveDeployments: parseDeployRecords(from: data[Constant.Field.liveDeployments]),
            baseVersion: data[Constant.Field.baseVersion] as? Int,
            fieldChanges: parseFieldChanges(from: data[Constant.Field.changes])
        )
    }

    /// Firestore 배열 필드를 FieldChangeRecord 배열로 파싱합니다.
    private func parseFieldChanges(from value: Any?) -> [FieldChangeRecord] {
        guard let arr = value as? [[String: Any]] else { return [] }
        return arr.compactMap { dict in
            guard let fieldId   = dict[Constant.Key.changeFieldId] as? String,
                  let fieldName = dict[Constant.Key.changeFieldName] as? String,
                  let before    = dict[Constant.Key.changeBefore] as? Double,
                  let after     = dict[Constant.Key.changeAfter] as? Double
            else { return nil }
            let beforeInput = dict[Constant.Key.changeBeforeInput] as? String ?? ""
            let afterInput  = dict[Constant.Key.changeAfterInput] as? String ?? ""
            return FieldChangeRecord(fieldId: fieldId, fieldName: fieldName, before: before, after: after, beforeInput: beforeInput, afterInput: afterInput)
        }
    }

    /// Firestore 배열 필드를 DeployRecord 배열로 파싱합니다.
    private func parseDeployRecords(from value: Any?) -> [DeployRecord] {
        guard let arr = value as? [[String: Any]] else { return [] }
        return arr.compactMap { dict in
            guard let by = dict[Constant.Key.deployedBy] as? String,
                  let at = (dict[Constant.Key.deployedAt] as? Timestamp)?.dateValue()
            else { return nil }
            return DeployRecord(id: "\(by)_\(at.timeIntervalSince1970)", deployedBy: by, deployedAt: at)
        }
    }

    /// Firestore 문서 data()에서 formulas 맵을 추출합니다. 없으면 빈 맵 반환.
    private func extractFormulas(from data: [String: Any]) -> [String: String] {
        data[Constant.Field.formulas] as? [String: String] ?? [:]
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
        let ad = try? await collection.document(PolicyDataField.ad.rawValue).getDocument(as: AdPolicyDTO.self)

        return try await PolicyDTO(
            version: "",
            career: career,
            fever: fever,
            game: game,
            skill: skill,
            consumable: consumable,
            equipment: equipment,
            housing: housing,
            system: system,
            ad: ad
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
        try batch.setData(from: policy.ad,         forDocument: collection.document(PolicyDataField.ad.rawValue))
    }

    // MARK: - 편집 락

    func acquireLock(username: String, sessionId: String) async throws -> Bool {
        let lockRef = db.collection(Constant.Collection.editingSession).document(Constant.Document.current)
        let doc = try await lockRef.getDocument()
        let now = Timestamp(date: Date())
        let newData: [String: Any] = [
            Constant.Field.lockedBy: username,
            Constant.Field.sessionId: sessionId,
            Constant.Field.lastHeartbeat: now
        ]

        if !doc.exists {
            try await lockRef.setData(newData)
            return true
        }

        guard let data = doc.data(),
              let existingSession = data[Constant.Field.sessionId] as? String,
              let lastHeartbeat = (data[Constant.Field.lastHeartbeat] as? Timestamp)?.dateValue()
        else {
            try await lockRef.setData(newData)
            return true
        }

        if existingSession == sessionId {
            try await lockRef.updateData([Constant.Field.lastHeartbeat: now])
            return true
        }

        if Date().timeIntervalSince(lastHeartbeat) > Constant.Field.staleThreshold {
            try await lockRef.setData(newData)
            return true
        }

        return false
    }

    func releaseLock(sessionId: String) async throws {
        let lockRef = db.collection(Constant.Collection.editingSession).document(Constant.Document.current)
        let doc = try await lockRef.getDocument()
        guard (doc.data()?[Constant.Field.sessionId] as? String) == sessionId else { return }
        try await lockRef.delete()
    }

    func heartbeat() async throws {
        let lockRef = db.collection(Constant.Collection.editingSession).document(Constant.Document.current)
        try await lockRef.updateData([Constant.Field.lastHeartbeat: Timestamp(date: Date())])
    }

    func fetchLock() async throws -> (lockedBy: String, sessionId: String)? {
        let doc = try await db.collection(Constant.Collection.editingSession)
            .document(Constant.Document.current)
            .getDocument()
        guard doc.exists,
              let data = doc.data(),
              let lockedBy = data[Constant.Field.lockedBy] as? String,
              let sessionId = data[Constant.Field.sessionId] as? String,
              let lastHeartbeat = (data[Constant.Field.lastHeartbeat] as? Timestamp)?.dateValue(),
              Date().timeIntervalSince(lastHeartbeat) <= Constant.Field.staleThreshold
        else { return nil }
        return (lockedBy, sessionId)
    }
}
