//
//  TokenRadiusView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenRadiusView: View {

    private let items: [(String, CGFloat, String)] = [
        ("none", TokenRadius.none, "Bar"),
        ("xs",   TokenRadius.xs,   "StatusBar · 프로필"),
        ("sm",   TokenRadius.sm,   "기본 적용"),
        ("md",   TokenRadius.md,   ""),
        ("lg",   TokenRadius.lg,   "Pop up · 테두리"),
        ("xl",   TokenRadius.xl,   ""),
        ("full", TokenRadius.full, "완전한 원형"),
    ]

    var body: some View {
        List(items, id: \.0) { name, radius, description in
            HStack(spacing: TokenSpacing.md) {
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.orange300)
                    .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(Color.gray400)
                    HStack(spacing: TokenSpacing.xs) {
                        Text("\(Int(radius))pt")
                            .duFont(.caption)
                            .foregroundStyle(Color.gray200)
                        if !description.isEmpty {
                            Text("· \(description)")
                                .duFont(.caption)
                                .foregroundStyle(Color.gray200)
                        }
                    }
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
