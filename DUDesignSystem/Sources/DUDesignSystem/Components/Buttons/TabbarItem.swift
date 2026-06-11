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

    private var labelColor: Color {
        state == .selected ? .white300 : .black300
    }
    // 색상 수정 필요 brown임 ㅇㅇ

    public var body: some View {
        VStack(spacing: TokenSpacing.none) {
            Image(assetName, bundle: .module)
                .resizable()
                .frame(width: TokenIconSize.size24.rawValue, height: TokenIconSize.size24.rawValue)
            //token 24 사용 말고 24로 고정 상수 사용
            ItemLabel(text: text, font: .caption, color: labelColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4.5)
        // padding 4로 수정 -> xs
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xs))
        .tokenShadow(isPressed ? .none : .default)
        .offset(
            x: isPressed ? TokenShadow.default.x : 0,
            y: isPressed ? TokenShadow.default.y : 0
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in state = true }
                .onEnded { _ in action() }
        )
        // 누르는 모션 제거
        .animation(nil, value: isPressed)
    }
}
