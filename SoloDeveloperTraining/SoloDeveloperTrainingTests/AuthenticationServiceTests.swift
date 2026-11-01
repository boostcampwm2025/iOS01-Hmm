//
//  AuthenticationServiceTests.swift
//  SoloDeveloperTrainingTests
//

import Testing
@testable import SoloDeveloperTraining

@MainActor
struct AuthenticationServiceTests {

    @Test("인증 성공 시 세션을 보관한다")
    func authenticateStoresState() async {
        let store = AuthenticationService(
            authenticationClient: AuthenticationClientStub(result: .success(.init(userID: "user-id")))
        )

        await store.authenticate()

        #expect(store.status == .authenticated(.init(userID: "user-id")))
    }

    @Test("인증 실패 시 재시도 가능한 오류 상태를 보관한다")
    func authenticateStoresFailure() async {
        let store = AuthenticationService(
            authenticationClient: AuthenticationClientStub(result: .failure(.networkUnavailable))
        )

        await store.authenticate()

        #expect(store.status == .failed(.networkUnavailable))
    }
}

@MainActor
private final class AuthenticationClientStub: AuthenticationClient {
    private let result: Result<AuthenticationState, AuthenticationError>

    init(result: Result<AuthenticationState, AuthenticationError>) {
        self.result = result
    }

    func ensureAuthenticated() async throws -> AuthenticationState {
        try result.get()
    }
}
