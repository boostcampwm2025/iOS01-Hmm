//
//  ComponentTabbarItemView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentTabbarItemView: View {

    @State private var text: String = "홈"
    @State private var iconName: String = "work"
    @State private var selectedState: TabbarItem.TabbarItemState = .default

    var body: some View {
        List {
            // MARK: - Preview
            Section {
                HStack {
                    Spacer()
                    TabbarItem(iconName: iconName, text: text, state: selectedState) {
                        selectedState = selectedState == .selected ? .default : .selected
                    }
                    .frame(width: 103)
                    Spacer()
                }
                .padding(.vertical, TokenSpacing.sm)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

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

            // MARK: - 상태
            Section("상태") {
                Picker("상태", selection: $selectedState) {
                    Text("Default").tag(TabbarItem.TabbarItemState.default)
                    Text("Selected").tag(TabbarItem.TabbarItemState.selected)
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            // MARK: - 이미지명
            Section("이미지명") {
                Picker("이미지명", selection: $iconName) {
                    Text("work").tag("work")
                    Text("mission").tag("mission")
                    Text("skill").tag("skill")
                    Text("shop").tag("shop")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("TabbarItem")
    }
}

#Preview {
    NavigationStack {
        ComponentTabbarItemView()
    }
}
