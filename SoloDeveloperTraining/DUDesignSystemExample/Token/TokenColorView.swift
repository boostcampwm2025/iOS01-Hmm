//
//  TokenColorView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenColorView: View {

    private let sections: [(String, [(String, Color)])] = [
        ("White", [
            ("white200", .white200),
            ("white300", .white300),
        ]),
        ("Black", [
            ("black100", .black100),
            ("black300", .black300),
        ]),
        ("Gray", [
            ("gray100", .gray100),
            ("gray200", .gray200),
            ("gray300", .gray300),
            ("gray400", .gray400),
            ("gray500", .gray500),
            ("gray600", .gray600),
            ("gray700", .gray700),
        ]),
        ("Orange", [
            ("orange100", .orange100),
            ("orange200", .orange200),
            ("orange300", .orange300),
            ("orange400", .orange400),
            ("orange500", .orange500),
            ("orange600", .orange600),
            ("orange700", .orange700),
        ]),
        ("Beige", [
            ("beige50",  .beige50),
            ("beige100", .beige100),
            ("beige200", .beige200),
            ("beige300", .beige300),
            ("beige400", .beige400),
        ]),
        ("Light", [
            ("lightGreen",  .lightGreen),
            ("lightOrange", .lightOrange),
        ]),
        ("Accent", [
            ("accentGreen",  .accentGreen),
            ("accentYellow", .accentYellow),
            ("accentRed",    .accentRed),
        ]),
        ("Pastel", [
            ("pastelYellow", .pastelYellow),
            ("pastelPink",   .pastelPink),
            ("pastelBlue",   .pastelBlue),
            ("pastelGreen",  .pastelGreen),
        ]),
    ]

    var body: some View {
        List {
            ForEach(sections, id: \.0) { section in
                Section(section.0) {
                    ForEach(section.1, id: \.0) { name, color in
                        HStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                                )
                            Text(name)
                                .font(.system(.body, design: .monospaced))
                        }
                    }
                }
            }
        }
        .navigationTitle("Color")
    }
}

#Preview {
    NavigationStack {
        TokenColorView()
    }
}
