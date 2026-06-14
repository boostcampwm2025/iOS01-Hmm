//
//  ComponentEventButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentEventButtonView: View {

    private enum EventButtonPreviewType: String, CaseIterable {
        case next
        case choice
        case reselect
        case ending
    }

    @State private var selectedType: EventButtonPreviewType = .next
    @State private var selectedOption: String = ""

    private var eventButtonType: EventButton.EventButtonType {
        switch selectedType {
        case .next:
            return .next(action: {})

        case .choice:
            return .choice(
                optionA: "1. 선택지",
                optionB: "2. 선택지",
                selected: selectedOption,
                onSelect: { selection in selectedOption = selection }
            )

        case .reselect:
            return .reselect(
                onReselect: {},
                onComplete: {}
            )

        case .ending:
            return .ending(
                onSave: {},
                onShare: {},
                onRebirth: {}
            )
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                EventButton(type: eventButtonType)
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("타입") {
                    Picker("타입", selection: $selectedType) {
                        Text("Next").tag(EventButtonPreviewType.next)
                        Text("Choice").tag(EventButtonPreviewType.choice)
                        Text("Reselect").tag(EventButtonPreviewType.reselect)
                        Text("Ending").tag(EventButtonPreviewType.ending)
                    }
                    .pickerStyle(.segmented)
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
