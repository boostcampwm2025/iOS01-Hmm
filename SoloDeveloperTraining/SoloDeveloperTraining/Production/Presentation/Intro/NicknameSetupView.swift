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
    @State private var inputFieldMaxY: CGFloat = 0
    @State private var keyboardMinY: CGFloat = .infinity

    private let validator = Validator()
    let onComplete: (String) -> Void

    private var isValid: Bool {
        validator.isValid(nickname)
    }

    private var inputFieldOffset: CGFloat {
        let overlap = inputFieldMaxY - keyboardMinY
        return max(0, overlap)
    }

    var body: some View {
        GeometryReader { geo in
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
                    .offset(y: inputFieldOffset > 0 ? -20 : 0)
                    Spacer()
                    InputField(
                        text: $nickname,
                        placeholder: "닉네임을 입력해주세요",
                        state: nicknameState
                    )
                    .overlay(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                inputFieldMaxY = geo.frame(in: .global).maxY
                            }
                        }
                    )
                    .offset(y: -inputFieldOffset)
                }
                .frame(height: 560)
                .background(
                    Image.duImage("housing_street")
                        .resizable()
                        .opacity(TokenOpacity.opacity40)
                )
                TextButton(text: "완료", type: .primary, state: isValid ? .default : .disabled) {
                    SoundService.shared.trigger(.click)
                    confirmedNickname = nickname
                    showTutorial = true
                }
                .padding(.top, 16 + 48)
                .padding(.horizontal, TokenSpacing.lg)
                Spacer()
            }
            .background(Color.black300)
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea(.keyboard)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardMinY = frame.minY
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardMinY = .infinity
        }
        .animation(TokenAnimation.moveSmooth.animation, value: inputFieldOffset)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: nickname) { _, newValue in
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
