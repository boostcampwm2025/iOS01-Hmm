//
//  TokenElevationView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenElevationView: View {

    private let items: [(String, TokenShadow, String)] = [
        ("none",    .none,    "0px 0px 0px 0px"),
        ("dim",     .dim,     "1px 2px 0px 0px · gray/400"),
        ("default", .`default`, "1px 2px 0px 0px · gray/700"),
    ]

    var body: some View {
        List(items, id: \.0) { name, shadow, description in
            HStack(spacing: TokenSpacing.sm) {
                RoundedRectangle(cornerRadius: TokenRadius.sm)
                    .fill(Color.beige50)
                    .frame(width: 56, height: 56)
                    .tokenShadow(shadow)
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
        .navigationTitle("Elevation")
    }
}

#Preview {
    NavigationStack {
        TokenElevationView()
    }
}
