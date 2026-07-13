import SwiftUI

// MARK: - 배포 현황 페이지

struct DeploymentStatusPageView: View {
    @ObservedObject var vm: PolicyEditorViewModel

    /// 환경별 전체 배포 기록: (버전, 배포자, 날짜) 내림차순
    private func allRecords(for env: PolicyEnvironment) -> [(version: Int, record: DeployRecord)] {
        vm.versionHistory
            .flatMap { meta -> [(version: Int, record: DeployRecord)] in
                let records = env == .test ? meta.testDeployments : meta.liveDeployments
                return records.map { (meta.version, $0) }
            }
            .sorted { $0.record.deployedAt > $1.record.deployedAt }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("배포 현황")
                        .font(.title2.bold())
                    Text("테스트·라이브 환경에 배포된 버전과 전체 배포 기록을 확인합니다.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if vm.isLoading {
                    ProgressView().scaleEffect(0.8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider()

            if vm.isLoading {
                Spacer()
                ProgressView("불러오는 중...")
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        EnvironmentPanelView(
                            env: .test,
                            deployedMeta: vm.versionHistory.first { $0.isDeployedToTest },
                            allRecords: allRecords(for: .test)
                        )
                        EnvironmentPanelView(
                            env: .live,
                            deployedMeta: vm.versionHistory.first { $0.isDeployedToLive },
                            allRecords: allRecords(for: .live)
                        )
                    }
                    .padding(24)
                }
            }
        }
        .background(Color(.windowBackgroundColor))
    }
}

// MARK: - 환경 패널

struct EnvironmentPanelView: View {
    let env: PolicyEnvironment
    let deployedMeta: PolicyVersionMeta?
    let allRecords: [(version: Int, record: DeployRecord)]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // 헤더
            HStack(spacing: 10) {
                DeployBadge(env: env)
                Text(env == .test ? "테스트 환경" : "라이브 환경")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)

            Divider().padding(.horizontal, 18)

            // 현재 배포 버전
            if let meta = deployedMeta {
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(env == .live ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                            .frame(width: 44, height: 44)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(env == .live ? .red : .blue)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("현재 배포 버전")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(meta.versionLabel)
                            .font(.title3.bold())
                        if let latest = (env == .test ? meta.testDeployments : meta.liveDeployments)
                            .sorted(by: { $0.deployedAt > $1.deployedAt }).first {
                            HStack(spacing: 6) {
                                Label(latest.deployedBy, systemImage: "person.fill")
                                Label(latest.deployedAtFormatted, systemImage: "clock")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "minus.circle")
                        .font(.title2)
                        .foregroundStyle(Color(.tertiaryLabelColor))
                    Text("배포된 버전 없음")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }

            // 전체 배포 기록
            if !allRecords.isEmpty {
                Divider().padding(.horizontal, 18)

                VStack(alignment: .leading, spacing: 0) {
                    Text("전체 배포 기록")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 18)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

                    ForEach(Array(allRecords.enumerated()), id: \.element.record.id) { index, item in
                        if index > 0 { Divider().padding(.leading, 18) }
                        HStack(spacing: 10) {
                            Text(item.record.deployedAtFormatted)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 110, alignment: .leading)
                            Text("v\(item.version)")
                                .font(.caption.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(.controlBackgroundColor))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            Label(item.record.deployedBy, systemImage: "person.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(
                    deployedMeta != nil
                        ? (env == .live ? Color.red.opacity(0.25) : Color.blue.opacity(0.25))
                        : Color.clear,
                    lineWidth: 1.5
                )
        )
    }
}
