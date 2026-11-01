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
    @State private var welcomeRewardDiamond = 0
    @State private var inputFieldMaxY: CGFloat = 0
    @State private var keyboardMinY: CGFloat = .infinity

    private let validator = Validator()
    /// (닉네임, 웰컴 보상 다이아)
    let onComplete: (String, Int) -> Void

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
                        placeholder: "닉네임을 입력해주세요.",
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
                    Image.duImage("housingStreet")
                        .resizable()
                        .opacity(TokenOpacity.opacity40)
                )
                TextButton(text: "완료", type: .primary, state: isValid ? .default : .disabled) {
                    SoundService.shared.trigger(.click)
                    confirmedNickname = nickname
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    showInviteCodeInputPopup()
                }
                .padding(.top, 16 + 48)
                .padding(.horizontal, TokenSpacing.lg)
                Spacer()
            }
            .background(Color.black300)
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .analyticsScreen(.nickname)
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
                onComplete(confirmedNickname, welcomeRewardDiamond)
            }
        }
    }
}

// MARK: - 초대 코드

private extension NicknameSetupView {
    /// 초대 코드 입력 (최초 1회) → 성공 시 웰컴 보상 / 건너뛰기 시 바로 튜토리얼
    func showInviteCodeInputPopup() {
        PopupManager.shared.show {
            InviteCodeInputPopupView(
                onConfirm: showWelcomeRewardPopup,
                onSkip: {
                    PopupManager.shared.dismiss()
                    showTutorial = true
                }
            )
        }
    }

    func showWelcomeRewardPopup() {
        PopupManager.shared.replace {
            WelcomeRewardPopupView {
                // 다이아는 User 생성 시점(onComplete)에 지급
                welcomeRewardDiamond = InviteConstants.welcomeRewardDiamond
                PopupManager.shared.dismiss()
                showTutorial = true
            }
        }
    }
}

#Preview {
    NicknameSetupView { nickname, welcomeRewardDiamond in
        print("완료: \(nickname), 웰컴 보상: \(welcomeRewardDiamond)")
    }
}
