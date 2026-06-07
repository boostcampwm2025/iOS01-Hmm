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
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                QuizButton(text: text, state: selectedState) {
                    selectedState = selectedState == .selected ? .default : .selected
                }
                .frame(maxWidth: .infinity)
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
                        Text("Default").tag(QuizButton.QuizButtonState.default)
                        Text("Selected").tag(QuizButton.QuizButtonState.selected)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("QuizButton")
    }
}

#Preview {
    NavigationStack {
        ComponentQuizButtonView()
    }
}
