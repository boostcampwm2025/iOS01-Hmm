//
//  CareerProgressBar.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/14/26.
//

import SwiftUI

private enum Constants {
    enum Size {
        static let barHeight: CGFloat = 22
    }

    enum Spacing {
        static let vertical: CGFloat = 4
        static let leadingLabelSpacing: CGFloat = 4
        static let trailingLabelSpacing: CGFloat = 4
    }
}

struct CareerProgressBar: View {
    let career: Career
    let totalEarnedMoney: Int
    let progress: Double

    var body: some View {
        VStack(spacing: Constants.Spacing.vertical) {
            ZStack {
                // 배경
                Rectangle()
                    .fill(.gray200)

                // 진행 바
                Rectangle()
                    .fill(.orange300)
                    .scaleEffect(x: progress, y: 1, anchor: .leading)
            }
            .frame(height: Constants.Size.barHeight)
            HStack(alignment: .top) {
                HStack(spacing: Constants.Spacing.leadingLabelSpacing) {
                    Text("누적").textStyle(.caption)
                    CurrencyLabel(
                        axis: .horizontal,
                        icon: .gold,
                        textStyle: .caption,
                        value: totalEarnedMoney
                    )
                }
                Spacer()
                VStack(
                    alignment: .trailing,
                    spacing: Constants.Spacing.trailingLabelSpacing
                ) {
                    Text(career.nextCareer?.rawValue ?? "").textStyle(.caption)
                    CurrencyLabel(
                        axis: .horizontal,
                        icon: .gold,
                        textStyle: .caption,
                        value: career.nextCareer?.requiredWealth ?? 0
                    )
                }
            }
        }
    }
}

#Preview {
    CareerProgressBar(
        career: .unemployed,
        totalEarnedMoney: 0,
        progress: 0.0
    )
    CareerProgressBar(
        career: .laptopOwner,
        totalEarnedMoney: 1200,
        progress: 0.4
    )
}
