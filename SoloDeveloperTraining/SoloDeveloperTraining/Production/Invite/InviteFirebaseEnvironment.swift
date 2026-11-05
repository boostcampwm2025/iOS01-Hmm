import FirebaseAuth
import FirebaseCore
import FirebaseFunctions
import Foundation

/// 로컬 초대 테스트의 인증이 기존 밸런스 정책 조회에 영향을 주지 않도록 별도 FirebaseApp을 사용합니다.
enum InviteFirebaseEnvironment {
    static var usesEmulators: Bool {
#if DEBUG && targetEnvironment(simulator)
        ProcessInfo.processInfo.arguments.contains("-useFirebaseEmulators")
#else
        false
#endif
    }

    private static let app: FirebaseApp = {
        guard let defaultApp = FirebaseApp.app() else {
            preconditionFailure("FirebaseApp.configure() must be called first")
        }
        guard usesEmulators else { return defaultApp }

        let name = "InviteLocal"
        FirebaseApp.configure(name: name, options: defaultApp.options)
        guard let localApp = FirebaseApp.app(name: name) else {
            preconditionFailure("Failed to configure invite Firebase app")
        }
        return localApp
    }()

    static let auth: Auth = {
        let auth = Auth.auth(app: app)
        if usesEmulators {
            auth.useEmulator(withHost: "127.0.0.1", port: 9099)
        }
        return auth
    }()

    static let functions: Functions = {
        // Callable이 사용할 인증 객체를 먼저 설정합니다.
        _ = auth
        let functions = Functions.functions(app: app, region: "asia-northeast3")
        if usesEmulators {
            functions.useEmulator(withHost: "127.0.0.1", port: 5001)
        }
        return functions
    }()
}
