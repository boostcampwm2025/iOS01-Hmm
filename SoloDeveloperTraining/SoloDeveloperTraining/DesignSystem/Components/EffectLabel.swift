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

    enum Animation {
        // 단계 별 애니메이션 지속 시간
        static let durationSec: Double = 1.5
        // 각 단계의 간격 시간
        static let sleepNanosec: UInt64 = 150_000_000
        // 각 단계에 따른 투명도, offsetY
        static let steps: [(Double, CGFloat)] = [
            (1.0,   0),
            (0.5,  -3),
            (0.2, -6),
            (0.1, -9),
            (0.0, -12)
        ]
    }
}

struct EffectLabel: View {
    let value: Int

    @State private var opacity: Double = 1.0
    @State private var offsetY: CGFloat = 0
    @State private var shouldShow = true

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
        if shouldShow {
            HStack(spacing: Constant.Spacing.horizontal) {
                if !isZero {
                    Image(isIncrease ? .iconPlus : .iconMinus)
                        .renderingMode(.template)
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
            .opacity(opacity)
            .offset(y: offsetY)
            .onAppear {
                runAnimation()
            }
        }
    }

    private func runAnimation() {
        Task {
            for (opacityValue, offsetValue) in Constant.Animation.steps {
                withAnimation(
                    .easeOut(duration: Constant.Animation.durationSec)
                ) {
                    opacity = opacityValue
                    offsetY = offsetValue
                }
                try? await Task
                    .sleep(nanoseconds: Constant.Animation.sleepNanosec)
            }
            shouldShow = false
        }
    }
}

#Preview {
    EffectLabel(value: 100000)
    EffectLabel(value: -200000)
    EffectLabel(value: 0)
}
