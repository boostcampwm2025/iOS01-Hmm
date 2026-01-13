//
//  EffectLabel.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/13/26.
//

import SwiftUI

private enum Constant {
    enum Size {
        static let icon = CGSize(width: 18, height: 18)
    }

    enum Spacing {
        static let horizontal: CGFloat = 3
    }
}

struct EffectLabel: View {
    let value: Int

    private var isZero: Bool {
        value == 0
    }

    private var isIncrease: Bool {
        value > 0
    }

    private var color: Color {
        isZero || isIncrease ? .lightGreen : .accentRed
    }

    var body: some View {
        HStack(spacing: Constant.Spacing.horizontal) {

            // 값이 0이 아닐 경우에만 표시합니다.
            if !isZero {
                Image(isIncrease ? .iconPlus : .iconMinus)
                    .resizable()
                    .frame(
                        width: Constant.Size.icon.width,
                        height: Constant.Size.icon.height
                    )
                    .foregroundStyle(color)
            }

            Image(.iconCoinStack)
                .resizable()
                .frame(
                    width: Constant.Size.icon.width,
                    height: Constant.Size.icon.height
                )

            Text(abs(value).formatted())
                .textStyle(.subheadline)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    EffectLabel(value: 10000)
    EffectLabel(value: -200000)
    EffectLabel(value: 0)
}
