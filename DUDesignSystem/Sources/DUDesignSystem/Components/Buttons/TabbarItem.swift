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
    public var action: () -> Void

    @GestureState private var isPressed: Bool = false

    public init(
        assetName: String,
        text: String,
        state: TabbarItemState = .default,
        action: @escaping () -> Void
    ) {
        self.assetName = assetName
        self.text = text
        self.state = state
        self.action = action
    }

    private var backgroundColor: Color {
        state == .selected ? Color.orange300 : Color.beige300
    }

    private var labelColor: ItemLabel.LabelColor {
        state == .selected ? .white : .black
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.none) {
            Image(assetName, bundle: .module)
                .resizable()
                .frame(width: TokenIconSize.size24.rawValue, height: TokenIconSize.size24.rawValue)
            ItemLabel(text: text, icon: nil, size: .small, color: labelColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4.5)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xs))
        .tokenShadow(.default)
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in state = true }
                .onEnded { _ in action() }
        )
    }
}
