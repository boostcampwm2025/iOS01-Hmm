//
//  StatusBar.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI

struct StatusBar: View {
    let career: Career
    let nickname: String
    let careerProgress: Double
    let gold: Int
    let diamond: Int

    var body: some View {
        HStack(spacing: 16) {
            // 왼쪽: 프로필 + 커리어 + 진행바
            HStack(spacing: 6) {
                Image(career.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 4))

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(career.rawValue) \(nickname)")
                        .textStyle(.caption)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    ProgressBarView(progress: careerProgress)
                }
            }

            Spacer()

            // 오른쪽: 재산 + 다이아
            HStack(spacing: 12) {
                CurrencyLabel(axis: .horizontal, icon: .gold, value: gold)

                CurrencyLabel(axis: .horizontal, icon: .diamond, value: diamond)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.clear)
    }
}

private struct ProgressBarView: View {
    let progress: Double
    let height: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray200)
                    .frame(height: height)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lightOrange)
                    .frame(width: geometry.size.width * progress, height: height)
            }
        }
        .frame(width: 129, height: height)
    }
}

#Preview("Status Bar") {
    StatusBar(
        career: .laptopOwner,
        nickname: "소피아",
        careerProgress: 0.42,
        gold: 1234,
        diamond: 56
    )
}
