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
    let cost: Cost
    let state: ItemState
    let action: () -> Void

    init(
        title: String,
        description: String,
        imageName: String,
        cost: Cost,
        state: ItemState,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.cost = cost
        self.state = state
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
                cost: cost,
                state: state,
                axis: .horizontal,
                width: Constant.priceButtonWidth,
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
            cost: .init(gold: 1_000_000),
            state: .available
        ) {
            print("Tapped")
        }
        ItemRow(
            title: "강화 / 아이템 이름 이름 이름",
            description: "항목 설명 설명 설명",
            imageName: "background_street",
            cost: .init(gold: 1_000_000),
            state: .locked
        ) {
            print("Tapped")
        }
        ItemRow(
            title: "강화 / 아이템 이름 이름 이름",
            description: "항목 설명 설명 설명",
            imageName: "background_street",
            cost: .init(gold: 1_000_000),
            state: .insufficient
        ) {
            print("Tapped")
        }
    }
}
