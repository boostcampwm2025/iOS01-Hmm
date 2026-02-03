//
//  LongPressRepeatModifier.swift
//  SoloDeveloperTraining
//

import SwiftUI

private enum Constant {
    static let minimumDuration: Double = 1
    static let repeatInterval: TimeInterval = 0.2
}

struct LongPressRepeatModifier: ViewModifier {
    @Binding var isLongPressing: Bool
    @State private var repeatTimer: Timer?

    let isDisabled: Bool
    let onLongPressRepeat: (() -> Bool)?

    func body(content: Content) -> some View {
        content
            .onLongPressGesture(
                minimumDuration: Constant.minimumDuration,
                pressing: handlePressingChange,
                perform: startRepeating
            )
            .onDisappear {
                repeatTimer?.invalidate()
                repeatTimer = nil
            }
    }
}

private extension LongPressRepeatModifier {
    func handlePressingChange(_ pressing: Bool) {
        guard !isDisabled, onLongPressRepeat != nil else { return }
        if !pressing { stopRepeating() }
    }

    func startRepeating() {
        guard let onLongPressRepeat, repeatTimer == nil else { return }

        isLongPressing = true
        if onLongPressRepeat() { SoundService.shared.trigger(.buttonTap) }

        let timer = Timer.scheduledTimer(withTimeInterval: Constant.repeatInterval, repeats: true) { [onLongPressRepeat, isLongPressingBinding = $isLongPressing] timer in
            if onLongPressRepeat() {
                SoundService.shared.trigger(.buttonTap)
            } else {
                timer.invalidate()
                repeatTimer = nil
                isLongPressingBinding.wrappedValue = false
            }
        }
        RunLoop.current.add(timer, forMode: .common)
        repeatTimer = timer
    }

    func stopRepeating() {
        repeatTimer?.invalidate()
        repeatTimer = nil
        isLongPressing = false
    }
}
