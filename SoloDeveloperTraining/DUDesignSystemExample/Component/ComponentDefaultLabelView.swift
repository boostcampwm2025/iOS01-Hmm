//
//  ComponentDefaultLabelView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentDefaultLabelView: View {

    @State private var text: String = "개발자 키우기"
    @State private var selectedFont: DUTypographyToken = .subheadline
    @State private var selectedColor: Color = .black300
    @State private var selectedIcon: DUIconName? = .ad
    @State private var selectedIconSize: TokenIconSize = .size16

    private let fonts: [(String, DUTypographyToken)] = [
        ("title1", .title1), ("title2", .title2),
        ("headline", .headline), ("subheadline", .subheadline),
        ("body", .body), ("body2", .body2),
        ("caption", .caption), ("label", .label),
    ]

    private let colors: [(String, Color)] = [
        ("white300", .white300), ("black300", .black300),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                if let icon = selectedIcon {
                    ItemLabel(text: text, icon: icon, iconSize: selectedIconSize, font: selectedFont, color: selectedColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ItemLabel(text: text, font: selectedFont, color: selectedColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            // MARK: - Controls
            List {
                Section("텍스트") {
                    HStack {
                        TextField("텍스트 입력", text: $text)
                        if !text.isEmpty {
                            Button { text = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.gray400)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("폰트") {
                    Picker("폰트", selection: $selectedFont) {
                        ForEach(fonts, id: \.0) { name, token in
                            Text(name).tag(token)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("색상") {
                    Picker("색상", selection: $selectedColor) {
                        ForEach(colors, id: \.0) { name, color in
                            Text(name).tag(color)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section("아이콘") {
                    Picker("아이콘", selection: $selectedIcon) {
                        Text("없음").tag(Optional<DUIconName>.none)
                        ForEach(DUIconName.allCases, id: \.self) { icon in
                            Text(".\(icon)").tag(Optional(icon))
                        }
                    }

                    if selectedIcon != nil {
                        Picker("아이콘 크기", selection: $selectedIconSize) {
                            ForEach(TokenIconSize.allCases, id: \.self) { size in
                                Text("\(Int(size.rawValue))").tag(size)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("DefaultLabel")
        .navigationSubtitle("조합을 선택해 컴포넌트를 확인해보세요")
    }
}

#Preview {
    NavigationStack {
        ComponentDefaultLabelView()
    }
}
