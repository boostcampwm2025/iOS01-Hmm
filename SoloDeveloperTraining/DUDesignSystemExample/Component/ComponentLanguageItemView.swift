//
//  ComponentLanguageItemView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentLanguageItemView: View {

    @State private var selectedState: LanguageItem.LanguageItemState = .active
    @State private var selectedLanguage: LanguageItem.LanguageType = .swift

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                LanguageItem(language: selectedLanguage, state: selectedState)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("언어") {
                    Picker("언어", selection: $selectedLanguage) {
                        Text("Swift").tag(LanguageItem.LanguageType.swift)
                        Text("Kotlin").tag(LanguageItem.LanguageType.kotlin)
                        Text("Dart").tag(LanguageItem.LanguageType.dart)
                        Text("Python").tag(LanguageItem.LanguageType.python)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section("상태") {
                    Picker("상태", selection: $selectedState) {
                        Text("Completed").tag(LanguageItem.LanguageItemState.completed)
                        Text("Upcoming").tag(LanguageItem.LanguageItemState.upcoming)
                        Text("Active").tag(LanguageItem.LanguageItemState.active)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("LanguageItem")
    }
}

#Preview {
    NavigationStack {
        ComponentLanguageItemView()
    }
}
