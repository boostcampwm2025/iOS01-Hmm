//
//  MediumButton.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-14.
//

import SwiftUI

private enum Constant {
    static let radius: CGFloat = 8

    enum Size {
        static let buttonWidth: CGFloat = 89
        static let buttonHeight: CGFloat = 44
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

struct MediumButton: View {
    @State private var isPressed: Bool = false

    let title: String
    var isFilled: Bool = false
    var hasBadge: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.caption)
                .foregroundColor(isFilled ? .white : .black)
                .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
                .background(backgroundColor)
                .cornerRadius(Constant.radius)
                .opacity(isPressed ? Constant.Opacity.pressed : Constant.Opacity.unPressed)
                .overlay {
                    if !isFilled {
                        RoundedRectangle(cornerRadius: Constant.radius)
                            .stroke()
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if hasBadge { badge }
                }
        }
        .disabled(!isEnabled)
        .buttonStyle(.pressable(isPressed: $isPressed))
    }

    private var backgroundColor: Color {
        if !isEnabled {
            return isFilled ? .gray200 : .white
        }
        return isFilled ? .orange500 : .white
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
        MediumButton(title: "버튼 텍스트", isFilled: true) {
            print("버튼 클릭1")
        }

        MediumButton(title: "버튼 텍스트", isFilled: true, isEnabled: false) {
            print("버튼 클릭2")
        }

        MediumButton(title: "버튼 텍스트", isFilled: true, hasBadge: true) {
            print("버튼 클릭3")
        }

        MediumButton(title: "버튼 텍스트", isFilled: true, hasBadge: true, isEnabled: false) {
            print("버튼 클릭4")
        }

        MediumButton(title: "버튼 텍스트", isFilled: false) {
            print("버튼 클릭5")
        }

        MediumButton(title: "버튼 텍스트", isFilled: false, hasBadge: true) {
            print("버튼 클릭6")
        }
    }
}
