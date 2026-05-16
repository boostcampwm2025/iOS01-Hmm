import SwiftUI

// MARK: - 사이드바 항목

enum SidebarItem: Hashable {
    case editor(String)
    case versionHistory
    case deploymentStatus
    case changes
    case profile
}

// MARK: - ContentView (루트)

struct ContentView: View {
    @AppStorage("adminUsername") var username: String = ""
    @StateObject private var vm = PolicyEditorViewModel()
    @State private var selection: SidebarItem?

    var body: some View {
        Group {
            if username.isEmpty {
                LoginView(username: $username)
            } else {
                mainView
            }
        }
        .onChange(of: username) { _, new in
            if !new.isEmpty { Task { await vm.loadLatest() } }
        }
        .alert("오류", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.clearError() } }
        )) {
            Button("확인") { vm.clearError() }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }

    private var mainView: some View {
        NavigationSplitView {
            AppSidebarView(vm: vm, selection: $selection, username: username)
        } detail: {
            DetailRouterView(vm: vm, selection: selection, username: $username)
        }
        .onAppear {
            Task { await vm.loadLatest() }
        }
    }
}

// MARK: - 사이드바

struct AppSidebarView: View {
    @ObservedObject var vm: PolicyEditorViewModel
    @Binding var selection: SidebarItem?
    let username: String
    @State private var showSaveConfirm = false

    var body: some View {
        List(selection: $selection) {
            Section {
                versionCard
            }

            Section("밸런스 편집") {
                ForEach(vm.groups, id: \.self) { group in
                    HStack {
                        Label(group, systemImage: iconFor(group))
                        Spacer()
                        let count = vm.errorCount(for: group)
                        if count > 0 {
                            Text("\(count)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                    .tag(SidebarItem.editor(group))
                }
            }

            Section("관리") {
                HStack {
                    Label("변경사항", systemImage: "pencil.circle")
                    Spacer()
                    let count = vm.changedFields.count
                    if count > 0 {
                        Text("\(count)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange)
                            .clipShape(Capsule())
                    }
                }
                .tag(SidebarItem.changes)
                Label("버전 이력", systemImage: "clock.arrow.circlepath")
                    .tag(SidebarItem.versionHistory)
                Label("배포 현황", systemImage: "antenna.radiowaves.left.and.right")
                    .tag(SidebarItem.deploymentStatus)
                Label("프로필", systemImage: "person.circle")
                    .tag(SidebarItem.profile)
            }
        }
        .listStyle(.sidebar)
        .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
        .navigationTitle("DevUp Admin")
    }

    private var versionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            if vm.isLoading {
                HStack(spacing: 8) {
                    ProgressView().scaleEffect(0.8)
                    Text("불러오는 중...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else if let meta = vm.currentVersionMeta {
                // 새 버전 작성 중임을 명확히 표시
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 5) {
                            Image(systemName: "plus.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.blue)
                            Text("새 버전 작성 중")
                                .font(.caption.bold())
                                .foregroundStyle(.blue)
                        }
                        Text("기준: \(meta.versionLabel) · \(meta.modifiedBy)")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(.tertiaryLabelColor))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        if meta.isDeployedToTest { DeployBadge(env: .test) }
                        if meta.isDeployedToLive { DeployBadge(env: .live) }
                    }
                }

                // 변경사항 요약
                let changes = vm.changedFields
                if !changes.isEmpty {
                    Button { showSaveConfirm = false; selection = .changes } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 10))
                            Text("변경사항 \(changes.count)건")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundStyle(.orange)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text("버전 없음")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if vm.hasValidationErrors {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                    Text("유효성 오류가 있어 저장할 수 없습니다.")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            Button {
                showSaveConfirm = true
            } label: {
                HStack(spacing: 6) {
                    if vm.isSaving {
                        ProgressView().scaleEffect(0.65)
                    } else {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Text(vm.hasUnsavedChanges ? "새 버전으로 저장 ●" : "새 버전으로 저장")
                        .font(.caption.bold())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .disabled(vm.isSaving || vm.hasValidationErrors)
            .confirmationDialog("현재 편집 내용을 새 버전으로 저장합니다.", isPresented: $showSaveConfirm, titleVisibility: .visible) {
                Button("저장") { Task { await vm.save(modifiedBy: username) } }
                Button("취소", role: .cancel) {}
            }
        }
        .padding(.vertical, 4)
    }

    private func iconFor(_ group: String) -> String {
        switch group {
        case "커리어":     return "briefcase.fill"
        case "피버":       return "flame.fill"
        case "게임":       return "gamecontroller.fill"
        case "스킬":       return "star.fill"
        case "장비":       return "wrench.and.screwdriver.fill"
        case "주거":       return "house.fill"
        case "소비 아이템": return "cart.fill"
        case "시스템":     return "gearshape.fill"
        default:           return "square.fill"
        }
    }
}

// MARK: - 상세 라우터

struct DetailRouterView: View {
    @ObservedObject var vm: PolicyEditorViewModel
    let selection: SidebarItem?
    @Binding var username: String

    var body: some View {
        switch selection {
        case .editor(let group):
            PolicyGroupView(group: group, vm: vm)
        case .versionHistory:
            VersionHistoryPageView(vm: vm, username: username)
        case .deploymentStatus:
            DeploymentStatusPageView(vm: vm)
        case .changes:
            ChangesView(vm: vm)
        case .profile:
            ProfilePageView(username: $username)
        case nil:
            WelcomeView(vm: vm)
        }
    }
}

// MARK: - 환영 화면

struct WelcomeView: View {
    @ObservedObject var vm: PolicyEditorViewModel

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.blue)
            }

            VStack(spacing: 8) {
                if let meta = vm.currentVersionMeta {
                    Text("\(meta.versionLabel) 기준으로 새 버전 작성 중")
                        .font(.title2.bold())
                    HStack(spacing: 6) {
                        if meta.isDeployedToTest { DeployBadge(env: .test) }
                        if meta.isDeployedToLive { DeployBadge(env: .live) }
                    }
                    Text("\(meta.modifiedBy) · \(meta.modifiedAtFormatted)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if vm.isLoading {
                    ProgressView("버전 불러오는 중...")
                } else {
                    Text("저장된 버전이 없습니다")
                        .font(.title2.bold())
                    Text("왼쪽 사이드바에서 편집 후 저장하세요.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            if !vm.isLoading {
                Text("왼쪽에서 편집할 카테고리를 선택하세요.")
                    .font(.subheadline)
                    .foregroundStyle(Color(.tertiaryLabelColor))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.windowBackgroundColor))
    }
}

// MARK: - 프로필 페이지

struct ProfilePageView: View {
    @Binding var username: String
    @State private var editingName = ""
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            pageHeader("프로필", subtitle: "수정 이력에 기록되는 이름을 관리합니다.")
            Divider()

            VStack(spacing: 24) {
                // 아바타
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 80, height: 80)
                    Text(String(username.prefix(1)).uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.blue)
                }
                .padding(.top, 16)

                if isEditing {
                    VStack(spacing: 12) {
                        TextField("이름", text: $editingName)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 240)
                            .onSubmit { saveName() }

                        HStack(spacing: 8) {
                            Button("저장") { saveName() }
                                .buttonStyle(.borderedProminent)
                                .disabled(editingName.trimmingCharacters(in: .whitespaces).isEmpty)
                            Button("취소") {
                                isEditing = false
                                editingName = username
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else {
                    VStack(spacing: 10) {
                        Text(username)
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                        Button("이름 수정") {
                            editingName = username
                            isEditing = true
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.regular)
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(.windowBackgroundColor))
        .onAppear { editingName = username }
    }

    private func saveName() {
        let trimmed = editingName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        username = trimmed
        isEditing = false
    }
}

// MARK: - 밸런스 편집 뷰

struct PolicyGroupView: View {
    let group: String
    @ObservedObject var vm: PolicyEditorViewModel
    @State private var collapsedSections: Set<String> = []

    var sectioned: [(section: String, fields: [PolicyField])] {
        vm.groupedFields(for: group)
    }

    var body: some View {
        VStack(spacing: 0) {
            if vm.isLoading {
                ProgressView("불러오는 중...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                tableHeader
                Divider()
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                        ForEach(sectioned, id: \.section) { item in
                            SwiftUI.Section {
                                if !collapsedSections.contains(item.section) {
                                    ForEach(item.fields) { field in
                                        PolicyFieldRow(
                                            field: field,
                                            errorMessage: vm.validationError(for: field.id)
                                        ) { id, raw in
                                            vm.updateField(id: id, rawInput: raw)
                                        }
                                        Divider().padding(.leading, 216)
                                    }
                                }
                            } header: {
                                if !item.section.isEmpty {
                                    sectionHeader(item.section, isCollapsed: collapsedSections.contains(item.section))
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(group)
        .background(Color(.windowBackgroundColor))
    }

    private var tableHeader: some View {
        HStack(spacing: 0) {
            Text("항목")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .frame(width: 208, alignment: .leading)
                .padding(.horizontal, 16)
            Divider().frame(height: 16)
            Text("값 / 수식 (= 로 시작)")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .frame(minWidth: 200, alignment: .leading)
                .padding(.horizontal, 16)
            Divider().frame(height: 16)
            Text("결과")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .frame(width: 140, alignment: .leading)
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 10)
        .background(Color(.controlBackgroundColor))
    }

    private func sectionHeader(_ title: String, isCollapsed: Bool) -> some View {
        Button {
            if isCollapsed {
                collapsedSections.remove(title)
            } else {
                collapsedSections.insert(title)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(Color(.tertiaryLabelColor))
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.controlBackgroundColor).opacity(0.8))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 필드 행 (유효성 포함)

struct PolicyFieldRow: View {
    let field: PolicyField
    let errorMessage: String?
    let onUpdate: (String, String) -> Void
    @State private var localInput: String
    @State private var isCopied = false

    init(field: PolicyField, errorMessage: String?, onUpdate: @escaping (String, String) -> Void) {
        self.field = field
        self.errorMessage = errorMessage
        self.onUpdate = onUpdate
        self._localInput = State(initialValue: field.rawInput)
    }

    var hasError: Bool { errorMessage != nil }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // 항목명
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(field.name)
                            .font(.callout)
                        if hasError {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    HStack(spacing: 4) {
                        Text(field.id)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(Color(.tertiaryLabelColor))
                        Button {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(field.id, forType: .string)
                            isCopied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { isCopied = false }
                        } label: {
                            Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 9))
                                .foregroundStyle(isCopied ? Color.green : Color(.tertiaryLabelColor))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: 208, alignment: .leading)
                .padding(.horizontal, 16)

                Divider().frame(height: hasError ? 40 : 28)

                // 입력 필드
                TextField(field.validationHint ?? "값 입력", text: $localInput)
                    .textFieldStyle(.plain)
                    .font(.callout)
                    .frame(minWidth: 200, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(backgroundFor(hasFormula: field.hasFormula, hasError: hasError))
                    .onSubmit { onUpdate(field.id, localInput) }
                    .onChange(of: localInput) { _, new in
                        // 항상 VM에 즉시 전달 → 실시간 유효성 반응
                        onUpdate(field.id, new)
                    }

                Divider().frame(height: hasError ? 40 : 28)

                // 결과값
                Group {
                    if field.hasFormula {
                        Text("→ \(field.displayValue)")
                            .foregroundStyle(hasError ? .red : .blue.opacity(0.8))
                    } else {
                        Text(field.displayValue)
                            .foregroundStyle(hasError ? .red : Color(.tertiaryLabelColor))
                    }
                }
                .font(.callout)
                .frame(width: 140, alignment: .leading)
                .padding(.horizontal, 16)
            }

            // 오류 메시지 인라인
            if let msg = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                    Text(msg)
                        .font(.caption)
                }
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 224)
                .padding(.bottom, 5)
            }
        }
        .padding(.top, 4)
        .background(hasError ? Color.red.opacity(0.03) : Color.clear)
        .onChange(of: field.rawInput) { _, new in
            if new != localInput { localInput = new }
        }
    }

    private func backgroundFor(hasFormula: Bool, hasError: Bool) -> Color {
        if hasError    { return Color.red.opacity(0.06) }
        if hasFormula  { return Color.blue.opacity(0.05) }
        return .clear
    }
}

// MARK: - 배포 배지

struct DeployBadge: View {
    let env: PolicyEnvironment

    var body: some View {
        Text(env.displayName)
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(env == .live ? Color.red.opacity(0.12) : Color.blue.opacity(0.12))
            .foregroundStyle(env == .live ? Color.red : Color.blue)
            .clipShape(Capsule())
    }
}

// MARK: - 변경사항 뷰

struct ChangesView: View {
    @ObservedObject var vm: PolicyEditorViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("변경사항")
                        .font(.title2.bold())
                    if let meta = vm.currentVersionMeta {
                        Text("기준 버전: \(meta.versionLabel) · \(meta.modifiedBy)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider()

            let changes = vm.changedFields
            if changes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 36))
                        .foregroundStyle(Color(.tertiaryLabelColor))
                    Text("변경된 항목이 없습니다")
                        .font(.headline)
                    Text("필드 값을 수정하면 여기서 변경 전/후를 확인할 수 있어요.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 그룹별 헤더
                let grouped = Dictionary(grouping: changes, by: { $0.field.group })
                let groupOrder = vm.groups.filter { grouped[$0] != nil }

                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                        ForEach(groupOrder, id: \.self) { group in
                            SwiftUI.Section {
                                ForEach(grouped[group]!, id: \.field.id) { change in
                                    changeRow(change)
                                    Divider().padding(.leading, 16)
                                }
                            } header: {
                                Text(group)
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 7)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.controlBackgroundColor).opacity(0.9))
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color(.windowBackgroundColor))
    }

    private func changeRow(_ change: PolicyEditorViewModel.FieldChange) -> some View {
        let onlyFormulaChanged = change.before == change.after && change.beforeInput != change.afterInput

        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(change.field.name)
                    .font(.callout)
                Text(change.field.id)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(Color(.tertiaryLabelColor))
            }
            .frame(minWidth: 180, alignment: .leading)

            Spacer()

            if onlyFormulaChanged {
                HStack(spacing: 6) {
                    Text(change.beforeInput)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .strikethrough(true, color: .secondary)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(change.afterInput)
                        .font(.callout.bold())
                        .foregroundStyle(.purple)
                }
            } else {
                HStack(spacing: 6) {
                    Text(change.beforeInput.hasPrefix("=") ? change.beforeInput : formatted(change.before, isDouble: change.field.isDouble))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .strikethrough(true, color: .secondary)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(change.afterInput.hasPrefix("=") ? change.afterInput : formatted(change.after, isDouble: change.field.isDouble))
                        .font(.callout.bold())
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func formatted(_ value: Double, isDouble: Bool) -> String {
        if isDouble {
            if value.truncatingRemainder(dividingBy: 1) == 0 { return String(Int(value)) }
            return String(format: "%.3f", value)
                .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
        } else {
            return String(Int(value.rounded()))
        }
    }
}

// MARK: - 페이지 헤더 헬퍼

private func pageHeader(_ title: String, subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
        Text(title)
            .font(.title2.bold())
        Text(subtitle)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 20)
}
