//
//  FirebaseAuthenticationClient.swift
//  SoloDeveloperTraining
//

import Foundation
import FirebaseAuth

// 인증 상태 저장
struct AuthenticationState: Equatable, Sendable {
    let userID: String
}

// 인증 처리 오류
enum AuthenticationError: LocalizedError, Equatable {
    case anonymousSignInDisabled
    case networkUnavailable
    case tooManyRequests
    case unknown

    init(error: Error) {
        guard let code = AuthErrorCode(rawValue: (error as NSError).code) else {
            self = .unknown
            return
        }

        switch code {
        case .operationNotAllowed:
            self = .anonymousSignInDisabled
        case .networkError:
            self = .networkUnavailable
        case .tooManyRequests:
            self = .tooManyRequests
        default:
            self = .unknown
        }
    }

    var errorDescription: String? {
        switch self {
        case .anonymousSignInDisabled:
            "서비스 연결을 준비하지 못했어요. 잠시 후 다시 시도해주세요."
        case .networkUnavailable:
            "인터넷 연결을 확인한 뒤 다시 시도해주세요."
        case .tooManyRequests:
            "요청이 많아요. 잠시 후 다시 시도해주세요."
        case .unknown:
            "서비스 연결에 실패했어요. 잠시 후 다시 시도해주세요."
        }
    }
}

// 인증 객체 프로토콜
protocol AuthenticationClient: AnyObject {
    func ensureAuthenticated() async throws -> AuthenticationState
}

// FirebaseAuth 구현체
final class FirebaseAuthenticationClient: AuthenticationClient {

    func ensureAuthenticated() async throws -> AuthenticationState {
        if let userID = Auth.auth().currentUser?.uid {
            return AuthenticationState(userID: userID)
        }

        do {
            // 익명 인증 과정 수행
            let result = try await Auth.auth().signInAnonymously()
            return AuthenticationState(userID: result.user.uid)
        } catch {
            throw AuthenticationError(error: error)
        }
    }
}
