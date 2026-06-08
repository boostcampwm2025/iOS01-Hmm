//
//  ComponentItemRowView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentItemRowView: View {

    @State private var buttonState: ItemButton.ItemButtonState = .default

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                ItemRow(
                    imageName: "",
                    title: "아이템 이름",
                    description: "항목 설명 설명 설명 설명 설명 설명",
                    buttonText: "28.71M",
                    buttonState: buttonState,
                    action: {}
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("버튼 상태") {
                    Picker("버튼 상태", selection: $buttonState) {
                        Text("Default").tag(ItemButton.ItemButtonState.default)
                        Text("Pressed").tag(ItemButton.ItemButtonState.pressed)
                        Text("Disabled").tag(ItemButton.ItemButtonState.disabled)
                        Text("Locked").tag(ItemButton.ItemButtonState.locked)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section {
                    Text("상태 변경이나 유효성 검사는 비즈니스 로직이므로 예시 앱에는 반영되지 않아요.")
                        .font(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("ItemRow")
    }
}

#Preview {
    NavigationStack {
        ComponentItemRowView()
    }
}
