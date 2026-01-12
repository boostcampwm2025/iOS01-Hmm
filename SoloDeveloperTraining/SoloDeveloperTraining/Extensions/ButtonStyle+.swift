//
//  ButtonStyle+.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/12/26.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static func pressable(isPressed: Binding<Bool>) -> PressableButtonStyle {
        PressableButtonStyle(isPressed: isPressed)
    }
}
