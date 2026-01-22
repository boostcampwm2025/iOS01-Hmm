//
//  HapticService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI

private enum Constant {
    static let hapticEnabledKey: String = "isHapticEnabled"
}

@Observable
final class HapticService {
    static let shared = HapticService()

    var isEnabled: Bool {
        didSet {
            UserDefaults.standard
                .set(isEnabled, forKey: Constant.hapticEnabledKey)
        }
    }

    private init() {
        // 저장된 키가 없을 경우 기본값 등록
        UserDefaults.standard
            .register(defaults: [Constant.hapticEnabledKey: true])

        self.isEnabled = UserDefaults.standard
            .bool(forKey: Constant.hapticEnabledKey)
    }

    func toggle() {
        isEnabled.toggle()
        // 설정이 변경되었음을 알리기 위해 햅틱 트리거
        if isEnabled {
            HapticType.medium.trigger()
        }
    }

    func trigger(_ type: HapticType) {
        guard isEnabled else { return }
        type.trigger()
    }
}
