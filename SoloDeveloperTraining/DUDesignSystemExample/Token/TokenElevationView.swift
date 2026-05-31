//
//  TokenElevationView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenElevationView: View {

    private let items: [(String, TokenShadow)] = [
        ("none",   .none),
        ("small",  .small),
        ("medium", .medium),
        ("large",  .large),
        ("xLarge", .xLarge),
    ]

    var body: some View {
        List(items, id: \.0) { name, shadow in
            HStack(spacing: TokenSpacing.sm) {
                RoundedRectangle(cornerRadius: TokenRadius.sm)
                    .fill(Color.beige50)
                    .frame(width: 56, height: 56)
                    .tokenShadow(shadow)
                Text(name)
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(Color.gray600)
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
