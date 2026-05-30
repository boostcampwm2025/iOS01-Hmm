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
                HStack {
                    TextField("미리보기 텍스트 입력", text: $inputText)
                        .font(.body)
                        .focused($isFocused)
                    if !inputText.isEmpty {
                        Button {
                            inputText = ""
                            isFocused = true
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section("폰트 스타일") {
                ForEach(items, id: \.0) { name, font in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(inputText.isEmpty ? " " : inputText)
                            .font(font)
                        Text(name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Typography")
    }
}

#Preview {
    NavigationStack {
        TokenTypographyView()
    }
}
