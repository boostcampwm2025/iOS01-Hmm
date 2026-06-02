//
//  TokenColorView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenColorView: View {

    private let sections: [(String, [(String, Color, String)])] = [
        ("White", [
            ("white300",    .white300,    "#FFFFFF"),
            ("white300_80", .white300_80, "#FFFFFF · opacity 80%"),
        ]),
        ("Black", [
            ("black300",    .black300,    "#000000"),
            ("black300_30", .black300_30, "#000000 · opacity 20%"),
            ("black300_10", .black300_10, "#000000 · opacity 10%"),
        ]),
        ("Gray", [
            ("gray100", .gray100, "#D9D9D9"),
            ("gray200", .gray200, "#B4B4B4"),
            ("gray400", .gray400, "#8A8A8A"),
            ("gray700", .gray700, "#111111"),
        ]),
        ("Orange", [
            ("orange200", .orange200, "#F3A487"),
            ("orange300", .orange300, "#E17B43"),
            ("orange500", .orange500, "#723C1E"),
        ]),
        ("Beige", [
            ("beige50",  .beige50,  "#FFFAF3"),
            ("beige100", .beige100, "#FFF9F0"),
            ("beige200", .beige200, "#FFF1E7"),
            ("beige300", .beige300, "#EDE0D5"),
            ("beige400", .beige400, "#BCAEA3"),
        ]),
        ("Light", [
            ("lightGreen",  .lightGreen,  "#4EFF48"),
            ("lightOrange", .lightOrange, "#F57C00"),
        ]),
        ("Accent", [
            ("accentGreen",  .accentGreen,  "#5DB875"),
            ("accentYellow", .accentYellow, "#FBC02D"),
            ("accentRed",    .accentRed,    "#D32F2F"),
        ]),
    ]

    var body: some View {
        List {
            ForEach(sections, id: \.0) { title, colors in
                Section {
                    ForEach(colors, id: \.0) { name, color, description in
                        HStack(spacing: TokenSpacing.sm) {
                            RoundedRectangle(cornerRadius: TokenRadius.xs)
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    RoundedRectangle(cornerRadius: TokenRadius.xs)
                                        .strokeBorder(Color.gray200.opacity(0.5), lineWidth: 1)
                                )
                            VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                                Text(name)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundStyle(Color.gray400)
                                Text(description)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(Color.gray200)
                            }
                        }
                        .padding(.vertical, TokenSpacing.xx)
                    }
                } header: {
                    Text(title)
                        .duFont(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Color")
    }
}

#Preview {
    NavigationStack {
        TokenColorView()
    }
}
