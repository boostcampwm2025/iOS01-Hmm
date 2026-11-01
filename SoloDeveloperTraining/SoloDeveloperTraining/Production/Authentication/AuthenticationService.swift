//
//  AuthenticationService.swift
//  SoloDeveloperTraining
//

final class AuthenticationService {

    enum Status: Equatable {
        case idle
        case authenticating
        case authenticated(AuthenticationState)
        case failed(AuthenticationError)
    }

    private let authenticationClient: any AuthenticationClient

    private(set) var status: Status = .idle

    private var isFailed: Bool {
        if case .failed = status {
            return true
        }
        return false
    }

    init(authenticationClient: any AuthenticationClient) {
        self.authenticationClient = authenticationClient
    }

    func authenticate() async {
        switch status {
        case .authenticating, .authenticated:
            return
        case .idle, .failed:
            break
        }

        status = .authenticating
        do {
            status = .authenticated(try await authenticationClient.ensureAuthenticated())
        } catch let error as AuthenticationError {
            status = .failed(error)
        } catch {
            status = .failed(.unknown)
        }
    }

    func retry() async {
        guard isFailed else {
            return
        }

        status = .idle
        await authenticate()
    }

}
