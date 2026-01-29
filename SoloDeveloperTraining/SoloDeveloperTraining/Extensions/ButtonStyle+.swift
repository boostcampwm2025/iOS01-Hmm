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
                if newValue {
                    SoundService.shared.trigger(.buttonTap)
                }
            }
    }
}

struct SoundTapButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                if newValue {
                    SoundService.shared.trigger(.buttonTap)
                }
            }
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static func pressable(isPressed: Binding<Bool>) -> PressableButtonStyle {
        PressableButtonStyle(isPressed: isPressed)
    }
}

extension ButtonStyle where Self == SoundTapButtonStyle {
    static var soundTap: SoundTapButtonStyle { SoundTapButtonStyle() }
}
