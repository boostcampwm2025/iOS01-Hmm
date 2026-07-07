//
//  SmallButton.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/5/26.
//

import SwiftUI

public struct SmallButton: View {
    
    public enum SmallButtonType: Hashable {
        case quiz
        case setting
    }

    public var type: SmallButtonType
    public var action: () -> Void

    @GestureState private var isPressed: Bool = false

    public init(type: SmallButtonType, action: @escaping () -> Void) {
        self.type = type
        self.action = action
    }

    public var body: some View {
        let button: AnyView = switch type {
        case .quiz:
            AnyView(
                ItemLabel(text: "퀴즈", font: .subheadline, color: .white300)
                    .frame(width: 44, height: 44)
                    .background(Color.lightOrange)
                    .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
                    .tokenShadow(isPressed ? .none : .default)
                    .overlay(alignment: .topTrailing) {
                        DUIcon(.diamondPlus, size: .size24)
                            .offset(x: 8, y: -12)
                            .allowsHitTesting(false)
                    }
                    .offset(
                        x: isPressed ? TokenShadow.default.x : 0,
                        y: isPressed ? TokenShadow.default.y : 0
                    )
            )
        case .setting:
            AnyView(
                Image("setting", bundle: .module)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
                    .tokenShadow(isPressed ? .none : .default)
                    .offset(
                        x: isPressed ? TokenShadow.default.x : 0,
                        y: isPressed ? TokenShadow.default.y : 0
                    )
            )
        }

        return button
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
                    .onEnded { _ in action() }
            )
            .animation(nil, value: isPressed)
            .padding(TokenSpacing.md)
    }
}

#Preview {
    HStack(spacing: 20) {
        SmallButton(type: .quiz) { }
        SmallButton(type: .setting) { }
    }
    .padding()
    .background(Color.beige200)
}
