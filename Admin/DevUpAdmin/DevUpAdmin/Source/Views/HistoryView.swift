import SwiftUI

// MARK: - 버전 이력 페이지

struct VersionHistoryPageView: View {
    @ObservedObject var vm: PolicyEditorViewModel
    let username: String
    @State private var showSaveConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("버전 이력")
                        .font(.title2.bold())
                    Text("버전을 불러오면 해당 버전 기준으로 새 버전을 작성할 수 있습니다. 저장된 버전만 배포 가능합니다.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    showSaveConfirm = true
                } label: {
                    Label("새 버전 저장", systemImage: "plus.circle.fill")
                        .font(.callout.bold())
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isSaving || vm.hasValidationErrors)
                .confirmationDialog(
                    "현재 편집 내용을 새 버전으로 저장합니다.",
                    isPresented: $showSaveConfirm,
                    titleVisibility: .visible
                ) {
                    Button("저장") { Task { await vm.save(modifiedBy: username) } }
                    Button("취소", role: .cancel) {}
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider()

            if vm.isLoading {
                Spacer()
                ProgressView("불러오는 중...")
                Spacer()
            } else if vm.versionHistory.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.versionHistory) { meta in
                            VersionCardView(meta: meta, vm: vm, username: username)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .background(Color(.windowBackgroundColor))
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(.controlBackgroundColor))
                    .frame(width: 72, height: 72)
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 28))
                    .foregroundStyle(Color(.tertiaryLabelColor))
            }
            VStack(spacing: 6) {
                Text("저장된 버전이 없습니다")
                    .font(.headline)
                Text("편집 내용을 저장하면 첫 번째 버전이 생성됩니다.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            Button {
                showSaveConfirm = true
            } label: {
                Label("지금 저장하기", systemImage: "icloud.and.arrow.up")
                    .font(.callout.bold())
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isSaving)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - 버전 카드

struct VersionCardView: View {
    let meta: PolicyVersionMeta
    @ObservedObject var vm: PolicyEditorViewModel
    let username: String
    @State private var showDeployTestConfirm = false
    @State private var showDeployLiveConfirm = false

    var isCurrentlyLoaded: Bool {
        vm.currentVersionMeta?.version == meta.version
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // 상단: 버전 정보
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(meta.versionLabel)
                            .font(.headline)
                        if meta.isDeployedToTest { DeployBadge(env: .test) }
                        if meta.isDeployedToLive { DeployBadge(env: .live) }
                        if isCurrentlyLoaded {
                            Text("새 버전 작성 기준")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.12))
                                .foregroundStyle(Color.green)
                                .clipShape(Capsule())
                        }
                    }
                            HStack(spacing: 10) {
                        Label(meta.modifiedBy, systemImage: "person.fill")
                        Label(meta.modifiedAtFormatted, systemImage: "clock")
                        if let base = meta.baseVersion {
                            Label("v\(base) 기반", systemImage: "arrow.turn.up.right")
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                Spacer()
                Button(isCurrentlyLoaded ? "작성 기준" : "기준으로 설정") {
                    Task { await vm.loadVersion(meta.version) }
                }
                .buttonStyle(.borderless)
                .foregroundStyle(isCurrentlyLoaded ? Color.secondary : Color.blue)
                .font(.callout)
                .disabled(isCurrentlyLoaded)
            }
            .padding(18)

            // 변경 이력 영역
            if !meta.fieldChanges.isEmpty {
                Divider().padding(.horizontal, 18)
                FieldChangesSection(changes: meta.fieldChanges)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
            }

            // 배포 기록 영역
            if !meta.testDeployments.isEmpty || !meta.liveDeployments.isEmpty {
                Divider().padding(.horizontal, 18)

                VStack(alignment: .leading, spacing: 6) {
                    Text("배포 기록")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)

                    // test + live 합쳐서 최신순 정렬
                    let allRecords: [(env: PolicyEnvironment, record: DeployRecord)] =
                        meta.testDeployments.map { (.test, $0) } +
                        meta.liveDeployments.map { (.live, $0) }
                    let sorted = allRecords.sorted { $0.record.deployedAt > $1.record.deployedAt }

                    ForEach(sorted, id: \.record.id) { item in
                        deployRecord(env: item.env, record: item.record)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
            }

            Divider().padding(.horizontal, 18)

            // 배포 버튼
            HStack(spacing: 10) {
                Button {
                    showDeployTestConfirm = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: meta.isDeployedToTest ? "checkmark.circle.fill" : "arrow.up.circle")
                        Text(meta.isDeployedToTest ? "테스트 배포 중" : "테스트 배포")
                            .font(.callout)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2)
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                .disabled(meta.isDeployedToTest || vm.isDeploying)
                .confirmationDialog(
                    "\(meta.versionLabel)을 테스트 환경에 배포합니다.",
                    isPresented: $showDeployTestConfirm,
                    titleVisibility: .visible
                ) {
                    Button("배포") {
                        Task { await vm.deploy(version: meta.version, to: .test, deployedBy: username) }
                    }
                    Button("취소", role: .cancel) {}
                }

                Button {
                    showDeployLiveConfirm = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: meta.isDeployedToLive ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                        Text(meta.isDeployedToLive ? "라이브 배포 중" : "라이브 배포")
                            .font(.callout)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .disabled(meta.isDeployedToLive || vm.isDeploying || meta.testDeployments.isEmpty)
                .confirmationDialog(
                    "\(meta.versionLabel)을 라이브 환경에 배포합니다.",
                    isPresented: $showDeployLiveConfirm,
                    titleVisibility: .visible
                ) {
                    Button("배포", role: .destructive) {
                        Task { await vm.deploy(version: meta.version, to: .live, deployedBy: username) }
                    }
                    Button("취소", role: .cancel) {}
                } message: {
                    Text("실제 서비스에 즉시 반영됩니다.")
                }

                if meta.testDeployments.isEmpty && !meta.isDeployedToLive {
                    Text("테스트 배포 후 라이브 배포 가능")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
        }
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(isCurrentlyLoaded ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
    }

    private func deployRecord(env: PolicyEnvironment, record: DeployRecord) -> some View {
        HStack(spacing: 6) {
            DeployBadge(env: env)
            Label(record.deployedBy, systemImage: "person.fill")
            Label(record.deployedAtFormatted, systemImage: "clock")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}

// MARK: - 필드 변경 이력 섹션

struct FieldChangesSection: View {
    let changes: [FieldChangeRecord]
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color(.tertiaryLabelColor))
                    Text("변경된 항목 \(changes.count)건")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(changes) { change in
                        let onlyFormulaChanged = change.before == change.after && change.beforeInput != change.afterInput

                        HStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 1) {
                                HStack(spacing: 4) {
                                    Text(change.fieldName)
                                        .font(.caption)
                                    if onlyFormulaChanged {
                                        Text("수식")
                                            .font(.system(size: 8, weight: .bold))
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 1)
                                            .background(Color.purple.opacity(0.12))
                                            .foregroundStyle(Color.purple)
                                            .clipShape(Capsule())
                                    }
                                }
                                Text(change.fieldId)
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundStyle(Color(.tertiaryLabelColor))
                            }
                            .frame(minWidth: 140, alignment: .leading)

                            Spacer()

                            if onlyFormulaChanged {
                                // 값은 같고 수식만 바뀐 경우
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(change.beforeInput)
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                        .strikethrough(true, color: .secondary)
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.secondary)
                                    Text(change.afterInput)
                                        .font(.system(size: 10, design: .monospaced))
                                        .foregroundStyle(Color.purple)
                                }
                            } else {
                                // 값이 바뀐 경우 (수식 변경 포함)
                                HStack(spacing: 5) {
                                    Text(change.beforeInput.hasPrefix("=") ? change.beforeInput : formatValue(change.before))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .strikethrough(true, color: .secondary)
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.secondary)
                                    Text(change.afterInput.hasPrefix("=") ? change.afterInput : formatValue(change.after))
                                        .font(.caption.bold())
                                        .foregroundStyle(.orange)
                                }
                            }
                        }
                        .padding(.vertical, 3)
                        .padding(.horizontal, 8)
                        .background(Color(.windowBackgroundColor).opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }

    private func formatValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 { return String(Int(value)) }
        return String(format: "%.3f", value)
            .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
    }
}
