//
//  InviteCodeInputPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import SwiftUI

import DUDesignSystem

private enum Constant {
    static let guideText = "영문과 숫자 \(InviteConstants.codeLength)자리를 입력해주세요"
    static let autoFilledText = "복사한 초대 코드를 붙여넣었어요"
}

struct InviteCodeInputPopupView: View {
    @State private var code: String = ""
    @State private var validationResult: InviteCodeValidationResult?
    @State private var isValidating: Bool = false
    @State private var autoFilledCode: String?

    private let validator = InviteCodeValidator()

    let onConfirm: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: "친구 초대 코드", font: .title2, color: .black300)
            ItemLabel(
                text: "친구에게 받은 초대 코드를 입력하면\n웰컴 보상을 받아요.",
                font: .body,
                color: .gray400
            )

            VStack(spacing: TokenSpacing.md) {
                InputField(
                    text: $code,
                    placeholder: "초대 코드를 입력해주세요",
                    state: inputFieldState
                )
                .padding(.horizontal, -TokenSpacing.lg)
                .padding(.top, -(TokenSpacing.lg + TokenSpacing.md))
                .padding(.bottom, -TokenSpacing.lg)

                resultLabel

                TextButton(text: "확인", type: .primary, size: .large, state: confirmButtonState) {
                    SoundService.shared.trigger(.click)
                    confirm()
                }
                ItemLabel(
                    text: "지금 입력하지 않으면 나중에 입력할 수 없어요",
                    font: .label,
                    color: .gray400
                )
                skipButton
            }
        }
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
        .onAppear(perform: fillCodeFromClipboard)
        .onChange(of: code) { _, newValue in
            let normalized = validator.normalize(newValue)
            if normalized != newValue {
                code = normalized
            }
            validationResult = nil
        }
    }
}

private extension InviteCodeInputPopupView {
    /// 검증 실패 결과 (정상이거나 확인 전이면 nil)
    var failedResult: InviteCodeValidationResult? {
        guard let validationResult, !validationResult.isValid else { return nil }
        return validationResult
    }

    /// 실패 시 테두리만 빨간색으로 (문구는 resultLabel에서 표시)
    var inputFieldState: InputField.InputFieldState {
        failedResult == nil ? .default : .error(message: "")
    }

    /// 빈 값이거나 확인 중이면 비활성
    var confirmButtonState: TextButton.TextButtonState {
        code.isEmpty || isValidating ? .disabled : .default
    }

    /// 클립보드에서 가져온 코드를 그대로 두고 있는지
    var isShowingAutoFilledCode: Bool {
        autoFilledCode != nil && code == autoFilledCode
    }

    /// 실패: 실패 사유 / 자동 입력: 붙여넣기 안내 / 기본: 형식 안내
    @ViewBuilder
    var resultLabel: some View {
        if let failedResult {
            ItemLabel(text: failedResult.message, font: .label, color: .accentRed)
        } else if isShowingAutoFilledCode {
            ItemLabel(text: Constant.autoFilledText, font: .label, color: .accentGreen)
        } else {
            ItemLabel(text: Constant.guideText, font: .label, color: .gray400)
        }
    }

    /// 클립보드에 초대 코드가 있으면 자동 입력
    /// - 클립보드 문자열을 읽는 순간 iOS가 "붙여넣기 허용" 시스템 팝업을 띄움
    func fillCodeFromClipboard() {
        guard code.isEmpty, UIPasteboard.general.hasStrings else { return }
        guard let text = UIPasteboard.general.string,
              let extracted = validator.extractCode(from: text)
        else { return }

        autoFilledCode = extracted
        code = extracted
    }

    func confirm() {
        guard !isValidating else { return }
        isValidating = true

        Task {
            let result = await validator.validate(code)
            isValidating = false
            validationResult = result

            if result.isValid {
                onConfirm()
            }
        }
    }

    var skipButton: some View {
        Button {
            SoundService.shared.trigger(.click)
            onSkip()
        } label: {
            Text("건너뛰기")
                .duFont(.subheadline)
                .underline()
                .foregroundStyle(Color.gray400)
        }
    }
}

#Preview {
    ZStack {
        Color.black300.ignoresSafeArea()
        InviteCodeInputPopupView(onConfirm: {}, onSkip: {})
    }
}
