//
//  OfflineRewardPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/20/26.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let content: CGFloat = 11
        static let buttonSpacing: CGFloat = 10
    }

    enum Padding {
        static let messageHorizontal: CGFloat = 20
        static let messageBottom: CGFloat = 50
    }
}

struct OfflineRewardPopupView: View {
    let gold: Int
    let hoursElapsed: Double
    let onWatchAd: () -> Void
    let onSkip: () -> Void

    var body: some View {
        Popup(title: "보상 획득") {
            VStack(spacing: Constant.Spacing.content) {
                Text(rewardMessage)
                    .textStyle(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal, Constant.Padding.messageHorizontal)
                    .padding(.bottom, Constant.Padding.messageBottom)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: Constant.Spacing.buttonSpacing) {
                    MediumButton(title: "보상받기(AD)", isFilled: true) {
                        onWatchAd()
                    }

                    MediumButton(title: "안 받기", isFilled: true) {
                        onSkip()
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var rewardMessage: String {
        return "당신이 없는 동안 '발발이'가 일을 했습니다.\n일한 보상을 받을까요?"
    }
}

#Preview {
    VStack(spacing: 50) {
        // 3시간 접속 안함
        OfflineRewardPopupView(
            gold: 10000,
            hoursElapsed: 3.2,
            onWatchAd: { print("광고 보고 보상 받기") },
            onSkip: { print("보상 건너뛰기") }
        )
        .padding(.horizontal, 40)

        // 10시간 접속 안함
        OfflineRewardPopupView(
            gold: 1234567,
            hoursElapsed: 10.5,
            onWatchAd: { print("광고 보고 보상 받기") },
            onSkip: { print("보상 건너뛰기") }
        )
        .padding(.horizontal, 40)
    }
    .background(Color.gray.opacity(0.3))
}
