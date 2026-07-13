//
//  ItemLabel.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/4/26.
//

import SwiftUI

public struct ItemLabel: View {

    public var text: String
    public var icon: DUIconName?
    public var iconSize: TokenIconSize?
    public var font: DUTypographyToken
    public var color: Color
    public var textAlignment: TextAlignment

    public init(text: String, font: DUTypographyToken, color: Color, textAlignment: TextAlignment = .center) {
        self.text = text
        self.icon = nil
        self.iconSize = nil
        self.font = font
        self.color = color
        self.textAlignment = textAlignment
    }

    public init(text: String, icon: DUIconName, iconSize: TokenIconSize, font: DUTypographyToken, color: Color, textAlignment: TextAlignment = .center) {
        self.text = text
        self.icon = icon
        self.iconSize = iconSize
        self.font = font
        self.color = color
        self.textAlignment = textAlignment
    }

    public var body: some View {
        HStack(spacing: TokenSpacing.xs) {
            if let icon = icon, let iconSize = iconSize {
                DUIcon(icon, size: iconSize)
            }
            Text(text)
                .duFont(font)
                .foregroundStyle(color)
                .multilineTextAlignment(textAlignment)
        }
    }
}
