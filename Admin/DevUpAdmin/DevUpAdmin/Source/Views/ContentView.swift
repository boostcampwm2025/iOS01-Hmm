import SwiftUI

// MARK: - 사이드바 항목

enum SidebarItem: Hashable {
    case editor(String)
    case versionHistory
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
            // 현재 버전 상태 카드
            Section {
                versionCard
            }

            Section("밸런스 편집") {
                ForEach(vm.groups, id: \.self) { group in
                    Label(group, systemImage: iconFor(group))
                        .tag(SidebarItem.editor(group))
                }
            }

            Section("관리") {
                Label("버전 이력", systemImage: "clock.arrow.circlepath")
                    .tag(SidebarItem.versionHistory)
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
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(meta.versionLabel)
                            .font(.subheadline.bold())
                        Text(meta.modifiedBy)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        if meta.isDeployedToTest { DeployBadge(env: .test) }
                        if meta.isDeployedToLive { DeployBadge(env: .live) }
                    }
                }
            } else {
                Text("버전 없음")
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
                    Text(vm.hasUnsavedChanges ? "새 버전으로 저장 •" : "새 버전으로 저장")
                        .font(.caption.bold())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .disabled(vm.isSaving)
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
                    Text("현재 \(meta.versionLabel) 편집 중")
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

            ScrollView {
                VStack(spacing: 0) {
                    // 프로필 카드
                    VStack(spacing: 20) {
                        // 아바타
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.12))
                                .frame(width: 72, height: 72)
                            Text(String(username.prefix(1)).uppercased())
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.blue)
                        }

                        if isEditing {
                            VStack(spacing: 12) {
                                TextField("이름", text: $editingName)
                                    .textFieldStyle(.plain)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(.controlBackgroundColor))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
                                    .buttonStyle(.borderless)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        } else {
                            VStack(spacing: 8) {
                                Text(username)
                                    .font(.title3.bold())
                                Button("이름 수정") {
                                    editingName = username
                                    isEditing = true
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(28)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 2)
                    .padding(24)
                }
            }
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
                                ForEach(item.fields) { field in
                                    PolicyFieldRow(field: field) { id, raw in
                                        vm.updateField(id: id, rawInput: raw)
                                    }
                                    Divider().padding(.leading, 216)
                                }
                            } header: {
                                if !item.section.isEmpty {
                                    sectionHeader(item.section)
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

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption.bold())
            .foregroundStyle(.secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.controlBackgroundColor).opacity(0.8))
    }
}

// MARK: - 필드 행

private struct PolicyFieldRow: View {
    let field: PolicyField
    let onUpdate: (String, String) -> Void
    @State private var localInput: String

    init(field: PolicyField, onUpdate: @escaping (String, String) -> Void) {
        self.field = field
        self.onUpdate = onUpdate
        self._localInput = State(initialValue: field.rawInput)
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(field.name)
                .font(.callout)
                .frame(width: 208, alignment: .leading)
                .padding(.horizontal, 16)

            Divider().frame(height: 28)

            TextField("숫자 또는 =수식", text: $localInput)
                .textFieldStyle(.plain)
                .font(.callout)
                .frame(minWidth: 200, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(field.hasFormula ? Color.blue.opacity(0.05) : Color.clear)
                .onSubmit { onUpdate(field.id, localInput) }
                .onChange(of: localInput) { _, new in
                    if new.trimmingCharacters(in: .whitespaces).hasPrefix("=") {
                        onUpdate(field.id, new)
                    }
                }

            Divider().frame(height: 28)

            Group {
                if field.hasFormula {
                    Text("→ \(field.displayValue)")
                        .foregroundStyle(.blue.opacity(0.8))
                } else {
                    Text(field.displayValue)
                        .foregroundStyle(Color(.tertiaryLabelColor))
                }
            }
            .font(.callout)
            .frame(width: 140, alignment: .leading)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 4)
        .onChange(of: field.rawInput) { _, new in
            if new != localInput { localInput = new }
        }
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
