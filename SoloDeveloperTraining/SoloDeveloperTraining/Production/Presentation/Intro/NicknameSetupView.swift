//
//  NicknameSetupView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

import DUDesignSystem

struct NicknameSetupView: View {
    @State private var nickname: String = ""
    @State private var nicknameState: InputField.InputFieldState = .default
    @State private var showTutorial = false
    @State private var confirmedNickname = ""

    private let validator = Validator()
    let onComplete: (String) -> Void

    private var isValid: Bool {
        validator.isValid(nickname)
    }

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            Spacer()
            VStack(spacing: TokenSpacing.none) {
                Spacer()
                ItemLabel(
                    text: """
                        당신은 취직에 실패한 개발자
                        .... 이대로 물러설 수는 없다.
                        나의 꿈은 1인 개발자로 성공하기 ~!

                        내 이름은!!
                        """,
                    font: .body,
                    color: .white300,
                    textAlignment: .center
                )
                Spacer()
                InputField(
                    text: $nickname,
                    placeholder: "닉네임을 입력해주세요",
                    state: nicknameState
                )
            }
            .frame(height: 560)
            .background(
                Image.duImage("housing_street")
                    .resizable()
                    .opacity(TokenOpacity.opacity40)
            )
            TextButton(text: "완료", type: .primary, state: isValid ? .default : .disabled) {
                confirmedNickname = nickname
                showTutorial = true
            }
            .padding(.top, 16 + 48)
            .padding(.horizontal, TokenSpacing.lg)
            Spacer()
        }
        .background(Color.black300)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: nickname) { newValue in
            switch validator.validate(newValue) {
            case .empty:
                nicknameState = .default
            case .valid:
                nicknameState = .success
            case .invalid(let message):
                nicknameState = .error(message: message)
            }
        }
        .fullScreenCover(isPresented: $showTutorial) {
            TutorialView {
                onComplete(confirmedNickname)
            }
        }
    }
}

#Preview {
    NicknameSetupView { nickname in
        print("완료: \(nickname)")
    }
}
