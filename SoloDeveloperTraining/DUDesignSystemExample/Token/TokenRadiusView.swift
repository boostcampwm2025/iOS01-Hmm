//
//  TokenRadiusView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenRadiusView: View {

    private let items: [(String, CGFloat)] = [
        ("none", TokenRadius.none),
        ("xs",   TokenRadius.xs),
        ("sm",   TokenRadius.sm),
        ("md",   TokenRadius.md),
        ("lg",   TokenRadius.lg),
        ("xl",   TokenRadius.xl),
        ("full", TokenRadius.full),
    ]

    var body: some View {
        List(items, id: \.0) { name, radius in
            HStack(spacing: TokenSpacing.md) {
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.orange300)
                    .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(Color.gray600)
                    Text("\(Int(radius))pt")
                        .duFont(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .padding(.vertical, TokenSpacing.xs)
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Radius")
    }
}

#Preview {
    NavigationStack {
        TokenRadiusView()
    }
}
