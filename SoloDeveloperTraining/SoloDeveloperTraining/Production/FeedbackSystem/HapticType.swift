//
//  HapticType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import UIKit

enum HapticType {
    /// 중간 세기 1번 - 설정 켤 때
    case medium
    /// 빠르게 2번, 점점 강해짐 - 성공/보상
    case success
    /// 빠르게 4번 - 레벨업
    case levelUp
    /// 빠르게 2번, 점점 약해짐 - 실패/오답/충돌
    case error

    func trigger() {
        switch self {
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .levelUp:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        }
    }
}
