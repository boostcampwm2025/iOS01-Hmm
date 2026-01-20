//
//  ItemRow.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {

    static let imageSize: CGSize = .init(width: 38, height: 38)
    static let cornerRadius: CGFloat = 4
    static let priceButtonWidth: CGFloat = 89

    enum Spacing {
        static let horizontal: CGFloat = 8
        static let vertical: CGFloat = 4
    }

    enum Padding {
        static let horizontal: CGFloat = 16
        static let vertical: CGFloat = 8
    }
}

struct ItemRow: View {

    let title: String
    let description: String
    let imageName: String
    let currencyType: CurrencyType
    let price: Int
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        description: String,
        imageName: String,
        currencyType: CurrencyType = .gold,
        price: Int,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.currencyType = currencyType
        self.price = price
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        HStack(spacing: Constant.Spacing.horizontal) {
            Image(imageName)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: Constant.cornerRadius))
                .frame(width: Constant.imageSize.width, height: Constant.imageSize.height)
            VStack(alignment: .leading, spacing: Constant.Spacing.vertical) {
                Text(title)
                    .foregroundStyle(.black)
                    .textStyle(.subheadline)
                Text(description)
                    .foregroundStyle(.black)
                    .textStyle(.label)
            }

            Spacer()

            PriceButton(
                price: price,
                isDisabled: isDisabled,
                axis: .horizontal,
                width: Constant.priceButtonWidth,
                currencyType: currencyType,
                action: action
            )
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.vertical, Constant.Padding.vertical)
    }
}

#Preview {
    VStack {
        ItemRow(
            title: "강화 / 아이템 이름 이름 이름",
            description: "항목 설명 설명 설명",
            imageName: "background_street",
            currencyType: .gold,
            price: 1_000_000,
            isDisabled: false
        ) {
            print("Tapped")
        }
        ItemRow(
            title: "강화 / 아이템 이름 이름 이름",
            description: "항목 설명 설명 설명",
            imageName: "background_street",
            currencyType: .diamond,
            price: 1_000_000,
            isDisabled: true
        ) {
            print("Tapped")
        }
    }
}
