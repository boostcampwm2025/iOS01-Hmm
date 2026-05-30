//
//  TokenOpacityView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenOpacityView: View {

    private let items: [(String, Double)] = [
        ("opacity0",   TokenOpacity.opacity0),
        ("opacity10",  TokenOpacity.opacity10),
        ("opacity20",  TokenOpacity.opacity20),
        ("opacity40",  TokenOpacity.opacity40),
        ("opacity60",  TokenOpacity.opacity60),
        ("opacity80",  TokenOpacity.opacity80),
        ("opacity100", TokenOpacity.opacity100),
    ]

    var body: some View {
        List(items, id: \.0) { name, value in
            HStack(spacing: TokenSpacing.sm) {
                RoundedRectangle(cornerRadius: TokenRadius.xs)
                    .fill(Color.orange300.opacity(value))
                    .frame(width: 44, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: TokenRadius.xs)
                            .strokeBorder(Color.gray200.opacity(0.5), lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(Color.gray600)
                    Text(String(format: "%.0f%%", value * 100))
                        .font(TokenTypography.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .padding(.vertical, TokenSpacing.xx)
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Opacity")
    }
}

#Preview {
    NavigationStack {
        TokenOpacityView()
    }
}
