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
    let current: Career
    let currentGold: Int

    var progress: CGFloat {
        Double(currentGold) / Double(current.nextCareer?.requiredWealth ?? 1)
    }

    var body: some View {
        VStack(spacing: Constants.Spacing.vertical ) {
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
                        value: currentGold
                    )
                }
                Spacer()
                VStack(
                    alignment: .trailing,
                    spacing: Constants.Spacing.trailingLabelSpacing
                ) {
                    Text(current.nextCareer?.rawValue ?? "").textStyle(.caption)
                    CurrencyLabel(
                        axis: .horizontal,
                        icon: .gold,
                        textStyle: .caption,
                        value: current.nextCareer?.requiredWealth ?? 0
                    )
                }
            }
        }.padding()
    }
}

#Preview {
    CareerProgressBar(current: .unemployed, currentGold: 0)
    CareerProgressBar(current: .laptopOwner, currentGold: 1200)
    CareerProgressBar(current: .aspiringDeveloper, currentGold: 1800)
}
