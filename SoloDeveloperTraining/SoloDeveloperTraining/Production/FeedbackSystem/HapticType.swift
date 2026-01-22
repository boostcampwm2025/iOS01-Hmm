//
//  HapticType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import UIKit

enum HapticType {
    /// Impact
    case light
    case medium
    case heavy
    /// Notification
    case success
    case warning
    case error

    /// 모든 타입을 실제 피드백 발생으로 매핑
    func trigger() {
        switch self {
        // MARK: - Impact
        case .light, .medium, .heavy:
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()

        // MARK: - Notification
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        }
    }

    /// Impact 스타일 매핑
    private var style: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        default: return .medium
        }
    }
}
