//
//  ComponentDefaultLabelView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentDefaultLabelView: View {

    @State private var text: String = "개발자 키우기"
    @State private var selectedSize: ItemLabel.LabelSize = .medium
    @State private var selectedColor: ItemLabel.LabelColor = .white
    @State private var selectedIcon: DUIconName? = .ad

    var body: some View {
        List {
            // MARK: - Preview
            Section {
                ItemLabel(text: text, icon: selectedIcon, size: selectedSize, color: selectedColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, TokenSpacing.lg)
                    .background(
                        LinearGradient(
                            colors: [Color.gray700, Color.beige50],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
                    )
            }
            .listRowBackground(Color.clear)

            // MARK: - 텍스트
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

            // MARK: - 크기
            Section("크기") {
                Picker("크기", selection: $selectedSize) {
                    Text("Small").tag(ItemLabel.LabelSize.small)
                    Text("Medium").tag(ItemLabel.LabelSize.medium)
                    Text("Large").tag(ItemLabel.LabelSize.large)
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            // MARK: - 색상
            Section("색상") {
                Picker("색상", selection: $selectedColor) {
                    Text("White").tag(ItemLabel.LabelColor.white)
                    Text("Black").tag(ItemLabel.LabelColor.black)
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            // MARK: - 아이콘
            Section("아이콘") {
                Picker("아이콘", selection: $selectedIcon) {
                    Text("없음").tag(Optional<DUIconName>.none)
                    ForEach(DUIconName.allCases, id: \.self) { icon in
                        Text(".\(icon)").tag(Optional(icon))
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
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
