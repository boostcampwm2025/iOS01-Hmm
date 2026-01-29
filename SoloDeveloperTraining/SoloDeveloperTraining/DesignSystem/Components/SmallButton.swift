//
//  SmallButton.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-14.
//

import SwiftUI

private enum Constant {
    static let radius: CGFloat = 8

    enum Size {
        static let buttonWidth: CGFloat = 44
        static let buttonHeight: CGFloat = 44
        static let badgeWidth: CGFloat = 30
        static let badgeHeight: CGFloat = 30
    }

    enum Offset {
        static let badgeOffsetX: CGFloat = 17
        static let badgeOffsetY: CGFloat = -15
        static let pressedX: CGFloat = 2
        static let pressedY: CGFloat = 3
        static let shadowX: CGFloat = 2
        static let shadowY: CGFloat = 3
    }

    enum Opacity {
        static let pressed: Double = 0.8
        static let unPressed: Double = 1.0
    }
}

struct SmallButton: View {
    @State private var isPressed: Bool = false

    let title: String
    var image: Image?
    var hasBadge: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                buttonContent
                    .opacity(isPressed ? Constant.Opacity.pressed : Constant.Opacity.unPressed)
                    .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
                    .background(backgroundColor)
                    .cornerRadius(Constant.radius)
                    .overlay(alignment: .topTrailing) {
                        if hasBadge { badge }
                    }
                    .offset(
                        x: isPressed ? Constant.Offset.pressedX : 0,
                        y: isPressed ? Constant.Offset.pressedY : 0
                    )
                    .layoutPriority(1)

                    Rectangle()
                        .fill(Color.black)
                        .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
                        .cornerRadius(Constant.radius)
                        .offset(x: Constant.Offset.shadowX, y: Constant.Offset.shadowY)
                        .zIndex(-1)
            }
        }
        .disabled(!isEnabled)
        .buttonStyle(.pressable(isPressed: $isPressed))

    }

    @ViewBuilder
    private var buttonContent: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
                .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
                .contentShape(Rectangle())
        } else {
            Text(title)
                .textStyle(.body)
                .foregroundColor(.white)
        }
    }

    private var backgroundColor: Color {
        if image != nil {
            return .clear
        }
        if !isEnabled {
            return .gray200
        }
        return hasBadge ? AppColors.lightOrange : .orange500
    }

    private var badge: some View {
        Image(.iconDiamondPlus)
            .resizable()
            .frame(width: Constant.Size.badgeWidth, height: Constant.Size.badgeHeight)
            .offset(x: Constant.Offset.badgeOffsetX, y: Constant.Offset.badgeOffsetY)
    }
}

#Preview {
    VStack(spacing: 20) {
        SmallButton(title: "버튼") {
            print("버튼 클릭1")
        }

        SmallButton(title: "버튼", isEnabled: false) {
            print("버튼 클릭2")
        }

        SmallButton(title: "버튼", hasBadge: true, isEnabled: false) {
            print("버튼 클릭3")
        }

        SmallButton(title: "버튼", hasBadge: true) {
            print("버튼 클릭4")
        }
        SmallButton(title: "버튼", image: Image(.iconSetting)) {
            print("버튼 클릭4")
        }
    }
}
