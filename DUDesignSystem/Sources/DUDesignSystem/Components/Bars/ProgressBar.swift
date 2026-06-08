//
//  ProgressBar.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct ProgressBar: View {

    public enum ProgressBarType {
        case `default`
        case career(
            currentText: String,
            currentSubText: String,
            goalText: String,
            goalSubText: String
        )
        case mission(
            current: Int,
            total: Int
        )
        case time(
            currentStep: Int,
            totalStep: Int,
            timeText: String
        )
    }

    public var progress: Double
    public var type: ProgressBarType

    public init(progress: Double, type: ProgressBarType = .default) {
        self.progress = max(0, min(1, progress))
        self.type = type
    }

    private var bar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(Color.black300.opacity(0.1))
                    .frame(height: 16)

                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(Color.orange300)
                    .frame(width: geo.size.width * progress, height: 16)
            }
        }
        .frame(height: 16)
    }

    private var missionBar: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(Color.black300.opacity(0.1))
                    .frame(height: 16)

                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(Color.orange300)
                    .frame(width: geo.size.width * progress, height: 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if case .mission(let current, let total) = type {
                    Text("\(current)/\(total)")
                        .duFont(.caption)
                        .foregroundStyle(Color.black300)
                }
            }
        }
        .frame(height: 16)
    }

    public var body: some View {
        switch type {
        case .default:
            bar

        case .career(let currentText, let currentSubText, let goalText, let goalSubText):
            VStack(spacing: TokenSpacing.xs) {
                bar
                VStack(spacing: 1) {
                    HStack {
                        ItemLabel(text: currentText, icon: .coinBag, size: .small, color: .black)
                        Spacer()
                        ItemLabel(text: goalText, icon: .coinBag, size: .small, color: .black)
                    }
                    HStack {
                        Text(currentSubText)
                            .duFont(.caption)
                            .foregroundStyle(Color.black300)
                        Spacer()
                        Text(goalSubText)
                            .duFont(.caption)
                            .foregroundStyle(Color.black300)
                    }
                }
            }

        case .mission:
            missionBar

        case .time(let currentStep, let totalStep, let timeText):
            VStack(spacing: TokenSpacing.xs) {
                HStack {
                    Text("\(currentStep) / \(totalStep)")
                        .duFont(.caption)
                        .foregroundStyle(Color.black300)
                    Spacer()
                    Text(timeText)
                        .duFont(.caption)
                        .foregroundStyle(Color.black300)
                }
                bar
            }
        }
    }
}

#Preview {
    VStack(spacing: TokenSpacing.lg) {
        ProgressBar(progress: 0.6)

        ProgressBar(progress: 0.4, type: .career(
            currentText: "20,000",
            currentSubText: "누적",
            goalText: "20,000",
            goalSubText: "개발자 지망생"
        ))

        ProgressBar(progress: 0.9, type: .mission(current: 9, total: 10))

        ProgressBar(progress: 0.3, type: .time(currentStep: 1, totalStep: 3, timeText: "남은 시간 30s"))
        ProgressBar(progress: 0, type: .time(currentStep: 1, totalStep: 3, timeText: "제한시간종료"))
    }
    .padding(TokenSpacing.lg)
    .background(Color.beige200)
}
