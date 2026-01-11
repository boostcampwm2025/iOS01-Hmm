//
//  StatusBar.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/11/26.
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
                HStack(spacing: 4) {
                    Image("icon_coin_bag")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(gold.formatted())
                        .textStyle(.caption)
                }

                HStack(spacing: 4) {
                    Image("icon_diamond_green")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text(diamond.formatted())
                        .textStyle(.caption)
                }
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
                    .fill(Color("test_gray"))
                    .frame(height: height)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("test_blue"))
                    .frame(width: geometry.size.width * progress, height: height)
            }
        }
        .frame(width: 129, height: height)
    }
}
