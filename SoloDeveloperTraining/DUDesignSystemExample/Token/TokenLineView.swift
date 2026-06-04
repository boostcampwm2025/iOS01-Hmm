//
//  TokenLineView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenLineView: View {

    private let items: [(String, TokenLine, String)] = [
        ("default", .`default`, "2pt · gray/700"),
    ]

    var body: some View {
        List(items, id: \.0) { name, line, description in
            HStack(spacing: TokenSpacing.sm) {
                RoundedRectangle(cornerRadius: TokenRadius.sm)
                    .fill(Color.beige50)
                    .frame(width: 56, height: 56)
                    .tokenLine(line, cornerRadius: TokenRadius.sm)
                VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(Color.gray400)
                    Text(description)
                        .duFont(.caption)
                        .foregroundStyle(Color.gray200)
                }
            }
            .padding(.vertical, TokenSpacing.xs)
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Line")
    }
}

#Preview {
    NavigationStack {
        TokenLineView()
    }
}
