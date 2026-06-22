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

    @GestureState private var isPressed: Bool = false

    public init(type: ItemButtonType, state: ItemButtonState, action: @escaping () -> Void) {
        self.type = type
        self.state = state
        self.action = action
    }

    private var backgroundColor: Color {
        switch state {
        case .default: return Color.orange500
        case .locked, .disabled: return Color.beige400
        }
    }

    private var isInteractive: Bool {
        state != .disabled && state != .locked
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
                DUIcon(.lock, size: .size16)
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
                .onEnded { _ in action() } : nil
        )
        .animation(nil, value: isPressed)
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
