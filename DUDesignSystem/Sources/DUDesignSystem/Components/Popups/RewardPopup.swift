//
//  RewardPopup.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/15/26.
//

import SwiftUI

public struct RewardPopup: View {

    public enum RewardPopupItem {
        case diamond(Int)
        case gold(Int)

        var name: String {
            switch self {
            case .diamond: return "다이아"
            case .gold: return "골드"
            }
        }
    }

    public var title: String
    public var text: String
    public var cancelText: String
    public var adText: String
    public var cancelAction: () -> Void
    public var adAction: () -> Void
    public var item: RewardPopupItem


    public init(
        title: String,
        text: String,
        cancelText: String,
        adText: String,
        cancelAction: @escaping () -> Void,
        adAction: @escaping () -> Void,
        item: RewardPopupItem,
    ) {
        self.title = title
        self.text = text
        self.cancelText = cancelText
        self.adText = adText
        self.cancelAction = cancelAction
        self.adAction = adAction
        self.item = item
    }

    @ViewBuilder
    private var itemSection: some View {
        HStack(spacing: TokenSpacing.mm) {
            ItemLabel(text: "획득한 \(item.name) : ", font: .body, color: .black300)
            switch item {
            case .diamond(let amount):
                ItemLabel(text: "\(amount)", icon: .diamond, iconSize: .size24, font: .headline, color: .black300)
            case .gold(let amount):
                ItemLabel(
                    text: "\(amount)",
                    icon: .coinBag,
                    iconSize: .size24,
                    font: .headline,
                    color: .black300
                )
            }
        }
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: title, font: .title2, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            ItemLabel(text: text, font: .body, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            itemSection

            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                IconButton(text: adText, icon: .ad, size: .medium, action: adAction)
            }
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
        RewardPopup(
            title: "보상 획득!",
            text: "광고를 시청하면 보상을 2배로 받을 수 있습니다.",
            cancelText: "닫기",
            adText: "2배 얻기",
            cancelAction: {},
            adAction: {},
            item: .diamond(5)
        )

        RewardPopup(
            title: "보상 획득!",
            text: "광고를 시청하면 보상을 2배로 받을 수 있습니다.",
            cancelText: "닫기",
            adText: "2배 얻기",
            cancelAction: {},
            adAction: {},
            item: .gold(1000)
        )
    }
    .padding(.vertical, TokenSpacing.lg)
    .background(Color.beige200)
}
