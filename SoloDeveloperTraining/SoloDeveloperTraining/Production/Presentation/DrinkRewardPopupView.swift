//
//  DrinkRewardPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/11/26.
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

struct DrinkRewardPopupView: View {
    let drinkType: ConsumableType
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
        let drinkName = drinkType == .coffee ? "커피" : "박하스"
        return "\(drinkName) 1개를 받았습니다!"
    }
}

#Preview {
    VStack(spacing: 50) {
        // 커피 보상 팝업
        DrinkRewardPopupView(
            drinkType: .coffee,
            onConfirm: { print("커피 보상 확인") }
        )
        .padding(.horizontal, 40)

        // 박하스 보상 팝업
        DrinkRewardPopupView(
            drinkType: .energyDrink,
            onConfirm: { print("박하스 보상 확인") }
        )
        .padding(.horizontal, 40)
    }
    .background(Color.gray.opacity(0.3))
}
