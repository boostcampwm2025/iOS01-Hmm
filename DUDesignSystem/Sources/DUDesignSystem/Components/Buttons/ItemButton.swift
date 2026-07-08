//
//  ItemButton.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/4/26.
//

import SwiftUI

public struct ItemButton: View {
    public enum ItemButtonState {
        case `default`
        case locked
        case disabled
    }

    public enum ItemButtonType {
        case singleLine(text: String, icon: DUIconName)
        case twoLine(firstText: String, firstIcon: DUIconName, secondText: String, secondIcon: DUIconName)
    }

    public var type: ItemButtonType
    public var state: ItemButtonState
    public var action: () -> Void
    public var onLongPress: (() -> Bool)?

    @GestureState private var isPressed: Bool = false
    @State private var isLongPressing: Bool = false
    @State private var repeatTimer: Timer?

    private enum LongPressConstant {
        static let minimumDuration: Double = 0.5
        static let repeatInterval: TimeInterval = 0.1
    }

    public init(type: ItemButtonType, state: ItemButtonState, action: @escaping () -> Void, onLongPress: (() -> Bool)? = nil) {
        self.type = type
        self.state = state
        self.action = action
        self.onLongPress = onLongPress
    }

    private var backgroundColor: Color {
        switch state {
        case .default: return Color.orange500
        case .locked, .disabled: return Color.beige400
        }
    }

    private var isInteractive: Bool {
        state != .disabled
    }

    @ViewBuilder
    private var label: some View {
        switch type {
        case .singleLine(let text, let icon):
            ItemLabel(text: text, icon: icon, iconSize: .size16, font: .caption, color: .white300)
        case .twoLine(let firstText, let firstIcon, let secondText, let secondIcon):
            VStack(spacing: TokenSpacing.xs) {
                ItemLabel(text: firstText, icon: firstIcon, iconSize: .size16, font: .caption, color: .white300)
                ItemLabel(text: secondText, icon: secondIcon, iconSize: .size16, font: .caption, color: .white300)
            }
        }
    }

    public var body: some View {
        ZStack {
            label
                .opacity(state == .locked ? TokenOpacity.opacity40 : TokenOpacity.opacity100)
            if state == .locked {
                DUIcon(.lock, size: .size20)
            }
        }
        .frame(width: 84, height: 42)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        .tokenShadow(isPressed ? .none : (state == .default ? .default : .dim))
        .offset(
            x: isPressed ? TokenShadow.default.x : 0,
            y: isPressed ? TokenShadow.default.y : 0
        )
        .gesture(
            isInteractive ? DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in state = true }
                .onEnded { _ in
                    if isLongPressing {
                        isLongPressing = false
                        stopRepeating()
                    } else {
                        action()
                    }
                } : nil
        )
        .simultaneousGesture(
            LongPressGesture(minimumDuration: LongPressConstant.minimumDuration)
                .onEnded { _ in
                    guard onLongPress != nil && isInteractive else { return }
                    isLongPressing = true
                    startRepeating()
                }
        )
        .animation(nil, value: isPressed)
        .onDisappear { stopRepeating() }
    }

    private func startRepeating() {
        guard let onLongPress, repeatTimer == nil else { return }
        _ = onLongPress()
        let timer = Timer.scheduledTimer(withTimeInterval: LongPressConstant.repeatInterval, repeats: true) { timer in
            if !onLongPress() {
                timer.invalidate()
                repeatTimer = nil
            }
        }
        RunLoop.current.add(timer, forMode: .common)
        repeatTimer = timer
    }

    private func stopRepeating() {
        repeatTimer?.invalidate()
        repeatTimer = nil
    }
}

#Preview {
    VStack(spacing: 20) {
        ItemButton(type: .singleLine(text: "20,000", icon: .coinBag), state: .default) { }
        ItemButton(type: .singleLine(text: "20,000", icon: .coinBag), state: .locked) { }
        ItemButton(type: .singleLine(text: "20,000", icon: .coinBag), state: .disabled) { }
        ItemButton(type: .twoLine(firstText: "20,000", firstIcon: .coinBag, secondText: "구매", secondIcon: .coinBag), state: .default) { }
        ItemButton(type: .twoLine(firstText: "20,000", firstIcon: .coinBag, secondText: "구매", secondIcon: .coinBag), state: .locked) { }
        ItemButton(type: .twoLine(firstText: "20,000", firstIcon: .coinBag, secondText: "구매", secondIcon: .coinBag), state: .disabled) { }
    }
    .padding(32)
    .background(Color.beige200)
}
