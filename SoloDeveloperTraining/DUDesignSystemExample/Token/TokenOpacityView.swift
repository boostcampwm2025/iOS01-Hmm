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
            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.orange300.opacity(value))
                    .frame(width: 44, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                    )
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(.body, design: .monospaced))
                    Text(String(format: "%.0f%%", value * 100))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Opacity")
    }
}

#Preview {
    NavigationStack {
        TokenOpacityView()
    }
}
