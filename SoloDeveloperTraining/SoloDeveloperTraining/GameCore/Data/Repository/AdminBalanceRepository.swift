//
//  AdminBalanceRepository.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/28/26.
//

import Foundation

protocol AdminBalanceRepository {
    /// 정책 데이터를 특정 탭에 해당 버전으로 업로드합니다.
    func uploadPolicy(tab: PolicyTab, data: PolicyDTO) async throws

    /// 특정 탭의 활성화된 버전을 설정합니다.
    func setActiveVersion(tab: PolicyTab, version: String) async throws
}
