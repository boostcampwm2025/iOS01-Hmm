import SwiftUI

struct ContentView: View {
    @AppStorage("adminUsername") private var username: String = ""
    @StateObject private var viewModel = PolicyEditorViewModel()
    @State private var showHistorySheet = false
    @State private var showSaveConfirm = false

    var body: some View {
        Group {
            if username.isEmpty {
                LoginView(username: $username)
            } else {
                mainContent
            }
        }
        .onAppear {
            if !username.isEmpty {
                Task { await viewModel.loadLatest() }
            }
        }
        .onChange(of: username) { _, new in
            if !new.isEmpty {
                Task { await viewModel.loadLatest() }
            }
        }
        .alert("오류", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.clearError() } }
        )) {
            Button("확인") { viewModel.clearError() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $showHistorySheet) {
            HistoryView(viewModel: viewModel)
        }
    }

    // MARK: - 메인 레이아웃

    private var mainContent: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            sidebarView
        } detail: {
            detailView
        }
        .toolbar {
            toolbarContent
        }
        .navigationTitle(viewModel.environment.displayName + " 정책 편집기")
    }

    // MARK: - 사이드바

    private var sidebarView: some View {
        List(viewModel.categories, id: \.self, selection: $viewModel.selectedCategory) { category in
            Text(category)
                .tag(category)
        }
        .listStyle(.sidebar)
        .navigationSplitViewColumnWidth(min: 160, ideal: 200, max: 260)
        .navigationTitle("카테고리")
    }

    // MARK: - 상세 영역

    @ViewBuilder
    private var detailView: some View {
        if viewModel.isLoading {
            ProgressView("불러오는 중...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let category = viewModel.selectedCategory {
            PolicyTableView(
                category: category,
                fields: viewModel.fieldsForSelectedCategory,
                onUpdate: { id, raw in viewModel.updateField(id: id, rawInput: raw) }
            )
        } else {
            VStack(spacing: 12) {
                Image(systemName: "sidebar.left")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("왼쪽에서 카테고리를 선택하세요.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - 툴바

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigation) {
            Picker("환경", selection: $viewModel.environment) {
                ForEach(PolicyEnvironment.allCases) { env in
                    Text(env.displayName).tag(env)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 160)
        }

        ToolbarItemGroup(placement: .primaryAction) {
            if let meta = viewModel.currentVersionMeta {
                Text("현재: \(meta.versionLabel) · \(meta.modifiedBy)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button {
                showHistorySheet = true
            } label: {
                Label("버전 이력", systemImage: "clock.arrow.circlepath")
            }

            Button {
                showSaveConfirm = true
            } label: {
                if viewModel.isSaving {
                    ProgressView()
                        .scaleEffect(0.7)
                } else {
                    Label(
                        viewModel.hasUnsavedChanges ? "저장 *" : "저장",
                        systemImage: "icloud.and.arrow.up"
                    )
                }
            }
            .keyboardShortcut("s", modifiers: .command)
            .disabled(viewModel.isSaving)
            .confirmationDialog(
                "\(viewModel.environment.displayName) 환경에 저장하시겠습니까?",
                isPresented: $showSaveConfirm,
                titleVisibility: .visible
            ) {
                Button("저장", role: .destructive) {
                    Task { await viewModel.save(modifiedBy: username) }
                }
                Button("취소", role: .cancel) {}
            } message: {
                if viewModel.environment == .live {
                    Text("라이브 환경입니다. 실제 서비스에 영향을 줍니다.")
                }
            }
        }
    }
}

// MARK: - 정책 테이블

struct PolicyTableView: View {
    let category: String
    let fields: [PolicyField]
    let onUpdate: (String, String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack(spacing: 0) {
                Text("항목")
                    .bold()
                    .frame(width: 200, alignment: .leading)
                    .padding(.horizontal, 8)
                Divider().frame(height: 20)
                Text("값 / 수식 (= 로 시작)")
                    .bold()
                    .frame(minWidth: 200, alignment: .leading)
                    .padding(.horizontal, 8)
                Divider().frame(height: 20)
                Text("결과")
                    .bold()
                    .frame(width: 140, alignment: .leading)
                    .padding(.horizontal, 8)
            }
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(fields) { field in
                        PolicyFieldRow(field: field, onUpdate: onUpdate)
                        Divider().padding(.leading, 8)
                    }
                }
            }
        }
        .navigationTitle(category)
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
                .frame(width: 200, alignment: .leading)
                .padding(.horizontal, 8)

            Divider().frame(height: 24)

            TextField("숫자 또는 =수식", text: $localInput)
                .textFieldStyle(.plain)
                .frame(minWidth: 200, alignment: .leading)
                .padding(.horizontal, 8)
                .background(field.hasFormula ? Color.blue.opacity(0.06) : Color.clear)
                .onSubmit { onUpdate(field.id, localInput) }
                .onChange(of: localInput) { _, new in
                    if new.trimmingCharacters(in: .whitespaces).hasPrefix("=") {
                        onUpdate(field.id, new)
                    }
                }

            Divider().frame(height: 24)

            Group {
                if field.hasFormula {
                    Text("→ \(field.displayValue)")
                        .foregroundStyle(.secondary)
                } else {
                    Text(field.displayValue)
                        .foregroundStyle(.primary.opacity(0.6))
                }
            }
            .frame(width: 140, alignment: .leading)
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 6)
        .onChange(of: field.rawInput) { _, new in
            if new != localInput { localInput = new }
        }
    }
}
