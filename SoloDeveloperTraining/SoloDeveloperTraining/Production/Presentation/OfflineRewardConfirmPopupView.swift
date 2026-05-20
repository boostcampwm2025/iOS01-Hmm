//
//  OfflineRewardConfirmPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/20/26.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let content: CGFloat = 11
    }

    enum Padding {
        static let messageHorizontal: CGFloat = 20
        static let messageBottom: CGFloat = 50
    }
}

struct OfflineRewardConfirmPopupView: View {
    let gold: Int
    let onConfirm: () -> Void

    var body: some View {
        Popup(title: "보상 지급 완료!") {
            VStack(spacing: Constant.Spacing.content) {
                Text(rewardMessage)
                    .textStyle(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal, Constant.Padding.messageHorizontal)
                    .padding(.bottom, Constant.Padding.messageBottom)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Spacer()
                    MediumButton(title: "확인", isFilled: true) {
                        onConfirm()
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var rewardMessage: String {
        let formattedGold = formatNumber(gold)
        return "💰 골드 \(formattedGold)를 받았습니다!"
    }

    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

#Preview {
    VStack(spacing: 50) {
        // 적은 골드
        OfflineRewardConfirmPopupView(
            gold: 150000,
            onConfirm: { print("보상 확인") }
        )
        .padding(.horizontal, 40)

        // 많은 골드
        OfflineRewardConfirmPopupView(
            gold: 1234567890,
            onConfirm: { print("보상 확인") }
        )
        .padding(.horizontal, 40)
    }
    .background(Color.gray.opacity(0.3))
}
