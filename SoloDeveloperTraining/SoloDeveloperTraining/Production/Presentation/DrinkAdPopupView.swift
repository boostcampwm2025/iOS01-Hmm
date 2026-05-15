//
//  DrinkAdPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/11/26.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let content: CGFloat = 11
        static let buttonHorizontal: CGFloat = 15
    }

    enum Padding {
        static let messageHorizontal: CGFloat = 20
        static let messageBottom: CGFloat = 50
    }
}

struct DrinkAdPopupView: View {
    let drinkType: ConsumableType
    let onWatchAd: () -> Void
    let onSkip: () -> Void

    var body: some View {
        Popup(title: popupTitle) {
            VStack(spacing: Constant.Spacing.content) {
                Text(popupMessage)
                    .textStyle(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal, Constant.Padding.messageHorizontal)
                    .padding(.bottom, Constant.Padding.messageBottom)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: Constant.Spacing.buttonHorizontal) {
                    MediumButton(title: "음료 받기(AD)", isFilled: true) {
                        onWatchAd()
                    }

                    MediumButton(title: "그냥 하기", isFilled: true) {
                        onSkip()
                    }
                }
            }
        }
    }

    private var popupTitle: String {
        switch drinkType {
        case .coffee:
            return "커피가 없다!"
        case .energyDrink:
            return "박하스가 없다!"
        }
    }

    private var popupMessage: String {
        let drinkName = drinkType == .coffee ? "커피" : "박하스"
        return "\(drinkName)가 더 떨어졌습니다!\n대신에 광고를 보고 카페인 수혈할까요?"
    }
}

#Preview {
    VStack(spacing: 50) {
        // 커피 팝업
        DrinkAdPopupView(
            drinkType: .coffee,
            onWatchAd: { print("커피 광고 시청") },
            onSkip: { print("커피 스킵") }
        )
        .padding(.horizontal, 40)

        // 박하스 팝업
        DrinkAdPopupView(
            drinkType: .energyDrink,
            onWatchAd: { print("박하스 광고 시청") },
            onSkip: { print("박하스 스킵") }
        )
        .padding(.horizontal, 40)
    }
    .background(Color.gray.opacity(0.3))
}
