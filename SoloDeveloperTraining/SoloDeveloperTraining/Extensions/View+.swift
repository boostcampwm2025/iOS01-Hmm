//
//  View+.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI

extension View {
    func withTapSound() -> some View {
        buttonStyle(.soundTap)
    }

    func toast(isShowing: Binding<Bool>, message: String, duration: Double = 1.5) -> some View {
        self.modifier(Toast(isShowing: isShowing, message: message, duration: duration))
    }

    func darkToast(isShowing: Binding<Bool>, message: String, duration: Double = 2.0) -> some View {
        self.modifier(DarkToast(isShowing: isShowing, message: message, duration: duration))
    }

    func longPressRepeat(
        isLongPressing: Binding<Bool>,
        isDisabled: Bool,
        onLongPressRepeat: (() -> Bool)?
    ) -> some View {
        modifier(LongPressRepeatModifier(
            isLongPressing: isLongPressing,
            isDisabled: isDisabled,
            onLongPressRepeat: onLongPressRepeat
        ))
    }
}
