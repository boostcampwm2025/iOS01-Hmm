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
    private let localStorage: KeyValueLocalStorage = UserDefaultsStorage()

    var isEnabled: Bool {
        didSet {
            localStorage.set(isEnabled, forKey: Constant.hapticEnabledKey)
        }
    }

    private init() {
        // 저장된 키가 없을 경우 기본값 등록
        localStorage.register(defaults: [Constant.hapticEnabledKey: true])

        self.isEnabled = localStorage.bool(key: Constant.hapticEnabledKey)
    }

    func toggle() {
        isEnabled.toggle()
        // 활성화 되었음을 알리기 위해 햅틱 트리거
        if isEnabled {
            HapticType.medium.trigger()
        }
    }

    func trigger(_ type: HapticType) {
        guard isEnabled else { return }
        type.trigger()
    }
}
