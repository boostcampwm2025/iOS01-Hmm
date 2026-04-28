//
//  AdminView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/26/26.
//

import SwiftUI

struct AdminView: View {
    private let repository = DefaultAdminBalanceRepository()

    @State private var activeVersions: [PolicyTab: String] = [:]
    @State private var versionLists: [PolicyTab: [String]] = [:]
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            List {
                Section("데이터 초기화") {
                    Button(action: handleInitializeLatest) {
                        HStack {
                            Image(systemName: "icloud.and.arrow.up")
                            Text("현재 상수를 Edit/Latest로 업로드")
                        }
                        .foregroundColor(.blue)
                    }
                    .disabled(isLoading)
                }

                Section("Edit 히스토리") {
                    HStack {
                        Text("현재 Latest 버전 필드:")
                        Spacer()
                        if isLoading {
                            ProgressView()
                        } else {
                            Text(activeVersions[.edit] ?? "데이터 없음")
                                .bold()
                                .foregroundColor(.blue)
                        }
                    }

                    Button(action: deployToTest) {
                        HStack {
                            Spacer()
                            Text("\(activeVersions[.edit] ?? "Latest") 버전을 Test로 배포")
                                .bold()
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(activeVersions[.edit] == nil || isLoading)
                }

                ForEach([PolicyTab.test, .live], id: \.self) { tab in
                    Section("\(tab.rawValue) 히스토리") {
                        if let list = versionLists[tab]?.filter({ $0 != "Latest" }), !list.isEmpty {
                            ForEach(list, id: \.self) { version in
                                historyRow(tab: tab, version: version)
                            }
                        } else {
                            Text("기록된 히스토리가 없습니다.").font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("밸런싱 관리")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: refresh) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isLoading)
                }
            }
            .task { refresh() }
        }
    }
}

private extension AdminView {
    func historyRow(tab: PolicyTab, version: String) -> some View {
        HStack {
            Text(version).font(.system(.body, design: .monospaced))
            Spacer()
            if activeVersions[tab] == version {
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
            } else {
                Button("활성화") {
                    Task {
                        try? await repository.setActiveVersion(tab: tab, version: version)
                        refresh()
                    }
                }.font(.caption).buttonStyle(.bordered)
            }

            if tab == .test {
                Button("Live 배포") {
                    deployToLive(version: version)
                }
                .font(.caption).buttonStyle(.bordered).tint(.red)
            }
        }
    }
}

private extension AdminView {
    // 초기 데이터 입력
    func handleInitializeLatest() {
        Task {
            do {
                let defaultData = PolicyDTO.defaultValues
                try await repository.uploadPolicy(tab: .edit, data: defaultData)
                refresh()
            } catch {
                print("❌ 초기화 실패: \(error)")
                await MainActor.run { isLoading = false }
            }
        }
    }

    func refresh() {
        isLoading = true
        Task {
            var actives: [PolicyTab: String] = [:]
            var lists: [PolicyTab: [String]] = [:]

            await withTaskGroup(of: (PolicyTab, String?, [String]?).self) { group in
                for tab in [PolicyTab.edit, .test, .live] {
                    group.addTask {
                        async let active = try? repository.fetchActiveVersion(tab: tab)
                        async let list = try? repository.fetchVersionList(tab: tab)
                        return await (tab, active, list)
                    }
                }

                for await (tab, active, list) in group {
                    if let active {
                        actives[tab] = active
                    }
                    lists[tab] = list ?? []
                }
            }

            await MainActor.run {
                self.activeVersions = actives
                self.versionLists = lists
                self.isLoading = false
            }
        }
    }

    func deployToTest() {
        guard let currentVer = activeVersions[.edit] else { return }
        Task {
            do {
                let data = try await repository.fetchPolicy(tab: .edit, version: currentVer)
                try await repository.uploadPolicy(tab: .test, data: data)
                try await repository.setActiveVersion(tab: .test, version: currentVer)
                refresh()
            } catch {
                await MainActor.run { isLoading = false }
            }
        }
    }

    func deployToLive(version: String) {
        Task {
            do {
                let data = try await repository.fetchPolicy(tab: .test, version: version)
                try await repository.uploadPolicy(tab: .live, data: data)
                try await repository.setActiveVersion(tab: .live, version: version)
                refresh()
            } catch {
                await MainActor.run { isLoading = false }
            }
        }
    }
}
