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
        case priority
    }

    public enum TextButtonSize {
        case large
        case medium
    }

    public enum TextButtonState {
        case `default`
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
        case .default:
            switch type {
            case .primary:  return Color.orange500
            case .secondary: return Color.gray100
            case .priority: return Color.orange300
            }
        case .disabled, .locked:
            return Color.beige400
        }
    }

    private var labelColor: Color {
        switch state {
        case .disabled, .locked: return .white300
        default: return type == .secondary ? .black300 : .white300
        }
    }

    private var isInteractive: Bool {
        state != .disabled && state != .locked
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            ItemLabel(text: text, font: size == .large ? .headline : .subheadline, color: labelColor)
                .opacity(state == .locked ? TokenOpacity.opacity40 : TokenOpacity.opacity100)
                .overlay(
                    Group {
                        if state == .locked {
                            DUIcon(.lock, size: .size16)
                        }
                    }
                )
            .frame(maxWidth: size == .large ? .infinity : 200)
            .padding(.vertical, TokenSpacing.mm)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            .tokenShadow(isPressed ? .none : (state == .default ? .default : .dim))
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
            x: isPressed ? TokenShadow.default.x : 0,
            y: isPressed ? TokenShadow.default.y : 0
        )
        .animation(nil, value: isPressed)
        .frame(maxWidth: size == .large ? .infinity : nil)
    }
}
