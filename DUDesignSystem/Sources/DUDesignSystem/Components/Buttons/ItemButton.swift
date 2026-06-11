//
//  ItemButton.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/4/26.
//

import SwiftUI

public struct ItemButton: View {
    // isPressed 상태 분리

    public enum ItemButtonState {
        case `default`
        case pressed
        case locked
        case disabled
    }

    public var text: String
    public var state: ItemButtonState = .default
    public var action: () -> Void

    @GestureState private var isPressed: Bool = false

    public init(text: String, state: ItemButtonState, action: @escaping () -> Void) {
        self.text = text
        self.state = state
        self.action = action
    }

    private var backgroundColor: Color {
        switch state {
        case .default, .pressed: return Color.orange500
        case .locked, .disabled: return Color.beige400
        }
    }

    private var isInteractive: Bool {
        state != .disabled && state != .locked
    }

    public var body: some View {
        ZStack {
            ItemLabel(text: text, icon: .coinBag, iconSize: .size16, font: .caption, color: .white300)
                .opacity(state == .locked ? TokenOpacity.opacity40 : TokenOpacity.opacity100)
            if state == .locked {
                DUIcon(.lock, size: .size16)
            }
        }
        .frame(width: 80)
        .padding(.vertical, TokenSpacing.mm)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        .tokenShadow(isPressed ? .none : .dim)
        // 그림자 토큰 사용해서 피그마 기준으로 변경
        .offset(
            x: isPressed ? TokenShadow.dim.x : 0,
            y: isPressed ? TokenShadow.dim.y : 0
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
        ItemButton(text: "20,000", state: .default) { }
        ItemButton(text: "20,000", state: .locked) { }
        ItemButton(text: "20,000", state: .disabled) { }
    }
    .padding(32)
    .background(Color.beige200)
}
