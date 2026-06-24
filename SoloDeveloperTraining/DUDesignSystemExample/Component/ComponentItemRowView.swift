//
//  ComponentItemRowView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentItemRowView: View {

    @State private var title: String = "아이템 이름"
    @State private var description: String = "항목 설명"
    @State private var buttonText: String = "28.71M"
    @State private var buttonState: ItemButton.ItemButtonState = .default

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                ItemRow(
                    imageName: "",
                    title: title,
                    description: description,
                    buttonType: .singleLine(text: buttonText, icon: .coinBag),
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
                        Text("Disabled").tag(ItemButton.ItemButtonState.disabled)
                        Text("Locked").tag(ItemButton.ItemButtonState.locked)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section("속성") {
                    HStack {
                        Text("타이틀")
                        TextField("타이틀", text: $title)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("설명")
                        TextField("설명", text: $description)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("버튼 텍스트")
                        TextField("버튼 텍스트", text: $buttonText)
                            .multilineTextAlignment(.trailing)
                    }
                }

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
