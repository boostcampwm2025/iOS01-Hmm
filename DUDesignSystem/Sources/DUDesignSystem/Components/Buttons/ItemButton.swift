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
        case pressed
        case locked
        case disabled
    }

    public var text: String
    public var state: ItemButtonState = .default
    public var action: () -> Void
    
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

    public var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                ItemLabel(text: text, icon: .coinBag, size: .small, color: .white)
                    .opacity(state == .locked ? TokenOpacity.opacity40 : TokenOpacity.opacity100)
                if state == .locked {
                    DUIcon(.lock, size: .size15)
                }
            }
            .frame(width: 80)
            .padding(.vertical, TokenSpacing.mm)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        }
        .buttonStyle(ItemButtonStyle(state: state))
        .disabled(state == .disabled || state == .locked)
    }
}

private struct ItemButtonStyle: ButtonStyle {
    let state: ItemButton.ItemButtonState

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(
                x: configuration.isPressed ? TokenShadow.dim.x : 0,
                y: configuration.isPressed ? TokenShadow.dim.y : 0
            )
            .tokenShadow(configuration.isPressed ? .none : .dim)
            .animation(nil, value: configuration.isPressed)
    }
}
