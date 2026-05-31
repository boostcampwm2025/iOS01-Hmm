//
//  TokenTypographyView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenTypographyView: View {

    @State private var inputText = "개발자 키우기"
    @FocusState private var isFocused: Bool

    private let items: [(String, DUTypographyToken)] = [
        ("largeTitle",   .largeTitle),
        ("title",        .title),
        ("title2",       .title2),
        ("title3",       .title3),
        ("headline",     .headline),
        ("subheadline",  .subheadline),
        ("body",         .body),
        ("callout",      .callout),
        ("caption",      .caption),
        ("caption2",     .caption2),
        ("label",        .label),
        ("labelline",    .labelline),
    ]

    var body: some View {
        List {
            Section {
                HStack(spacing: TokenSpacing.xs) {
                    TextField("미리보기 텍스트 입력", text: $inputText)
                        .duFont(.body)
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
                            .duFont(font)
                            .foregroundStyle(Color.gray700)
                        Text(name)
                            .duFont(.caption)
                            .foregroundStyle(Color.gray400)
                    }
                    .padding(.vertical, TokenSpacing.xs)
                }
            } header: {
                Text("폰트 스타일")
                    .duFont(.caption)
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
