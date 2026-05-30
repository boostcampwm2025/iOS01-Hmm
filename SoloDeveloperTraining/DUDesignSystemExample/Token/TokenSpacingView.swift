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

    var body: some View {
        List(items, id: \.0) { name, spacing in
            HStack(spacing: 12) {
                ZStack(alignment: .leading) {
                    Color.orange100
                        .frame(width: 80, height: 28)
                    Color.orange300
                        .frame(width: max(spacing, 1), height: 28)
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                    Text("\(Int(spacing))pt")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Spacing")
    }
}

#Preview {
    NavigationStack {
        TokenSpacingView()
    }
}
