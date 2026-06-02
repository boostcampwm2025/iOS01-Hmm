//
//  TokenTypographyView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenTypographyView: View {

    @State private var inputText = "개발자 키우기"
    @FocusState private var isFocused: Bool

    private let items: [(String, DUTypographyToken, String)] = [
        ("title1",      .title1,      "ExtraBold · 24pt"),
        ("title2",      .title2,      "Bold · 22pt"),
        ("headline",    .headline,    "ExtraBold · 17pt"),
        ("subheadline", .subheadline, "ExtraBold · 15pt"),
        ("body",        .body,        "Bold · 17pt"),
        ("body2",       .body2,       "Bold · 15pt"),
        ("caption",     .caption,     "ExtraBold · 12pt"),
        ("label",       .label,       "Bold · 11pt"),
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
                                .foregroundStyle(Color.gray400)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section {
                ForEach(items, id: \.0) { name, font, description in
                    VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                        Text(inputText.isEmpty ? " " : inputText)
                            .duFont(font)
                            .foregroundStyle(Color.gray700)
                        HStack(spacing: TokenSpacing.xs) {
                            Text(name)
                                .duFont(.caption)
                                .foregroundStyle(Color.gray400)
                            Text("·")
                                .duFont(.caption)
                                .foregroundStyle(Color.gray200)
                            Text(description)
                                .duFont(.caption)
                                .foregroundStyle(Color.gray200)
                        }
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
