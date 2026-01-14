//
//  LargeButton.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-14.
//

import SwiftUI

private enum Constant {
    static let radius: CGFloat = 8

    enum Size {
        static let buttonWidth: CGFloat = 170
        static let buttonHeight: CGFloat = 46
        static let badgeWidth: CGFloat = 30
        static let badgeHeight: CGFloat = 30

    }

    enum Offset {
        static let badgeOffsetX: CGFloat = 17
        static let badgeOffsetY: CGFloat = -15
    }

    enum Opacity {
        static let pressed: Double = 0.8
        static let unPressed: Double = 1.0
    }
}

struct LargeButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    var hasBadge: Bool = false
    var backgroundColor: Color { isEnabled ? .orange500 : .gray200 }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.pfFont(.body))
            .foregroundColor(.white)
            .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
            .background(backgroundColor)
            .cornerRadius(Constant.radius)
            .opacity(configuration.isPressed ? Constant.Opacity.pressed : Constant.Opacity.unPressed)
            .overlay(alignment: .topTrailing) {
                if hasBadge { badge }
            }
    }

    private var badge: some View {
        Image(.iconDiamondPlus)
            .resizable()
            .frame(width: Constant.Size.badgeWidth, height: Constant.Size.badgeHeight)
            .offset(x: Constant.Offset.badgeOffsetX, y: Constant.Offset.badgeOffsetY)
    }
}

#Preview {
    Button("버튼 텍스트") {
        print("버튼 클릭1")
    }
    .buttonStyle(LargeButton(hasBadge: false))

    Button("버튼 텍스트") {
        print("버튼 클릭2")
    }
    .buttonStyle(LargeButton(hasBadge: false))
    .disabled(true)

    Button("버튼 텍스트") {
        print("버튼 클릭3")
    }
    .buttonStyle(LargeButton(hasBadge: true))
    .disabled(true)

    Button("버튼 텍스트") {
        print("버튼 클릭4")
    }
    .buttonStyle(LargeButton(hasBadge: true))
}
