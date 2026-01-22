//
//  MissionCard.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let defaultImageName: String = "mission_card"
    static let cardColor = AppColors.orange100

    enum Size {
        static let icon: CGFloat = 16
        static let cardHeight: CGFloat = 180
        static let imageHeight: CGFloat = 72
        static let progressHeight: CGFloat = 14
    }

    enum Padding {
        static let horizontal: CGFloat = 10
        static let titleTop: CGFloat = 5
        static let rewardTop: CGFloat = 4
        static let imageTop: CGFloat = 4
        static let conditionTop: CGFloat = 4
        static let bottom: CGFloat = 6
    }

    enum Spacing {
        static let rewardIconText: CGFloat = 2
    }

    enum Typography {
        static let titleLineLimit: Int = 1
        static let conditionLineLimit: Int = 2
        static let minimumScaleFactor: CGFloat = 0.7
    }
}

struct MissionCard: View {
    let title: String
    let reward: Int
    let imageName: String
    let condition: String
    let buttonState: MissionCardButton.ButtonState?
    let currentValue: Int?
    let totalValue: Int?
    var onButtonTap: (() -> Void)?

    init(
        title: String,
        reward: Int,
        imageName: String = Constant.defaultImageName,
        condition: String,
        buttonState: MissionCardButton.ButtonState? = nil,
        currentValue: Int? = nil,
        totalValue: Int? = nil,
        onButtonTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.reward = reward
        self.imageName = imageName
        self.condition = condition
        self.buttonState = buttonState
        self.currentValue = currentValue
        self.totalValue = totalValue
        self.onButtonTap = onButtonTap
    }

    var body: some View {
        MissionCardContentView(
            title: title,
            reward: reward,
            imageName: imageName,
            condition: condition,
            buttonState: buttonState,
            currentValue: currentValue,
            totalValue: totalValue,
            onButtonTap: onButtonTap
        )
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.top, Constant.Padding.titleTop)
        .padding(.bottom, Constant.Padding.bottom)
        .frame(height: Constant.Size.cardHeight)
        .background { Rectangle().fill(Constant.cardColor) }
    }
}

private struct MissionCardContentView: View {
    let title: String
    let reward: Int
    let imageName: String
    let condition: String
    let buttonState: MissionCardButton.ButtonState?
    let currentValue: Int?
    let totalValue: Int?
    var onButtonTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // 타이틀과 보상 (왼쪽 정렬)
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .textStyle(.subheadline)
                    .foregroundStyle(.black)
                    .lineLimit(Constant.Typography.titleLineLimit)
                    .minimumScaleFactor(Constant.Typography.minimumScaleFactor)
                HStack(spacing: Constant.Spacing.rewardIconText) {
                    Image(.iconDiamondGreen)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constant.Size.icon, height: Constant.Size.icon)
                    Text(reward.formatted)
                        .textStyle(.label)
                        .foregroundStyle(.black)
                }
                .padding(.top, Constant.Padding.rewardTop)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // 이미지 (가운데 정렬)
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: Constant.Size.imageHeight)
                .frame(maxWidth: .infinity)
                .clipped()
                .padding(.top, Constant.Padding.imageTop)

            // 보상 조건 (가운데 정렬)
            Text(condition)
                .textStyle(.label)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.top, Constant.Padding.conditionTop)
                .lineLimit(Constant.Typography.conditionLineLimit)
                .minimumScaleFactor(Constant.Typography.minimumScaleFactor)

            Spacer()

            // MissionCardButton (가운데 정렬)
            if let buttonState = buttonState {
                MissionCardButton(buttonState: buttonState) {
                    onButtonTap?()
                }
            }
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        MissionCard(
            title: "탭따구리",
            reward: 15,
            condition: "탭 10,000회 달성",
            buttonState: .claimable,
            onButtonTap: {
                print("미션 1 보상 획득")
            }
        )

        MissionCard(
            title: "정상이라는 착각",
            reward: 15,
            condition: "버그 피하기 1000회달성",
            buttonState: .claimed
        )

        MissionCard(
            title: "명탐정의 돋보기",
            reward: 15,
            imageName: "housing_street",
            condition: "탭 10,000회 달성",
            buttonState: .inProgress(currentValue: 7356, totalValue: 10000)
        )
    }
    .padding()
}
