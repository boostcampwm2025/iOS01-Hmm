//
//  TokenGridView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenGridView: View {

    private let items: [(String, CGFloat)] = [
        ("paddingSide",   TokenGrid.paddingSide),
        ("paddingTop",    TokenGrid.paddingTop),
        ("paddingBottom", TokenGrid.paddingBottom),
        ("marginPopUp",   TokenGrid.marginPopUp),
    ]

    private let trackWidth: CGFloat = 160

    var body: some View {
        List(items, id: \.0) { name, value in
            HStack(spacing: TokenSpacing.sm) {
                ZStack(alignment: .leading) {
                    Color.beige200
                        .frame(width: trackWidth, height: 24)
                    Color.orange300
                        .frame(width: min(value, trackWidth), height: 24)
                }
                .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xs))

                VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(Color.gray400)
                    Text("\(Int(value))pt")
                        .duFont(.caption)
                        .foregroundStyle(Color.gray200)
                }
            }
            .padding(.vertical, TokenSpacing.xs)
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Grid")
    }
}

#Preview {
    NavigationStack {
        TokenGridView()
    }
}
