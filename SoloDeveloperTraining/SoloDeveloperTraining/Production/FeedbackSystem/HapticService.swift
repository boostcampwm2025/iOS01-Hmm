//
//  HapticService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI

@Observable
final class HapticService {
    static let shared = HapticService()

    var isEnabled: Bool {
        didSet { AppPreferences.shared.isHapticEnabled = isEnabled }
    }

    private init() {
        isEnabled = AppPreferences.shared.isHapticEnabled
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
