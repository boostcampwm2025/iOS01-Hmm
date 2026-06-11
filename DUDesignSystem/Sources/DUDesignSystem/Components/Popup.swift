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
        case adBonus(
            title: String,
            body: String,
            rewardLeadingText: String,
            rewardIcon: DUIconName,
            rewardTrailingText: String,
            cancelText: String,
            adIcon: DUIconName,
            adText: String,
            cancelAction: () -> Void,
            adAction: () -> Void

        )
        case adReward(
            title: String,
            body: String,
            cancelText: String,
            adIcon: DUIconName,
            adText: String,
            cancelAction: () -> Void,
            adAction: () -> Void
        )
        case adConfirm(
            title: String,
            body: String,
            subText: String,
            cancelText: String,
            adIcon: DUIconName,
            adText: String,
            confirmText: String,
            cancelAction: () -> Void,
            adAction: () -> Void,
            confirmAction: () -> Void
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
        case .adBonus(let t, _, _, _, _, _, _, _, _, _): return t
        case .adReward(let t, _, _, _, _, _, _): return t
        case .adConfirm(let t, _, _, _, _, _, _, _, _, _): return t
        }
    }

    private var bodyText: String {
        switch type {
        case .notice(_, let b, _, _):       return b
        case .confirm(_, let b, _, _, _, _): return b
        case .reward(_, let b, _, _, _, _, _): return b
        case .adBonus(_, let b, _, _, _, _, _, _, _, _): return b
        case .adReward(_, let b, _, _, _, _, _): return b
        case .adConfirm(_, let b, _, _, _, _, _, _, _, _): return b
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

        case .adBonus(_, _, _, _, _, let cancelText, let adIcon, let adText, let cancelAction, let adAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                TextButton(text: adText, icon: adIcon, type: .primary, size: .medium, action: adAction)
            }

        case .adReward(_, _, let cancelText, let adIcon, let adText, let cancelAction, let adAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                TextButton(text: adText, icon: adIcon, type: .primary, size: .medium, action: adAction)
            }

        case .adConfirm(_, _, _, let cancelText, let adIcon, let adText, let confirmText, let cancelAction, let adAction, let confirmAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                TextButton(text: adText, icon: adIcon, type: .primary, size: .medium, action: adAction)
                TextButton(text: confirmText, type: .primary, size: .medium, action: confirmAction)
            }
        }
        
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: titleText, font: .title2, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            ItemLabel(text: bodyText, font: .body, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            if case .reward(_, _, let leading, let icon, let trailing, _, _) = type {
                HStack(spacing: TokenSpacing.mm) {
                    ItemLabel(text: leading, font: .body, color: .black300)
                    ItemLabel(text: trailing, icon: icon, iconSize: .size24, font: .headline, color: .black300)
                }
            }

            if case .adBonus(_, _, let leading, let icon, let trailing, _, _, _, _, _) = type {
                HStack(spacing: TokenSpacing.mm) {
                    ItemLabel(text: leading, font: .body, color: .black300)
                    ItemLabel(text: trailing, icon: icon, iconSize: .size24, font: .headline, color: .black300)
                }
            }

            if case .adConfirm(_, _, let subText, _, _, _, _, _, _, _) = type {
                ItemLabel(text: subText, font: .body, color: .accentRed)
                    .frame(maxWidth: .infinity, alignment: .center)
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
            rewardLeadingText: "획득한 다이아 : ",
            rewardIcon: .diamond,
            rewardTrailingText: "20",
            buttonText: "닫기",
            action: {}
        ))
        Popup(type: .adBonus(
            title: "보너스",
            body: "퀴즈 풀이를 완료했습니다!\n진정한 개발자에 한 걸음 더 가까워졌습니다.",
            rewardLeadingText: "획득한 다이아 : ",
            rewardIcon: .diamond,
            rewardTrailingText: "5",
            cancelText: "취소",
            adIcon: .ad,
            adText: "2배 얻기",
            cancelAction: {},
            adAction: {}
        ))
        Popup(type: .adReward(
            title: "타이틀",
            body: "안녕하세요\n이곳은 팝업 내용을 적는 곳입니다",
            cancelText: "취소",
            adIcon: .ad,
            adText: "2배 얻기",
            cancelAction: {},
            adAction: {}
        ))
        Popup(type: .adConfirm(
            title: "아이템구매",
            body: "[₩2,000,000]을 사용하여\n구매하시겠습니까?",
            subText: "(성공 확률: 70%)",
            cancelText: "취소",
            adIcon: .ad,
            adText: "확률 UP",
            confirmText: "구매",
            cancelAction: {},
            adAction: {},
            confirmAction: {}
        ))
    }
    .padding(.vertical, TokenSpacing.lg)
    .background(Color.beige200)
}
