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
    let maxValue: Int
    let currentValue: Int

    private var progress: Double {
        return Double(currentValue) / Double(maxValue)
    }
    private var isCompleted: Bool { progress == 1 }

    var body: some View {
        ZStack {
            // 배경
            Rectangle()
                .fill(.beige300)

            // 진행 바
            Rectangle()
                .fill(.orange300)
                .scaleEffect(x: progress, y: 1, anchor: .leading)

            Text(isCompleted ? "제한 시간 종료" : "\(currentValue) s")
                .textStyle(.caption2)
                .foregroundColor(.white)
        }
        .frame(height: Constants.height)
    }
}

#Preview {
    ProgressBar(maxValue: 60, currentValue: 10)
    ProgressBar(maxValue: 60, currentValue: 30)
    ProgressBar(maxValue: 60, currentValue: 40)
    ProgressBar(maxValue: 60, currentValue: 59)
    ProgressBar(maxValue: 60, currentValue: 60)
}
