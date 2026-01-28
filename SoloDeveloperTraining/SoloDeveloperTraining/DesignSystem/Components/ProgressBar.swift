//
//  ProgressBar.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-14.
//

import SwiftUI

private enum Constants {
    static let height: CGFloat = 20
}

struct ProgressBar: View {
    let maxValue: Double
    let currentValue: Double
    let text: String

    private var progress: Double {
        return currentValue / maxValue
    }

    var body: some View {
        ZStack {
            // 배경
            Rectangle()
                .fill(.beige300)

            // 진행 바
            Rectangle()
                .fill(.orange300)
                .scaleEffect(x: progress, y: 1, anchor: .leading)

            Text(text)
                .textStyle(.caption)
                .foregroundColor(.black)
        }
        .frame(height: Constants.height)
    }
}

#Preview {
    ProgressBar(maxValue: 60, currentValue: 10, text: "10 s")
    ProgressBar(maxValue: 60, currentValue: 30, text: "30 s")
    ProgressBar(maxValue: 60, currentValue: 40, text: "40 s")
    ProgressBar(maxValue: 60, currentValue: 59, text: "59 s")
    ProgressBar(maxValue: 60, currentValue: 60, text: "제한 시간 종료")
}
