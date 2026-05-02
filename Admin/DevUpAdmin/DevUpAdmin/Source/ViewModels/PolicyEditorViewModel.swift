import Foundation
import Combine

@MainActor
final class PolicyEditorViewModel: ObservableObject {

    @Published var fields: [PolicyField] = []
    @Published var currentVersionMeta: PolicyVersionMeta?
    @Published var versionHistory: [PolicyVersionMeta] = []
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

    // MARK: - 데이터 로드

    func loadLatest() async {
        isLoading = true
        errorMessage = nil
        do {
            if let result = try await repository.fetchLatestVersion() {
                currentVersionMeta = result.meta
                fields = try PolicyFieldMeta.makeFields(from: result.policy)
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
            let policy = try await repository.fetchVersion(version)
            fields = try PolicyFieldMeta.makeFields(from: policy)
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
        isSaving = true
        errorMessage = nil
        do {
            let policy = try PolicyFieldMeta.makePolicy(from: fields)
            let newVersion = try await repository.saveVersion(policy: policy, modifiedBy: modifiedBy)
            versionHistory = try await repository.fetchVersionList()
            currentVersionMeta = versionHistory.first { $0.version == newVersion }
            hasUnsavedChanges = false
        } catch {
            errorMessage = "저장 실패: \(error.localizedDescription)"
        }
        isSaving = false
    }

    // MARK: - 배포

    func deploy(version: Int, to env: PolicyEnvironment) async {
        isDeploying = true
        errorMessage = nil
        do {
            try await repository.deploy(version: version, to: env)
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

    // MARK: - 수식 평가

    func evaluateAllFormulas() {
        for i in fields.indices {
            if !fields[i].hasFormula {
                fields[i].resolvedValue = Double(fields[i].rawInput.trimmingCharacters(in: .whitespaces)) ?? 0
            }
        }
        var context = fields.reduce(into: [String: Double]()) { $0[$1.id] = $1.resolvedValue }
        for i in fields.indices {
            guard fields[i].hasFormula else { continue }
            let evaluated = FormulaEvaluator.evaluate(fields[i].rawInput, context: context) ?? 0
            fields[i].resolvedValue = evaluated
            context[fields[i].id] = evaluated
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
