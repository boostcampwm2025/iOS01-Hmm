//
//  ComponentItemButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentItemButtonView: View {

    @State private var text: String = "20,000"
    @State private var selectedState: ItemButton.ItemButtonState = .default
    @State private var isPressed: Bool = false

    private var stateLabel: String {
        "isPressed: \(isPressed)"
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                VStack(spacing: TokenSpacing.sm) {
                    Text(stateLabel)
                        .duFont(.caption)
                        .foregroundStyle(Color.gray400)

                    ItemButton(text: text, state: selectedState) { }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in isPressed = true }
                                .onEnded { _ in isPressed = false },
                            including: (selectedState == .locked || selectedState == .disabled) ? .none : .all
                        )
                }
                .frame(maxWidth: .infinity, alignment: .center)
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

                Section("상태") {
                    Picker("상태", selection: $selectedState) {
                        Text("Default").tag(ItemButton.ItemButtonState.default)
                        Text("Locked").tag(ItemButton.ItemButtonState.locked)
                        Text("Disabled").tag(ItemButton.ItemButtonState.disabled)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("ItemButton")
        .navigationSubtitle("누르고 있으면 pressed 상태를 확인할 수 있어요")
    }
}

#Preview {
    NavigationStack {
        ComponentItemButtonView()
    }
}
