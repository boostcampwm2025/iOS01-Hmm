//
//  InputField.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct InputField: View {

    public enum InputFieldState {
        case `default`
        case error(message: String)
        case success
    }

    @Binding public var text: String
    public var placeholder: String
    public var state: InputFieldState

    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeholder: String,
        state: InputFieldState = .default
    ) {
        self._text = text
        self.placeholder = placeholder
        self.state = state
    }

    private var borderColor: Color {
        switch state {
        case .default: return Color.black300GrayBar
        case .error:   return Color.accentRed
        case .success: return Color.black300
        }
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: TokenSpacing.xs) {
            HStack {
                ZStack(alignment: .leading) {
                    Text(placeholder)
                        .duFont(.body)
                        .foregroundStyle(Color.gray200)
                        .opacity(text.isEmpty && !isFocused ? 1 : 0)
                    TextField("", text: $text)
                        .duFont(.body)
                        .foregroundStyle(Color.black300)
                        .tint(Color.black300)
                        .focused($isFocused)
                }
                .frame(height: 24)

                if case .error = state {
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.accentRed)
                }
            }
            .padding(.vertical, TokenSpacing.mm)
            .padding(.horizontal, TokenSpacing.md)
            .background(Color.white300StatusBar)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: TokenRadius.sm)
                    .stroke(borderColor, lineWidth: 1)
            )

            if case .error(let message) = state {
                Text(message)
                    .duFont(.label)
                    .foregroundStyle(Color.accentRed)
                    .padding(.trailing, TokenSpacing.xs)
            }
        }
    }
}

#Preview {
    VStack(spacing: TokenSpacing.md) {
        InputField(text: .constant(""), placeholder: "닉네임을 입력해주세요", state: .default)
        InputField(text: .constant("소"), placeholder: "닉네임을 입력해주세요", state: .error(message: "닉네임은 1자 이상 입력해주세요."))
        InputField(text: .constant("소피아소피아소피아"), placeholder: "닉네임을 입력해주세요", state: .error(message: "닉네임은 최대 8자까지 입력할 수 있어요."))
        InputField(text: .constant("소피아"), placeholder: "닉네임을 입력해주세요", state: .success)
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
