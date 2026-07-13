//
//  ItemRow.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct ItemRow: View {

    public var imageName: String
    public var title: String
    public var description: String
    public var buttonType: ItemButton.ItemButtonType
    public var buttonState: ItemButton.ItemButtonState
    public var action: () -> Void
    public var onLongPress: (() -> Bool)?

    public init(
        imageName: String,
        title: String,
        description: String,
        buttonType: ItemButton.ItemButtonType,
        buttonState: ItemButton.ItemButtonState = .default,
        action: @escaping () -> Void,
        onLongPress: (() -> Bool)? = nil
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.buttonType = buttonType
        self.buttonState = buttonState
        self.action = action
        self.onLongPress = onLongPress
    }

    public var body: some View {
        HStack(spacing: TokenSpacing.sm) {
            Image(imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 38, height: 38)
                .clipped()

            VStack(alignment: .leading, spacing: TokenSpacing.xs) {
                ItemLabel(text: title, font: .subheadline, color: .black300)
                ItemLabel(text: description, font: .label, color: .black300)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ItemButton(type: buttonType, state: buttonState, action: action, onLongPress: onLongPress)
        }
    }
}

#Preview {
    VStack(spacing: TokenSpacing.sm) {
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonType: .singleLine(text: "28.71M", icon: .coinBag), buttonState: .default, action: {})
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonType: .singleLine(text: "28.71M", icon: .coinBag), buttonState: .disabled, action: {})
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonType: .singleLine(text: "28.71M", icon: .coinBag), buttonState: .locked, action: {})
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonType: .twoLine(firstText: "28.71M", firstIcon: .coinBag, secondText: "구매", secondIcon: .coinBag), buttonState: .default, action: {})
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
