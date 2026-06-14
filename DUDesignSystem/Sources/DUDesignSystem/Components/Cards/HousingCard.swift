//
//  HousingCard.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct HousingCard: View {

    public enum HousingCardState {
        case `default`
        case selected
        case equipped
        case locked
        // locked
    }

    public var title: String
    public var price: String
    public var rewardPerSecond: String
    public var imageName: String
    public var state: HousingCardState
    public var onTap: () -> Void
    public var onButtonTap: () -> Void

    public init(
        title: String,
        price: String,
        rewardPerSecond: String,
        imageName: String,
        state: HousingCardState = .default,
        onTap: @escaping () -> Void,
        onButtonTap: @escaping () -> Void
    ) {
        self.title = title
        self.price = price
        self.rewardPerSecond = rewardPerSecond
        self.imageName = imageName
        self.state = state
        self.onTap = onTap
        self.onButtonTap = onButtonTap
    }

    private var buttonType: TextButton.TextButtonType {
        switch state {
        case .default, .selected: return .primary
        case .equipped, .locked: return .secondary
        }
    }

    private var buttonState: TextButton.TextButtonState {
        switch state {
        case .default, .selected: return .default
        case .equipped: return .locked
        case .locked: return .locked
        }
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.md) {
            // 상단 텍스트
            VStack(alignment: .leading, spacing: TokenSpacing.xs) {
                HStack(spacing: TokenSpacing.sm) {
                    ItemLabel(text: title, font: .subheadline, color: .black300)
                    ItemLabel(text: price, font: .label, color: .black300)
                }
                HStack(spacing: TokenSpacing.xs) {
                    ItemLabel(text: "초당 재화 획득량", font: .label, color: .black300)
                    ItemLabel(text: rewardPerSecond, font: .label, color: .black300)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, TokenSpacing.md)

            // 이미지 (좌우 패딩 없음)
            Image(imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 230)
                .clipped()
                .opacity(state == .locked ? TokenOpacity.opacity60 : TokenOpacity.opacity100)

            // 버튼
            TextButton(text: buttonText, type: buttonType, size: .medium, state: buttonState, action: onButtonTap)
                .padding(.horizontal, TokenSpacing.lg)
        }
        .padding(.vertical, TokenSpacing.md)
        .frame(width: 230)
        .background(state == .selected ? Color.beige50 : Color.beige100)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        .overlay(
            Group {
                if state == .selected {
                    RoundedRectangle(cornerRadius: TokenRadius.sm)
                        .stroke(Color.gray700, lineWidth: 2)
                }
            }
        )
        .onTapGesture { if state == .default || state == .selected { onTap() } }
    }

    private var buttonText: String {
        switch state {
        case .default: return "이사하기"
        case .selected: return "이사하기"
        case .equipped: return "장착중"
        case .locked: return "이사하기"
        }
    }
}

#Preview {
    HStack(spacing: TokenSpacing.sm) {
        HousingCard(
            title: "고시원",
            price: "₩10,000,000",
            rewardPerSecond: "초당 1 골드 획득",
            imageName: "housing_street",
            state: .default,
            onTap: {},
            onButtonTap: {}
        )
        HousingCard(
            title: "고시원",
            price: "₩10,000,000",
            rewardPerSecond: "초당 1 골드 획득",
            imageName: "housing_street",
            state: .selected,
            onTap: {},
            onButtonTap: {}
        )
        HousingCard(
            title: "고시원",
            price: "₩10,000,000",
            rewardPerSecond: "초당 1 골드 획득",
            imageName: "housing_street",
            state: .equipped,
            onTap: {},
            onButtonTap: {}
        )
        HousingCard(
            title: "고시원",
            price: "₩10,000,000",
            rewardPerSecond: "초당 1 골드 획득",
            imageName: "housing_street",
            state: .locked,
            onTap: {},
            onButtonTap: {}
        )
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
