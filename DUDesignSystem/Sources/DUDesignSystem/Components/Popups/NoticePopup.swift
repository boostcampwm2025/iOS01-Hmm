//
//  NoticePopup.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/15/26.
//

import SwiftUI

public struct NoticePopup: View {

    public enum NoticePopupType {
        case `default`(
            buttonText: String,
            action: () -> Void
        )
        case confirm(
            cancelText: String,
            confirmText: String,
            cancelAction: () -> Void,
            confirmAction: () -> Void
        )
        case ad(
            cancelText: String,
            adText: String,
            cancelAction: () -> Void,
            adAction: () -> Void
        )
    }

    public var type: NoticePopupType
    public var title: String
    public var text: String

    public init(
        type: NoticePopupType,
        title: String,
        text: String
    ) {
        self.type = type
        self.title = title
        self.text = text
    }

    @ViewBuilder
    private var buttonSection: some View {
        switch type {
        case .default(let buttonText, let action):
            TextButton(text: buttonText, type: .primary, size: .medium, action: action)

        case .confirm(let cancelText, let confirmText, let cancelAction, let confirmAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                TextButton(text: confirmText, type: .primary, size: .medium, action: confirmAction)
            }

        case .ad(let cancelText, let adText, let cancelAction, let adAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                IconButton(text: adText, icon: .ad, size: .medium, action: adAction)
            }
        }
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: title, font: .title2, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(text)
                .duFont(.body)
                .foregroundStyle(Color.black300)
                .multilineTextAlignment(.center)

            buttonSection
                .padding(.top, TokenSpacing.xxl - TokenSpacing.lg)
        }
        .frame(maxWidth: .infinity)
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: TokenRadius.lg)
                .stroke(Color.gray700, lineWidth: 2)
        )
        .padding(.horizontal, TokenSpacing.lg)
    }
}

#Preview {
    VStack(spacing: TokenSpacing.lg) {
        NoticePopup(
            type: .default(
                buttonText: "닫기",
                action: {}
            ),
            title: "타이틀",
            text: "텍스트"
        )
        NoticePopup(
            type: .confirm(
                cancelText: "취소",
                confirmText: "확인",
                cancelAction: {},
                confirmAction: {}
            ),
            title: "타이틀",
            text: "텍스트"
        )
        NoticePopup(
            type: .ad(
                cancelText: "취소",
                adText: "2배 얻기",
                cancelAction: {},
                adAction: {}
            ),
            title: "타이틀",
            text: "텍스트"
        )
    }
    .padding(.vertical, TokenSpacing.lg)
    .background(Color.beige200)
}
