//
//  TokenTypographyView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenTypographyView: View {

    @State private var inputText = "개발자 키우기"
    @FocusState private var isFocused: Bool

    private let items: [(String, Font)] = [
        ("largeTitle",   TokenTypography.largeTitle),
        ("title",        TokenTypography.title),
        ("title2",       TokenTypography.title2),
        ("title3",       TokenTypography.title3),
        ("headline",     TokenTypography.headline),
        ("subheadline",  TokenTypography.subheadline),
        ("body",         TokenTypography.body),
        ("callout",      TokenTypography.callout),
        ("caption",      TokenTypography.caption),
        ("caption2",     TokenTypography.caption2),
        ("label",        TokenTypography.label),
        ("labelline",    TokenTypography.labelline),
    ]

    var body: some View {
        List {
            Section {
                HStack(spacing: TokenSpacing.xs) {
                    TextField("미리보기 텍스트 입력", text: $inputText)
                        .font(TokenTypography.body)
                        .foregroundStyle(Color.gray700)
                        .focused($isFocused)
                    if !inputText.isEmpty {
                        Button {
                            inputText = ""
                            isFocused = true
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.gray300)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section {
                ForEach(items, id: \.0) { name, font in
                    VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                        Text(inputText.isEmpty ? " " : inputText)
                            .font(font)
                            .foregroundStyle(Color.gray700)
                        Text(name)
                            .font(TokenTypography.caption)
                            .foregroundStyle(Color.gray400)
                    }
                    .padding(.vertical, TokenSpacing.xs)
                }
            } header: {
                Text("폰트 스타일")
                    .font(TokenTypography.caption)
                    .foregroundStyle(Color.gray400)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Typography")
    }
}

#Preview {
    NavigationStack {
        TokenTypographyView()
    }
}
