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
    static let cornerRadius: CGFloat = 5
    static let buttonHeight: CGFloat = 44
    static let iconSize = CGSize(width: 15, height: 15)
    static let lockIconSize = CGSize(width: 18, height: 18)
    static let contentSpacing: CGFloat = 3
    static let disabledOverlayOpacity: Double = 0.9
    static let horizontalPadding: CGFloat = 8
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
                .overlay {
                    if isDisabled {
                        disabledOverlay
                    }
                }
                .background(
                    // 그림자 (버튼과 같은 크기, 라운드 5)
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .foregroundStyle(isDisabled ? .gray400 : .black)
                        .offset(
                            x: Constant.shadowOffsetX,
                            y: Constant.shadowOffsetY
                        )
                )
        }
        .buttonStyle(.pressable(isPressed: $isPressed))
        .disabled(isDisabled)
    }

    @ViewBuilder
    var buttonContent: some View {
        Group {
            if axis == .horizontal {
                HStack(spacing: Constant.contentSpacing) {
                    contentViews
                }
            } else {
                VStack(spacing: Constant.contentSpacing) {
                    contentViews
                }
            }
        }
        .frame(height: Constant.buttonHeight)
        .padding(.horizontal, Constant.horizontalPadding)
        .background(.orange500)
        .clipShape(RoundedRectangle(cornerRadius: Constant.cornerRadius))
        .offset(
            x: isPressed ? Constant.shadowOffsetX : 0,
            y: isPressed ? Constant.shadowOffsetY : 0
        )
        .animation(.none, value: isPressed)
    }

    @ViewBuilder
    var contentViews: some View {
        Image("icon_coin_bag")
            .frame(
                width: Constant.iconSize.width,
                height: Constant.iconSize.height
            )
        Text(gold.formatted())
            .foregroundStyle(.white)
            .textStyle(.caption)
    }

    var disabledOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .foregroundStyle(Color.gray200.opacity(Constant.disabledOverlayOpacity))

            Image("lock")
                .resizable()
                .frame(
                    width: Constant.lockIconSize.width,
                    height: Constant.lockIconSize.height
                )
        }
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
