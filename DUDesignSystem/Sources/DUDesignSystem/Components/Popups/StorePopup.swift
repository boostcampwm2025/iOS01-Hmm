//
//  StorePopup.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/15/26.
//

import SwiftUI

public struct StorePopup: View {

    public enum StorePopupType {
        case `default`(
            cancelText: String,
            confirmText: String,
            cancelAction: () -> Void,
            confirmAction: () -> Void
        )
        case ad(
            successRate: Int,
            adState: IconButton.IconButtonState,
            cancelText: String,
            adText: String,
            confirmText: String,
            cancelAction: () -> Void,
            adAction: () -> Void,
            confirmAction: () -> Void
        )
    }

    public var type: StorePopupType
    public var title: String
    public var itemName: String
    public var price: String
    public var rateHighlighted: Bool

    public init(
        type: StorePopupType,
        title: String,
        itemName: String,
        price: String,
        rateHighlighted: Bool = false
    ) {
        self.type = type
        self.title = title
        self.itemName = itemName
        self.price = price
        self.rateHighlighted = rateHighlighted
    }

    @ViewBuilder
    private var buttonSection: some View {
        switch type {
        case .default(let cancelText, let confirmText, let cancelAction, let confirmAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                TextButton(text: confirmText, type: .primary, size: .medium, action: confirmAction)
            }

        case .ad(_, let adState, let cancelText, let adText, let confirmText, let cancelAction, let adAction, let confirmAction):
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: cancelText, type: .secondary, size: .medium, action: cancelAction)
                IconButton(text: adText, icon: .ad, size: .medium, state: adState, action: adAction)
                TextButton(text: confirmText, type: .primary, size: .medium, action: confirmAction)
            }
        }
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: title, font: .title2, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            ItemLabel(text: "\(itemName)를\n\(price)를 사용하여\n구매하시겠습니까?", font: .body, color: .black300)
                .frame(maxWidth: .infinity, alignment: .center)

            if case .ad(let successRate, _, _, _, _, _, _, _) = type {
                ItemLabel(text: "(성공 확률: \(successRate)%)", font: .body, color: rateHighlighted ? .accentRed : .black300)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

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
        StorePopup(
            type: .default(
                cancelText: "취소",
                confirmText: "구매",
                cancelAction: {},
                confirmAction: {}
            ),
            title: "아이템구매",
            itemName: "바카스",
            price: "[₩2,000,000]"
        )
        StorePopup(
            type: .ad(
                successRate: 70,
                adState: .default,
                cancelText: "취소",
                adText: "확률 UP",
                confirmText: "구매",
                cancelAction: {},
                adAction: {},
                confirmAction: {}
            ),
            title: "아이템구매",
            itemName: "커피",
            price: "[₩2,000,000]"
        )
    }
    .padding(.vertical, TokenSpacing.lg)
    .background(Color.beige200)
}
