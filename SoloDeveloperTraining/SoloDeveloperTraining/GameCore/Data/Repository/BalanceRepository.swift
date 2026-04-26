//
//  BalanceRepository.swift
//  SoloDeveloperTraining
//

import Foundation

enum PolicyTab: String, CaseIterable {
    case edit = "Edit"
    case test = "Test"
    case live = "Live"
    case version = "Version"

    var index: Int {
        Self.allCases.firstIndex(of: self)!
    }

    var firestoreCollectionName: String {
        return "\(index + 1)_\(rawValue)"
    }
}

protocol BalanceRepository {
    /// 특정 탭의 특정 버전 정책 데이터를 가져옵니다.
    func fetchPolicy(tab: PolicyTab, version: String) async throws -> PolicyDTO

    /// 정책 데이터를 특정 탭에 해당 버전으로 업로드합니다.
    func uploadPolicy(tab: PolicyTab, data: PolicyDTO) async throws

    /// 특정 탭에 저장된 모든 버전 목록(문서 ID들)을 가져옵니다.
    func fetchVersionList(tab: PolicyTab) async throws -> [String]

    /// 특정 탭의 활성화된(현재 앱이 사용하는) 버전을 가져옵니다.
    func fetchActiveVersion(for tab: PolicyTab) async throws -> String?

    /// 특정 탭의 활성화된 버전을 설정합니다.
    func setActiveVersion(for tab: PolicyTab, version: String) async throws
}
