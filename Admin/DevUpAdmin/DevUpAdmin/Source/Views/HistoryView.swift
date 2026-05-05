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
                    Text("버전을 선택해 불러오거나 테스트·라이브에 배포할 수 있습니다.")
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
                            Text("편집 중")
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
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                Spacer()
                Button("불러오기") {
                    Task { await vm.loadVersion(meta.version) }
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.blue)
                .font(.callout)
                .disabled(isCurrentlyLoaded)
            }
            .padding(18)

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
                .disabled(meta.isDeployedToLive || vm.isDeploying)
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
