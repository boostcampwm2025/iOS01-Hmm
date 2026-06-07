//
//  Popup.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct Popup: View {

    public enum PopupType {
        case notice(
            title: String,
            body: String,
            buttonText: String,
            action: () -> Void
        )
        case confirm(
            title: String,
            body: String,
            cancelText: String,
            confirmText: String,
            cancelAction: () -> Void,
            confirmAction: () -> Void
        )
        case reward(
            title: String,
            body: String,
            rewardLeadingText: String,
            rewardIcon: DUIconName,
            rewardTrailingText: String,
            buttonText: String,
            action: () -> Void
        )
    }

    public var type: PopupType

    public init(type: PopupType) {
        self.type = type
    }

    private var titleText: String {
        switch type {
        case .notice(let t, _, _, _):       return t
        case .confirm(let t, _, _, _, _, _): return t
        case .reward(let t, _, _, _, _, _, _): return t
        }
    }

    private var bodyText: String {
        switch type {
        case .notice(_, let b, _, _):       return b
        case .confirm(_, let b, _, _, _, _): return b
        case .reward(_, let b, _, _, _, _, _): return b
        }
    }

    @ViewBuilder
    private var buttonSection: some View {
        switch type {
        case .notice(_, _, let text, let action):
            TextButton(text: text, type: .primary, size: .medium, action: action)

        case .confirm(_, _, let cancelText, let confirmText, let cancelAction, let confirmAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                TextButton(text: confirmText, type: .primary, size: .medium, action: confirmAction)
            }

        case .reward(_, _, _, _, _, let text, let action):
            TextButton(text: text, type: .primary, size: .medium, action: action)
        }
    }

    private var isBodyLeadingAligned: Bool {
        if case .confirm = type { return false }
        return true
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            Text(titleText)
                .duFont(.title2)
                .foregroundStyle(Color.black300)
                .multilineTextAlignment(.center)

            Text(bodyText)
                .duFont(.body)
                .foregroundStyle(Color.black300)
                .multilineTextAlignment(isBodyLeadingAligned ? .leading : .center)
                .frame(maxWidth: .infinity, alignment: isBodyLeadingAligned ? .leading : .center)

            if case .reward(_, _, let leading, let icon, let trailing, _, _) = type {
                HStack(spacing: TokenSpacing.xs) {
                    Text(leading)
                        .duFont(.body)
                        .foregroundStyle(Color.black300)
                    DUIcon(icon, size: .size18)
                    Text(trailing)
                        .duFont(.body)
                        .foregroundStyle(Color.black300)
                }
            }

            buttonSection
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
        Popup(type: .notice(
            title: "팝업 타이틀",
            body: "팝업 내용 내용 내용 내용 내용 내용 내용 내용\n내용 내용",
            buttonText: "닫기",
            action: {}
        ))
        Popup(type: .confirm(
            title: "팝업 타이틀",
            body: "팝업 내용 내용 내용 내용 내용 내용 내용 내용\n내용 내용",
            cancelText: "취소",
            confirmText: "구매",
            cancelAction: {},
            confirmAction: {}
        ))
        Popup(type: .reward(
            title: "팝업 타이틀",
            body: "팝업 내용 내용 내용 내용 내용 내용 내용 내용\n내용 내용",
            rewardLeadingText: "직득한 다이아 : ",
            rewardIcon: .diamond,
            rewardTrailingText: "20",
            buttonText: "닫기",
            action: {}
        ))
    }
    .padding(.vertical, TokenSpacing.lg)
    .background(Color.beige200)
}
