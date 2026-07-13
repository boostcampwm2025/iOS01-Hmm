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
        
        var message: String {
            switch self {
            case .error(let message):
                return message
            default:
                return ""
            }
        }
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
            
            ItemLabel(text: state.message, font: .label, color: .accentRed)
                .padding(.trailing, TokenSpacing.xs)

            HStack {
                ZStack(alignment: .leading) {
                    ItemLabel(text: placeholder, font: .body2, color: .black300)
                        .opacity(text.isEmpty && !isFocused ? TokenOpacity.opacity20 : 0)
                        .frame(height: 14)
                    TextField("", text: $text)
                        .duFont(.body2)
                        .foregroundStyle(Color.black300)
                        .tint(Color.black300)
                        .focused($isFocused)
                        .frame(height: 14)
                }

            }
            .padding(TokenSpacing.md)
            .background(Color.white300)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.ss))
            .overlay(
                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .padding(TokenSpacing.lg)
    }
}

#Preview {
    VStack(spacing: TokenSpacing.xs) {
        InputField(text: .constant(""), placeholder: "닉네임을 입력해주세요", state: .default)
        InputField(text: .constant("소"), placeholder: "닉네임을 입력해주세요", state: .error(message: "닉네임은 1자 이상 입력해주세요."))
        InputField(text: .constant("소피아소피아소피아"), placeholder: "닉네임을 입력해주세요", state: .error(message: "닉네임은 최대 8자까지 입력할 수 있어요."))
        InputField(text: .constant("소피아"), placeholder: "닉네임을 입력해주세요", state: .success)
    }
    .background(Color.beige200)
}
