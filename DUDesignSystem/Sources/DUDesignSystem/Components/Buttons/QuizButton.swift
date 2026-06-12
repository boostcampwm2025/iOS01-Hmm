//
//  QuizButton.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/5/26.
//

import SwiftUI

public struct QuizButton: View {

    public enum QuizButtonState: Hashable {
        case `default`
        case selected
    }

    public var text: String
    public var state: QuizButtonState
    public var action: () -> Void

    public init(text: String, state: QuizButtonState = .default, action: @escaping () -> Void) {
        self.text = text
        self.state = state
        self.action = action
    }

    private var backgroundColor: Color {
        state == .selected ? Color.orange300 : Color.beige200
    }

    private var textColor: Color {
        state == .selected ? Color.white300 : Color.black300
    }

    public var body: some View {
        ItemLabel(text: text, font: .body2, color: textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, TokenSpacing.md)
            .padding(.horizontal, TokenSpacing.mm)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            .contentShape(Rectangle())
            .onTapGesture { action() }
    }
}

#Preview {
    VStack(spacing: 12) {
        QuizButton(text: "보기 1번", state: .default) { }
        QuizButton(text: "보기 2번", state: .selected) { }
    }
    .padding()
    .background(Color.beige200)
}
