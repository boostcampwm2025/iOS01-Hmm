//
//  LanguageItemButton.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct LanguageItemButton: View {

    public var language: LanguageItem.LanguageType
    public var action: () -> Void

    @GestureState private var isPressed: Bool = false

    public init(language: LanguageItem.LanguageType, action: @escaping () -> Void) {
        self.language = language
        self.action = action
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.sm) {
            LanguageItem(language: language, state: .upcoming)
            ItemLabel(text: language.rawValue.replacingOccurrences(of: "language", with: "").capitalized, font: .caption, color: .black300)
        }
        .padding(.vertical, TokenSpacing.sm)
        .frame(width: 64)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
        .tokenShadow(isPressed ? .none : .default)
        .offset(
            x: isPressed ? TokenShadow.default.x : 0,
            y: isPressed ? TokenShadow.default.y : 0
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in state = true }
                .onEnded { _ in action() }
        )
        .animation(nil, value: isPressed)
    }
}

#Preview {
    HStack(spacing: TokenSpacing.md) {
        LanguageItemButton(language: .swift, action: {})
        LanguageItemButton(language: .kotlin, action: {})
        LanguageItemButton(language: .dart, action: {})
        LanguageItemButton(language: .python, action: {})
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
