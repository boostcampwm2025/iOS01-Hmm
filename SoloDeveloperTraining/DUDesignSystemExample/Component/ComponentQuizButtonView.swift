//
//  ComponentQuizButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentQuizButtonView: View {

    @State private var text: String = "보기 1번"
    @State private var selectedState: QuizButton.QuizButtonState = .default

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            QuizButton(text: text, state: selectedState) {
                selectedState = selectedState == .selected ? .default : .selected
            }
            .padding(.horizontal, TokenGrid.paddingSide)

            Picker("상태", selection: $selectedState) {
                Text("Default").tag(QuizButton.QuizButtonState.default)
                Text("Selected").tag(QuizButton.QuizButtonState.selected)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, TokenGrid.paddingSide)

            HStack {
                TextField("텍스트 입력", text: $text)
                    .textFieldStyle(.roundedBorder)
                if !text.isEmpty {
                    Button { text = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.gray400)
                    }
                }
            }
            .padding(.horizontal, TokenGrid.paddingSide)

            Spacer()
        }
        .padding(.top, TokenSpacing.lg)
        .background(Color.beige200)
        .navigationTitle("QuizButton")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ComponentQuizButtonView()
    }
}
