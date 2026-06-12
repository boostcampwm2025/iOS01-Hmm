//
//  ComponentEventButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentEventButtonView: View {

    @State private var selectedType: EventButton.EventButtonType = .next

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                EventButton(
                    type: selectedType,
                    firstChoice: "선택지 A",
                    secondChoice: "선택지 B"
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("타입") {
                    Picker("타입", selection: $selectedType) {
                        Text("Next").tag(EventButton.EventButtonType.next)
                        Text("Choice").tag(EventButton.EventButtonType.choice)
                        Text("Reselect").tag(EventButton.EventButtonType.reselect)
                        Text("Ending").tag(EventButton.EventButtonType.ending)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("EventButton")
    }
}

#Preview {
    NavigationStack {
        ComponentEventButtonView()
    }
}
