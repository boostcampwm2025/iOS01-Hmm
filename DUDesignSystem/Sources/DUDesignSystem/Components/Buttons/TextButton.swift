//
//  TextButton.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/4/26.
//

import SwiftUI

public struct TextButton: View {

    public enum TextButtonType {
        case primary
        case secondary
    }

    public enum TextButtonSize {
        case large
        case medium
    }

    public enum TextButtonState {
        case `default`
        case pressed
        case disabled
        case locked
    }

    public var text: String
    public var type: TextButtonType
    public var size: TextButtonSize
    public var state: TextButtonState
    public var showDiamond: Bool
    public var action: () -> Void

    @GestureState private var isPressed: Bool = false

    public init(
        text: String,
        type: TextButtonType,
        size: TextButtonSize = .large,
        state: TextButtonState = .default,
        showDiamond: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.type = type
        self.size = size
        self.state = state
        self.showDiamond = showDiamond
        self.action = action
    }

    private var backgroundColor: Color {
        switch state {
        case .default, .pressed:
            return type == .primary ? Color.orange500 : Color.gray100
        case .disabled, .locked:
            return Color.beige400
        }
    }

    private var labelColor: ItemLabel.LabelColor {
        type == .primary ? .white : .black
    }

    private var isInteractive: Bool {
        state != .disabled && state != .locked
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                ItemLabel(text: text, icon: nil, size: size == .large ? .large : .medium, color: labelColor)
                    .opacity(state == .locked ? TokenOpacity.opacity40 : TokenOpacity.opacity100)
                if state == .locked {
                    DUIcon(.lock, size: .size15)
                }
            }
            .frame(maxWidth: size == .large ? .infinity : 200)
            .padding(.vertical, TokenSpacing.mm)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            .tokenShadow(isPressed ? .none : .dim)
            .gesture(
                isInteractive ? DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
                    .onEnded { _ in action() } : nil
            )

            if showDiamond {
                DUIcon(.diamondPlus, size: .size24)
                    .offset(y: -(TokenIconSize.size24.rawValue / 2))
                    .allowsHitTesting(false)
            }
        }
        .offset(
            x: isPressed ? TokenShadow.dim.x : 0,
            y: isPressed ? TokenShadow.dim.y : 0
        )
        .animation(nil, value: isPressed)
        .padding(.horizontal, size == .large ? TokenSpacing.xxl : TokenSpacing.none)
        .frame(maxWidth: size == .large ? .infinity : nil)
    }
}
