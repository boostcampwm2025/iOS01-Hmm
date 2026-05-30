//
//  TokenElevationView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenElevationView: View {

    private let items: [(String, TokenShadow.Shadow)] = [
        ("none",   TokenShadow.none),
        ("small",  TokenShadow.small),
        ("medium", TokenShadow.medium),
        ("large",  TokenShadow.large),
        ("xLarge", TokenShadow.xLarge),
    ]

    var body: some View {
        List(items, id: \.0) { name, shadow in
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.beige50)
                    .frame(width: 44, height: 44)
                    .tokenShadow(shadow)
                Text(name)
                    .font(.system(.body, design: .monospaced))
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Elevation")
    }
}

#Preview {
    NavigationStack {
        TokenElevationView()
    }
}
