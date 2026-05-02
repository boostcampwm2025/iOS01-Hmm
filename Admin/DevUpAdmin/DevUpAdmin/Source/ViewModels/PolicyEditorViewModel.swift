import Foundation
import Combine

@MainActor
final class PolicyEditorViewModel: ObservableObject {

    @Published var environment: PolicyEnvironment = .test {
        didSet {
            guard oldValue != environment else { return }
            Task { await loadLatest() }
        }
    }

    @Published var fields: [PolicyField] = []
    @Published var currentVersionMeta: PolicyVersionMeta?
    @Published var versionHistory: [PolicyVersionMeta] = []
    @Published var selectedCategory: String?
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var hasUnsavedChanges = false

    private let repository: AdminPolicyRepository

    init(repository: AdminPolicyRepository = DefaultAdminPolicyRepository()) {
        self.repository = repository
    }

    // MARK: - 카테고리

    var categories: [String] {
        var seen = Set<String>()
        return PolicyFieldMeta.all
            .map(\.category)
            .filter { seen.insert($0).inserted }
    }

    var fieldsForSelectedCategory: [PolicyField] {
        guard let cat = selectedCategory else { return [] }
        return fields.filter { $0.category == cat }
    }

    // MARK: - 데이터 로드

    func loadLatest() async {
        isLoading = true
        errorMessage = nil
        do {
            if let result = try await repository.fetchLatest(env: environment) {
                currentVersionMeta = result.meta
                fields = try PolicyFieldMeta.makeFields(from: result.policy)
            } else {
                currentVersionMeta = nil
                fields = PolicyFieldMeta.all.map { meta in
                    PolicyField(
                        id: meta.id,
                        category: meta.category,
                        name: meta.name,
                        isDouble: meta.isDouble,
                        rawInput: "0",
                        resolvedValue: 0
                    )
                }
            }
            evaluateAllFormulas()
            versionHistory = try await repository.fetchVersionList(env: environment)
        } catch {
            errorMessage = "불러오기 실패: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func loadVersion(_ version: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let policy = try await repository.fetchPolicy(env: environment, version: version)
            fields = try PolicyFieldMeta.makeFields(from: policy)
            evaluateAllFormulas()
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
            try await repository.savePolicy(env: environment, policy: policy, modifiedBy: modifiedBy)
            versionHistory = try await repository.fetchVersionList(env: environment)
            if let latest = try await repository.fetchLatest(env: environment) {
                currentVersionMeta = latest.meta
            }
            hasUnsavedChanges = false
        } catch {
            errorMessage = "저장 실패: \(error.localizedDescription)"
        }
        isSaving = false
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
