//
//  AdminView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/26/26.
//

import SwiftUI

struct AdminView: View {
    private let repository: BalanceRepository = DevBalanceRepository()

    @State private var versionLists: [PolicyTab: [String]] = [:]
    @State private var activeVersions: [PolicyTab: String] = [:]
    @State private var isLoading = false
    @State private var statusMessage: String?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        uploadDefaultPolicy()
                    } label: {
                        Label("현재 상수를 Edit/1.0.0으로 업로드", systemImage: "icloud.and.arrow.up")
                    }
                } header: {
                    Text("데이터 초기화")
                } footer: {
                    if let message = statusMessage {
                        Text(message).foregroundColor(.blue).font(.caption)
                    }
                }

                ForEach([PolicyTab.edit, .test, .live], id: \.self) { tab in
                    Section {
                        if let versions = versionLists[tab], !versions.isEmpty {
                            ForEach(versions, id: \.self) { version in
                                versionRow(tab: tab, version: version)
                            }
                        } else {
                            Text("저장된 버전이 없습니다.")
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    } header: {
                        HStack {
                            Text("\(tab.rawValue) 탭 히스토리")
                            Spacer()
                            if let active = activeVersions[tab] {
                                Text("Active: \(active)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("밸런스 업데이트")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        refreshAll()
                    } label: {
                        if isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .onAppear {
                refreshAll()
            }
        }
    }
}

private extension AdminView {
    func versionRow(tab: PolicyTab, version: String) -> some View {
        let isActive = activeVersions[tab] == version

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(version)
                    .font(.system(.body, design: .monospaced))
                    .bold()

                if isActive {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }

                Spacer()

                if !isActive {
                    Button("활성화") {
                        updateActiveVersion(tab: tab, version: version)
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                }
            }

            HStack(spacing: 12) {
                if tab == .edit {
                    deployButton(title: "Test로 배포", icon: "paperplane", color: .orange) {
                        copyVersion(from: .edit, to: .test, version: version)
                    }
                } else if tab == .test {
                    deployButton(title: "Live로 배포", icon: "bolt.fill", color: .red) {
                        copyVersion(from: .test, to: .live, version: version)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    func deployButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private extension AdminView {
    func uploadDefaultPolicy() {
        statusMessage = "업로드 중..."
        Task {
            do {
                let data = PolicyDTO.defaultValues
                try await repository.uploadPolicy(tab: .edit, data: data)
                // 업로드 성공 시 자동으로 해당 버전을 Active로 설정
                try await repository.setActiveVersion(tab: .edit, version: data.version)
                statusMessage = "✅ 업로드 및 활성화 성공 (Edit/\(data.version))"
                refreshAll()
            } catch {
                statusMessage = "❌ 실패: \(error.localizedDescription)"
            }
        }
    }

    func copyVersion(from sourceTab: PolicyTab, to targetTab: PolicyTab, version: String) {
        statusMessage = "\(sourceTab.rawValue) -> \(targetTab.rawValue) 배포 중..."
        Task {
            do {
                let data = try await repository.fetchPolicy(tab: sourceTab, version: version)
                try await repository.uploadPolicy(tab: targetTab, data: data)
                // 배포 성공 시 자동으로 타겟 탭의 Active 버전 업데이트
                try await repository
                    .setActiveVersion(tab: targetTab, version: version)
                statusMessage = "✅ \(targetTab.rawValue) 배포 및 활성화 완료 (\(version))"
                refreshAll()
            } catch {
                statusMessage = "❌ 배포 실패: \(error.localizedDescription)"
            }
        }
    }

    func updateActiveVersion(tab: PolicyTab, version: String) {
        statusMessage = "\(tab.rawValue) 활성 버전 변경 중..."
        Task {
            do {
                try await repository
                    .setActiveVersion(tab: tab, version: version)
                statusMessage = "✅ \(tab.rawValue) 활성 버전 변경 완료: \(version)"
                refreshAll()
            } catch {
                statusMessage = "❌ 변경 실패: \(error.localizedDescription)"
            }
        }
    }

    func refreshAll() {
        isLoading = true
        Task {
            var updatedLists: [PolicyTab: [String]] = [:]
            var updatedActives: [PolicyTab: String] = [:]

            for tab in [PolicyTab.edit, .test, .live] {
                // 버전 목록 가져오기
                if let versions = try? await repository.fetchVersionList(tab: tab) {
                    updatedLists[tab] = versions
                }
                // 활성 버전 가져오기
                if let active = try? await repository.fetchActiveVersion(
                    tab: tab
                ) {
                    updatedActives[tab] = active
                }
            }

            await MainActor.run {
                self.versionLists = updatedLists
                self.activeVersions = updatedActives
                self.isLoading = false
            }
        }
    }
}

#Preview {
    AdminView()
}
