import Foundation
import Combine
import AppKit

@MainActor
final class PolicyEditorViewModel: ObservableObject {

    @Published var fields: [PolicyField] = []
    @Published var currentVersionMeta: PolicyVersionMeta?
    @Published var versionHistory: [PolicyVersionMeta] = []
    @Published var crossFieldErrors: [String: String] = [:]
    @Published var formulaErrors: [String: String] = [:]
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var isDeploying = false
    @Published var errorMessage: String?
    var hasUnsavedChanges: Bool { !changedFields.isEmpty }

    // MARK: - 편집 락
    @Published var canEdit = false
    /// nil이면 본인이 락 보유 중 또는 아직 확인 전. 값이 있으면 해당 유저가 락 보유 중.
    @Published var lockOwner: String? = nil

    /// 현재 편집의 기준이 된 버전의 필드값 스냅샷 (fieldId → resolvedValue)
    private(set) var baseFieldValues: [String: Double] = [:]
    /// 현재 편집의 기준이 된 버전의 rawInput 스냅샷 (fieldId → rawInput)
    private(set) var baseFieldInputs: [String: String] = [:]

    private let repository: AdminPolicyRepository
    private let sessionId = UUID().uuidString
    private var currentUsername = ""
    private var heartbeatTask: Task<Void, Never>?
    private var lockRetryTask: Task<Void, Never>?

    init(repository: AdminPolicyRepository = DefaultAdminPolicyRepository()) {
        self.repository = repository
        NotificationCenter.default.addObserver(
            forName: NSApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            Task { try? await self.repository.releaseLock(sessionId: self.sessionId) }
        }
    }

    // MARK: - 그룹

    var groups: [String] {
        var seen = Set<String>()
        return PolicyFieldMeta.all.map(\.group).filter { seen.insert($0).inserted }
    }

    func groupedFields(for group: String) -> [(section: String, fields: [PolicyField])] {
        let filtered = fields.filter { $0.group == group }
        var seen = Set<String>()
        let sections = filtered.map(\.section).filter { seen.insert($0).inserted }
        return sections.map { section in
            (section, filtered.filter { $0.section == section })
        }
    }

    // MARK: - 유효성

    /// 특정 필드의 최종 오류 메시지 (포맷 → 수식오류 → 단일 규칙 → 크로스필드 순 우선순위)
    func validationError(for fieldID: String) -> String? {
        guard let field = fields.first(where: { $0.id == fieldID }) else { return nil }
        if let formatError = field.inputFormatError { return formatError }
        if let formulaError = formulaErrors[fieldID] { return formulaError }
        if let singleError = field.singleFieldError { return singleError }
        return crossFieldErrors[fieldID]
    }

    /// 그룹 전체의 오류 수
    func errorCount(for group: String) -> Int {
        let groupFields = fields.filter { $0.group == group }
        let errorIDs = Set(
            groupFields
                .filter {
                    $0.inputFormatError != nil || formulaErrors[$0.id] != nil ||
                    $0.singleFieldError != nil || crossFieldErrors[$0.id] != nil
                }
                .map(\.id)
        )
        return errorIDs.count
    }

    /// 전체 오류가 있으면 저장 불가
    var hasValidationErrors: Bool {
        let hasFieldError = fields.contains { field in
            field.inputFormatError != nil || field.singleFieldError != nil
        }
        return hasFieldError || !crossFieldErrors.isEmpty || !formulaErrors.isEmpty
    }

    // MARK: - 데이터 로드

    func loadLatest() async {
        isLoading = true
        errorMessage = nil
        do {
            // 최신 버전과 버전 이력을 병렬 조회
            async let latestTask = repository.fetchLatestVersion()
            async let historyTask = repository.fetchVersionList()

            if let result = try await latestTask {
                currentVersionMeta = result.meta
                fields = try PolicyFieldMeta.makeFields(from: result.policy, formulas: result.formulas)
            } else {
                currentVersionMeta = nil
                fields = PolicyFieldMeta.all.map { meta in
                    PolicyField(
                        id: meta.id,
                        group: meta.group,
                        section: meta.section,
                        name: meta.name,
                        isDouble: meta.isDouble,
                        rawInput: "0",
                        resolvedValue: 0
                    )
                }
            }
            evaluateAllFormulas()
            snapshotBaseFields()
            versionHistory = try await historyTask
        } catch {
            errorMessage = "불러오기 실패: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func loadVersion(_ version: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await repository.fetchVersion(version)
            fields = try PolicyFieldMeta.makeFields(from: result.policy, formulas: result.formulas)
            evaluateAllFormulas()
            snapshotBaseFields()
            currentVersionMeta = versionHistory.first { $0.version == version }
        } catch {
            errorMessage = "버전 불러오기 실패: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // MARK: - 저장

    func save(modifiedBy: String) async {
        guard canEdit else {
            errorMessage = "편집 권한이 없습니다. 다른 관리자가 편집 중입니다."
            return
        }
        guard !hasValidationErrors else {
            errorMessage = "유효성 오류가 있는 필드가 있습니다. 오류를 먼저 수정해주세요."
            return
        }
        isSaving = true
        errorMessage = nil
        let baseVer = currentVersionMeta?.version
        let changes = changedFields.map { c in
            FieldChangeRecord(fieldId: c.field.id, fieldName: c.field.name, before: c.before, after: c.after, beforeInput: c.beforeInput, afterInput: c.afterInput)
        }
        do {
            let newVersion = try await repository.saveVersion(fields: fields, modifiedBy: modifiedBy, baseVersion: baseVer, changes: changes)
            versionHistory = try await repository.fetchVersionList()
            currentVersionMeta = versionHistory.first { $0.version == newVersion }
            snapshotBaseFields()
        } catch {
            errorMessage = "저장 실패: \(error.localizedDescription)"
        }
        isSaving = false
    }

    // MARK: - 배포

    func deploy(version: Int, to env: PolicyEnvironment, deployedBy: String) async {
        guard canEdit else {
            errorMessage = "편집 권한이 없습니다. 다른 관리자가 편집 중입니다."
            return
        }
        isDeploying = true
        errorMessage = nil
        do {
            try await repository.deploy(version: version, to: env, deployedBy: deployedBy)
            versionHistory = try await repository.fetchVersionList()
            if let current = currentVersionMeta {
                currentVersionMeta = versionHistory.first { $0.version == current.version }
            }
        } catch {
            errorMessage = "배포 실패: \(error.localizedDescription)"
        }
        isDeploying = false
    }

    // MARK: - 필드 수정

    func updateField(id: String, rawInput: String) {
        guard let idx = fields.firstIndex(where: { $0.id == id }) else { return }
        fields[idx].rawInput = rawInput
        evaluateAllFormulas()
    }

    // MARK: - 수식 평가 + 유효성 갱신

    func evaluateAllFormulas() {
        // 1차: 수식이 아닌 필드 먼저 확정
        for i in fields.indices {
            if !fields[i].hasFormula {
                let raw = Double(fields[i].rawInput.trimmingCharacters(in: .whitespaces)) ?? 0
                fields[i].resolvedValue = fields[i].isDouble ? (raw * 1000).rounded() / 1000 : raw
            }
        }

        // ID → resolvedValue 컨텍스트
        var context = fields.reduce(into: [String: Double]()) { $0[$1.id] = $1.resolvedValue }

        // 한글 이름 → resolvedValue 컨텍스트 (중복 이름은 제거)
        var nameContext: [String: Double] = [:]
        var ambiguousNames = Set<String>()
        for field in fields {
            if nameContext[field.name] != nil {
                ambiguousNames.insert(field.name)
            }
            nameContext[field.name] = field.resolvedValue
        }
        for name in ambiguousNames { nameContext.removeValue(forKey: name) }

        // 2차: 수식 필드 평가
        var newFormulaErrors: [String: String] = [:]
        for i in fields.indices {
            guard fields[i].hasFormula else { continue }
            let result = FormulaEvaluator.evaluateDetailed(
                fields[i].rawInput,
                context: context,
                nameContext: nameContext
            )
            switch result {
            case .value(let v):
                let rounded = fields[i].isDouble ? (v * 1000).rounded() / 1000 : v
                fields[i].resolvedValue = rounded
                context[fields[i].id] = rounded
                nameContext[fields[i].name] = rounded
            case .divisionByZero:
                newFormulaErrors[fields[i].id] = "0으로 나눌 수 없습니다."
                fields[i].resolvedValue = 0
            case .overflow:
                newFormulaErrors[fields[i].id] = "오버플로우가 발생했습니다."
                fields[i].resolvedValue = 0
            case .unknownIdentifier(let name):
                newFormulaErrors[fields[i].id] = "'\(name)'은(는) 존재하지 않는 필드명입니다."
                fields[i].resolvedValue = 0
            case .invalid:
                newFormulaErrors[fields[i].id] = "수식을 계산할 수 없습니다."
                fields[i].resolvedValue = 0
            }
        }
        formulaErrors = newFormulaErrors

        crossFieldErrors = CrossFieldValidation.validate(fields: fields)
    }

    func clearError() {
        errorMessage = nil
    }

    // MARK: - 편집 락

    func acquireLock(username: String) async {
        currentUsername = username
        do {
            let acquired = try await repository.acquireLock(username: username, sessionId: sessionId)
            if acquired {
                canEdit = true
                lockOwner = nil
                startHeartbeat()
                lockRetryTask?.cancel()
            } else {
                canEdit = false
                lockOwner = try await repository.fetchLock()?.lockedBy
                startLockRetry()
            }
        } catch {
            // 락 실패는 편집 불가 처리 (네트워크 오류 등)
            canEdit = false
        }
    }

    func releaseLock() async {
        heartbeatTask?.cancel()
        lockRetryTask?.cancel()
        try? await repository.releaseLock(sessionId: sessionId)
        canEdit = false
        lockOwner = nil
    }

    private func startHeartbeat() {
        heartbeatTask?.cancel()
        heartbeatTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(30))
                guard let self, !Task.isCancelled else { break }
                do {
                    try await self.repository.heartbeat()
                } catch {
                    // heartbeat 실패 시 락 재확인
                    await self.acquireLock(username: self.currentUsername)
                }
            }
        }
    }

    private func startLockRetry() {
        lockRetryTask?.cancel()
        lockRetryTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(30))
                guard let self, !Task.isCancelled else { break }
                await self.acquireLock(username: self.currentUsername)
                if self.canEdit { break }
            }
        }
    }

    // MARK: - 변경사항 추적

    private func snapshotBaseFields() {
        baseFieldValues = Dictionary(uniqueKeysWithValues: fields.map { ($0.id, $0.resolvedValue) })
        baseFieldInputs = Dictionary(uniqueKeysWithValues: fields.map { ($0.id, $0.rawInput) })
    }

    struct FieldChange {
        let field: PolicyField
        let before: Double
        let after: Double
        let beforeInput: String
        let afterInput: String
    }

    var changedFields: [FieldChange] {
        fields.compactMap { field in
            let baseValue = baseFieldValues[field.id]
            let baseInput = baseFieldInputs[field.id]
            let valueChanged = baseValue != nil && field.resolvedValue != baseValue!
            let inputChanged = baseInput != nil && field.rawInput != baseInput!
            guard valueChanged || inputChanged else { return nil }
            return FieldChange(
                field: field,
                before: baseValue ?? 0,
                after: field.resolvedValue,
                beforeInput: baseInput ?? "",
                afterInput: field.rawInput
            )
        }
    }
}
