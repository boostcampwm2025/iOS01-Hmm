//
//  SessionManager.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/1/26.
//

import Foundation

final class SessionManager {
    static let shared = SessionManager()

    private init() {}

    private(set) var sessionID: String = SessionManager.generateSessionID()
    private var sessionStartTime: Date = Date()
    private var backgroundedAt: Date?

    /// foreground 복귀 후 아직 로깅하지 않은 새 세션이 있으면 true
    private(set) var didStartNewSession: Bool = true

    private static let sessionTimeoutSeconds: TimeInterval = 60

    // MARK: - App Lifecycle

    func handleForeground() {
        if let backgroundedAt, Date().timeIntervalSince(backgroundedAt) > SessionManager.sessionTimeoutSeconds {
            sessionID = SessionManager.generateSessionID()
            sessionStartTime = Date()
            didStartNewSession = true
        }
        self.backgroundedAt = nil
    }

    func handleBackground() {
        backgroundedAt = Date()
    }

    /// 새 세션 로깅 완료 후 플래그 소비
    func consumeNewSession() {
        didStartNewSession = false
    }

    // MARK: - Session Duration

    var sessionDurationSec: Int {
        Int(Date().timeIntervalSince(sessionStartTime))
    }

    // MARK: - Private

    private static func generateSessionID() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return "sess_\(formatter.string(from: Date()))_\(UUID().uuidString.prefix(6))"
    }
}
