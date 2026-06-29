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
