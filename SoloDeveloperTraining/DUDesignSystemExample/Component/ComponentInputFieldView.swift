//
//  ComponentInputFieldView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentInputFieldView: View {

    enum StateOption: String, CaseIterable {
        case `default` = "Default"
        case error     = "Error"
        case success   = "Success"
    }

    @State private var text: String = ""
    @State private var placeholder: String = "닉네임을 입력해주세요"
    @State private var selectedState: StateOption = .default
    @State private var errorMessage: String = "닉네임은 1자 이상 입력해주세요."

    private var inputFieldState: InputField.InputFieldState {
        switch selectedState {
        case .default: return .default
        case .error:   return .error(message: errorMessage)
        case .success: return .success
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                InputField(text: $text, placeholder: placeholder, state: inputFieldState)
                    .frame(maxWidth: .infinity)
            }

            // MARK: - Controls
            List {
                Section("상태") {
                    Picker("상태", selection: $selectedState) {
                        ForEach(StateOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                if selectedState == .error {
                    Section("에러 메시지") {
                        TextField("에러 메시지 입력", text: $errorMessage)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("InputField")
        .navigationSubtitle("상태 변경 및 유효성 검사는 비즈니스 로직으로, 예시 앱에서는 반영되지 않아요")
    }
}

#Preview {
    NavigationStack {
        ComponentInputFieldView()
    }
}
