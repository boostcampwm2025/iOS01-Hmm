import Foundation
import Combine

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
    @Published var hasUnsavedChanges = false

    private let repository: AdminPolicyRepository

    init(repository: AdminPolicyRepository = DefaultAdminPolicyRepository()) {
        self.repository = repository
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
            if let result = try await repository.fetchLatestVersion() {
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
            versionHistory = try await repository.fetchVersionList()
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
            currentVersionMeta = versionHistory.first { $0.version == version }
            hasUnsavedChanges = false
        } catch {
            errorMessage = "버전 불러오기 실패: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // MARK: - 저장

    func save(modifiedBy: String) async {
        guard !hasValidationErrors else {
            errorMessage = "유효성 오류가 있는 필드가 있습니다. 오류를 먼저 수정해주세요."
            return
        }
        isSaving = true
        errorMessage = nil
        do {
            let newVersion = try await repository.saveVersion(fields: fields, modifiedBy: modifiedBy)
            versionHistory = try await repository.fetchVersionList()
            currentVersionMeta = versionHistory.first { $0.version == newVersion }
            hasUnsavedChanges = false
        } catch {
            errorMessage = "저장 실패: \(error.localizedDescription)"
        }
        isSaving = false
    }

    // MARK: - 배포

    func deploy(version: Int, to env: PolicyEnvironment, deployedBy: String) async {
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
        hasUnsavedChanges = true
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
}
