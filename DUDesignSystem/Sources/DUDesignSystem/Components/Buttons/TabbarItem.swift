//
//  TabbarItem.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/5/26.
//

import SwiftUI

public struct TabbarItem: View {

    public enum TabbarItemState {
        case `default`
        case selected
    }

    public var assetName: String
    public var text: String
    public var state: TabbarItemState
    public var isNew: Bool
    public var action: () -> Void

    public init(
        assetName: String,
        text: String,
        state: TabbarItemState = .default,
        isNew: Bool = false,
        action: @escaping () -> Void
    ) {
        self.assetName = assetName
        self.text = text
        self.state = state
        self.isNew = isNew
        self.action = action
    }

    private var backgroundColor: Color {
        state == .selected ? Color.orange300 : Color.beige300
    }

    private var labelColor: Color {
        state == .selected ? .white300 : .orange500
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.none) {
            Image(assetName, bundle: .module)
                .resizable()
                .frame(width: 24, height: 24)
            ItemLabel(text: text, font: .caption, color: labelColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, TokenSpacing.xs)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xs))
        .overlay(alignment: .topTrailing) {
            if isNew {
                DUIcon(.new, size: .size24)
                    .offset(x: 8, y: -12)
                    .allowsHitTesting(false)
            }
        }
        .tokenShadow(.default)
        .onTapGesture { action() }
    }
}
