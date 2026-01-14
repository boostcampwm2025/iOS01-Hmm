//
//  PriceButton.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/14/26.
//

import SwiftUI

private enum Constant {
    static let shadowOffsetX: CGFloat = 2
    static let shadowOffsetY: CGFloat = 3
    static let iconSize = CGSize(width: 15, height: 15)
    static let contentSpacing: CGFloat = 3

    enum Padding {
        static let horizontal: CGFloat = 8
        static let vertical: CGFloat = 13.5
    }
}

struct PriceButton: View {

    @State private var isPressed: Bool = false
    let gold: Int
    let isDisabled: Bool
    let axis: Axis

    var body: some View {
        Button {
            print("Tapped")
        } label: {
            buttonContent
                .background(
                    // 그림자 (버튼과 같은 크기)
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundStyle(.black)
                        .offset(
                            x: Constant.shadowOffsetX,
                            y: Constant.shadowOffsetY
                        )
                )
        }
        .buttonStyle(.pressable(isPressed: $isPressed))
        .disabled(isDisabled)
    }

    var buttonContent: some View {
        HStack(spacing: Constant.contentSpacing) {
            Image("icon_coin_bag")
                .frame(
                    width: Constant.iconSize.width,
                    height: Constant.iconSize.height
                )
            Text(gold.formatted())
                .foregroundStyle(.white)
                .textStyle(.caption)
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.vertical, Constant.Padding.vertical)
        .background(.orange500)
        .offset(
            x: isPressed ? Constant.shadowOffsetX : 0,
            y: isPressed ? Constant.shadowOffsetY : 0
        )
        .animation(.none, value: isPressed)
    }
}

#Preview {
    VStack(alignment: .center, spacing: 20) {
        PriceButton(gold: 1_000_000, isDisabled: false, axis: .horizontal)
        PriceButton(gold: 100_000, isDisabled: false, axis: .vertical)
        PriceButton(gold: 1_000_000_000, isDisabled: true, axis: .horizontal)
        PriceButton(gold: 1_000, isDisabled: true, axis: .vertical)
    }
}
