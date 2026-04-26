//
//  BalanceRepository.swift
//  SoloDeveloperTraining
//

import Foundation

enum Tab: String {
    case edit = "Edit"
    case test = "Test"
    case prod = "Prod"
    case version = "Version"
}

protocol BalanceRepository {
    /// 특정 탭의 특정 버전 정책 데이터를 가져옵니다.
    func fetchPolicy(tab: Tab, version: String) async throws -> PolicyDTO

    /// 정책 데이터를 특정 탭에 해당 버전으로 업로드합니다.
    func uploadPolicy(tab: Tab, data: PolicyDTO) async throws

    /// 특정 탭에 저장된 모든 버전 목록(문서 ID들)을 가져옵니다.
    func fetchVersionList(tab: Tab) async throws -> [String]

    /// 특정 탭의 활성화된(현재 앱이 사용하는) 버전을 가져옵니다.
    func fetchActiveVersion(for tab: Tab) async throws -> String?

    /// 특정 탭의 활성화된 버전을 설정합니다.
    func setActiveVersion(for tab: Tab, version: String) async throws
}
