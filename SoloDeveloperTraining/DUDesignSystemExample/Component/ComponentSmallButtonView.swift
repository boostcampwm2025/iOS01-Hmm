//
//  ComponentSmallButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentSmallButtonView: View {

    @State private var selectedType: SmallButton.SmallButtonType = .quiz

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                SmallButton(type: selectedType) { }
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("타입") {
                    Picker("타입", selection: $selectedType) {
                        Text("Quiz").tag(SmallButton.SmallButtonType.quiz)
                        Text("Setting").tag(SmallButton.SmallButtonType.setting)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("SmallButton")
    }
}

#Preview {
    NavigationStack {
        ComponentSmallButtonView()
    }
}
