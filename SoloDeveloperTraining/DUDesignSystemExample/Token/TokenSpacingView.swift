//
//  TokenSpacingView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenSpacingView: View {

    private let items: [(String, CGFloat)] = [
        ("none", TokenSpacing.none),
        ("xx",   TokenSpacing.xx),
        ("xs",   TokenSpacing.xs),
        ("sm",   TokenSpacing.sm),
        ("mm",   TokenSpacing.mm),
        ("md",   TokenSpacing.md),
        ("lg",   TokenSpacing.lg),
        ("xl",   TokenSpacing.xl),
        ("xxl",  TokenSpacing.xxl),
        ("xxxl", TokenSpacing.xxxl),
    ]

    private let trackWidth: CGFloat = 160

    var body: some View {
        List(items, id: \.0) { name, spacing in
            HStack(spacing: TokenSpacing.sm) {
                ZStack(alignment: .leading) {
                    Color.orange100
                        .frame(width: trackWidth, height: 24)
                    if spacing > 0 {
                        Color.orange300
                            .frame(width: min(spacing, trackWidth), height: 24)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xs))

                VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(Color.gray600)
                    Text("\(Int(spacing))pt")
                        .duFont(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .padding(.vertical, TokenSpacing.xs)
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Spacing")
    }
}

#Preview {
    NavigationStack {
        TokenSpacingView()
    }
}
