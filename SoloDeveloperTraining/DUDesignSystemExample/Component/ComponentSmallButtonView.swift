//
//  ComponentSmallButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentSmallButtonView: View {

    @State private var selectedType: SmallButton.SmallButtonType = .quiz

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            SmallButton(type: selectedType) { }

            Picker("타입", selection: $selectedType) {
                Text("Quiz").tag(SmallButton.SmallButtonType.quiz)
                Text("Setting").tag(SmallButton.SmallButtonType.setting)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, TokenGrid.paddingSide)

            Spacer()
        }
        .padding(.top, TokenSpacing.lg)
        .background(Color.beige200)
        .navigationTitle("SmallButton")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ComponentSmallButtonView()
    }
}
