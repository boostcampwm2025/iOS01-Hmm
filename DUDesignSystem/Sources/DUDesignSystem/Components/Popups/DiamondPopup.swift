//
//  DiamondPopup.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/15/26.
//

import SwiftUI

public struct DiamondPopup: View {

    public enum DiamondPopupType {
        case `default`(
            buttonText: String,
            action: () -> Void
        )
        case ad(
            cancelText: String,
            adText: String,
            cancelAction: () -> Void,
            adAction: () -> Void
        )
    }

    public var type: DiamondPopupType
    public var title: String
    public var text: String
    public var diamond: Int


    public init(
        type: DiamondPopupType,
        title: String,
        text: String,
        diamond: Int
    ) {
        self.type = type
        self.title = title
        self.text = text
        self.diamond = diamond
    }

    @ViewBuilder
    private var buttonSection: some View {
        switch type {
        case .default(let buttonText, let action):
            TextButton(text: buttonText, type: .primary, size: .medium, action: action)

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

            ItemLabel(text: text, font: .body, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack(spacing: TokenSpacing.mm) {
                ItemLabel(text: "획득한 다이아 : ", font: .body, color: .black300)
                ItemLabel(text: "\(diamond)", icon: .diamond, iconSize: .size24, font: .headline, color: .black300)
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
        DiamondPopup(
            type: .default(
                buttonText: "닫기",
                action: {}
            ),
            title: "타이틀",
            text: "텍스트",
            diamond: 5
        )
        DiamondPopup(
            type: .ad(
                cancelText: "취소",
                adText: "2배 얻기",
                cancelAction: {},
                adAction: {}
            ),
            title: "타이틀",
            text: "텍스트",
            diamond: 5
        )
    }
    .padding(.vertical, TokenSpacing.lg)
    .background(Color.beige200)
}
