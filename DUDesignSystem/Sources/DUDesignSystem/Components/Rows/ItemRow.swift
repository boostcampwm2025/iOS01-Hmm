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
    public var buttonText: String
    public var buttonState: ItemButton.ItemButtonState
    public var action: () -> Void

    public init(
        imageName: String,
        title: String,
        description: String,
        buttonText: String,
        buttonState: ItemButton.ItemButtonState = .default,
        action: @escaping () -> Void
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.buttonText = buttonText
        self.buttonState = buttonState
        self.action = action
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

            ItemButton(text: buttonText, state: buttonState, action: action)
        }
    }
}

#Preview {
    VStack(spacing: TokenSpacing.sm) {
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonText: "28.71M", buttonState: .default, action: {})
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonText: "28.71M", buttonState: .default, action: {})
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonText: "28.71M", buttonState: .disabled, action: {})
        ItemRow(imageName: "", title: "아이템 이름", description: "항목 설명 설명 설명 설명 설명 설명", buttonText: "28.71M", buttonState: .locked, action: {})
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
