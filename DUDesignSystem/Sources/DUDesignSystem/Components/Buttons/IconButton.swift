//
//  IconButton.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/15/26.
//

import SwiftUI

public struct IconButton: View {

    public enum IconButtonSize {
        case large
        case medium
    }

    public enum IconButtonState {
        case `default`
        case disabled
    }

    public var text: String
    public var icon: DUIconName
    public var size: IconButtonSize
    public var state: IconButtonState
    public var action: () -> Void

    @GestureState private var isPressed: Bool = false

    public init(
        text: String,
        icon: DUIconName,
        size: IconButtonSize,
        state: IconButtonState = .default,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.icon = icon
        self.size = size
        self.state = state
        self.action = action
    }

    private var isInteractive: Bool {
        state != .disabled
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            ItemLabel(
                text: text,
                icon: icon,
                iconSize: size == .large ? .size24 : .size20,
                font: .headline,
                color: .white300
            )
            .frame(maxWidth: size == .large ? .infinity : 200)
            .padding(.vertical, TokenSpacing.mm)
            .background(state == .disabled ? Color.beige400 : Color.orange500)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            .tokenShadow(isPressed ? .none : (state == .default ? .default : .dim))
            .gesture(
                isInteractive ? DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
                    .onEnded { _ in action() } : nil
            )
        }
        .offset(
            x: isPressed ? TokenShadow.default.x : 0,
            y: isPressed ? TokenShadow.default.y : 0
        )
        .animation(nil, value: isPressed)
        .frame(maxWidth: size == .large ? .infinity : nil)
    }
}
