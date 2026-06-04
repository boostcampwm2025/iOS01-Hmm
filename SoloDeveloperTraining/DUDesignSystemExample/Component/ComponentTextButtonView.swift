//
//  ComponentTextButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentTextButtonView: View {

    @State private var text: String = "텍스트"
    @State private var selectedType: TextButton.TextButtonType = .primary
    @State private var selectedSize: TextButton.TextButtonSize = .large
    @State private var selectedState: TextButton.TextButtonState = .default
    @State private var showDiamond: Bool = false
    var body: some View {
        List {
            // MARK: - Preview
            Section {
                TextButton(text: text, type: selectedType, size: selectedSize, state: selectedState, showDiamond: showDiamond) { }
                    .padding(.vertical, TokenSpacing.lg)
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

            // MARK: - 타입
            Section("타입") {
                Picker("타입", selection: $selectedType) {
                    Text("Primary").tag(TextButton.TextButtonType.primary)
                    Text("Secondary").tag(TextButton.TextButtonType.secondary)
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            // MARK: - 크기
            Section("크기") {
                Picker("크기", selection: $selectedSize) {
                    Text("Large").tag(TextButton.TextButtonSize.large)
                    Text("Small").tag(TextButton.TextButtonSize.small)
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            // MARK: - 상태
            Section("상태") {
                Picker("상태", selection: $selectedState) {
                    Text("Default").tag(TextButton.TextButtonState.default)
                    Text("Disabled").tag(TextButton.TextButtonState.disabled)
                    Text("Locked").tag(TextButton.TextButtonState.locked)
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            // MARK: - 다이아몬드
            Section("다이아몬드") {
                Toggle("showDiamond", isOn: $showDiamond)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("TextButton")
        .navigationSubtitle("누르고 있으면 pressed 상태를 확인할 수 있어요")
    }
}

#Preview {
    NavigationStack {
        ComponentTextButtonView()
    }
}
