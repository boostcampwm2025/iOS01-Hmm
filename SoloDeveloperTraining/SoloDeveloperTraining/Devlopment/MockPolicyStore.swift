//
//  MockPolicyStore.swift
//  SoloDeveloperTraining
//

import Foundation

final class MockPolicyStore: PolicyStoreProtocol {
    var current: PolicyDTO = .defaultValues
    var shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    func initialize() async throws {
        if shouldFail { throw URLError(.notConnectedToInternet) }
    }
}
