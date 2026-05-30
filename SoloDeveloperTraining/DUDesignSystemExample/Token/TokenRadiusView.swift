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
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.orange300)
                    .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                    Text("\(Int(radius))pt")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Radius")
    }
}

#Preview {
    NavigationStack {
        TokenRadiusView()
    }
}
