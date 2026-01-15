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
        static let vertical: CGFloat = 2
    }
}

struct ItemRow: View {

    let title: String
    let description: String
    let imageName: String
    let price: Int
    let isDisabled: Bool
    let action: () -> Void

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
                gold: price,
                isDisabled: isDisabled,
                axis: .horizontal,
                width: Constant.priceButtonWidth,
                action: action
            )
        }
    }
}

#Preview {
    VStack {
        ItemRow(
            title: "강화 / 아이템 이름 이름 이름",
            description: "항목 설명 설명 설명",
            imageName: "background_street",
            price: 1_000_000,
            isDisabled: false
        ) {
            print("Tapped")
        }
        ItemRow(
            title: "강화 / 아이템 이름 이름 이름",
            description: "항목 설명 설명 설명",
            imageName: "background_street",
            price: 1_000_000,
            isDisabled: true
        ) {
            print("Tapped")
        }
    }
    .padding(.horizontal)
}
