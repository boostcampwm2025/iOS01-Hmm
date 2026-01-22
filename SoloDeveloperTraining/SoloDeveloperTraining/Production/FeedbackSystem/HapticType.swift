//
//  HapticType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import UIKit

enum HapticType {
    // Impact
    /// 가볍고 작게 1번
    case light
    /// 중간 1번
    case medium
    /// 둔탁하게 1번
    case heavy
    // Notification
    /// 빠르게 2번, 점점 세기 강해짐
    case success
    /// 빠르게 4번
    case warning
    /// 빠르게 2번, 점점 세기 약해짐
    case error

    // 모든 타입을 실제 피드백 발생으로 매핑
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
