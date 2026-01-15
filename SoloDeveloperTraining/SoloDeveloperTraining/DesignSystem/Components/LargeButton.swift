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

struct LargeButton: View {
    @State private var isPressed: Bool = false

    let title: String
    var hasBadge: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.body)
                .foregroundColor(.white)
                .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
                .background(isEnabled ? .orange500 : .gray200)
                .cornerRadius(Constant.radius)
                .opacity(isPressed ? Constant.Opacity.pressed : Constant.Opacity.unPressed)
                .overlay(alignment: .topTrailing) {
                    if hasBadge { badge }
                }
        }
        .disabled(!isEnabled)
        .buttonStyle(.pressable(isPressed: $isPressed))
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
        LargeButton(title: "버튼 텍스트") {
            print("버튼 클릭1")
        }

        LargeButton(title: "버튼 텍스트", isEnabled: false) {
            print("버튼 클릭2")
        }

        LargeButton(title: "버튼 텍스트", hasBadge: true, isEnabled: false) {
            print("버튼 클릭3")
        }

        LargeButton(title: "버튼 텍스트", hasBadge: true) {
            print("버튼 클릭4")
        }
    }
}
