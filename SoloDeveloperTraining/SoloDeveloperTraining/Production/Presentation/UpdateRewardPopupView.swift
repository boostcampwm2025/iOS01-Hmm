//
//  UpdateRewardPopupView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/25/26.
//

import SwiftUI
import DUDesignSystem

struct UpdateReward {
    let userType: RewardUserType
    let rewards: [Reward]
}

enum RewardUserType {
    case newUser
    case originUser(Career)

    var title: String {
        switch self {
        case .newUser: return "신규 유저"
        case .originUser(let career): return career.rawValue
        }
    }

    var imagePrefix: String {
        switch self {
        case .newUser: return "profileNewUser"
        case .originUser(let career): return career.imageName
        }
    }
}

struct UpdateRewardPopupView: View {
    private let rewards: [UpdateReward] = [
        .init(userType: .newUser, rewards: [.diamond(15)]),
        .init(userType: .originUser(.unemployed), rewards: [.diamond(30)]),
        .init(
            userType: .originUser(.laptopOwner),
            rewards: [.diamond(30), .consumable(.coffee, count: 3)]
        ),
        .init(
            userType: .originUser(.aspiringDeveloper),
            rewards: [
                .diamond(90),
                .consumable(.coffee, count: 6),
                .consumable(.energyDrink, count: 1)
            ]),
        .init(userType: .originUser(.juniorDeveloper),
              rewards: [
                .diamond(120),
                .consumable(.coffee, count: 10),
                .consumable(.energyDrink, count: 2)
              ]),
        .init(userType: .originUser(.normalDeveloper),
              rewards: [
                .diamond(150),
                .consumable(.coffee, count: 15),
                .consumable(.energyDrink, count: 7)
              ]),
        .init(userType: .originUser(.nightOwlDeveloper),
              rewards: [
                .diamond(180),
                .consumable(.coffee, count: 18),
                .consumable(.energyDrink, count: 12)
              ]),
        .init(userType: .originUser(.skilledDeveloper),
              rewards: [
                .diamond(210),
                .consumable(.coffee, count: 21),
                .consumable(.energyDrink, count: 17)
              ]),
        .init(userType: .originUser(.famousDeveloper),
              rewards: [
                .diamond(240),
                .consumable(.coffee, count: 24),
                .consumable(.energyDrink, count: 22)
              ]),
        .init(userType: .originUser(.allRounderDeveloper),
              rewards: [
                .diamond(270),
                .consumable(.coffee, count: 27),
                .consumable(.energyDrink, count: 27)
              ]),
        .init(userType: .originUser(.worldClassDeveloper),
              rewards: [
                .diamond(300),
                .consumable(.coffee, count: 30),
                .consumable(.energyDrink, count: 30)
              ])
    ]

    var body: some View {
        ZStack {
            Color.black300PopUpDimStatusBar
            popup
        }
    }

    private var popup: some View {
        VStack(spacing: TokenSpacing.xxl) {
            VStack(spacing: TokenSpacing.lg) {
                ItemLabel(text: "업데이트 보상", font: .title2, color: .black300)
                ScrollView {
                    ItemLabel(text: """
                              더 나은 서비스 제공을 위해\n개발자 키우기가 업데이트되었습니다.\n\n
                              이번 업데이트로 게임이 처음부터 새롭게 시작됩니다.
                              더 풍성한 콘텐츠와 함께 최고의 개발자를
                              키워나갈 수 있도록 준비했습니다.\n\n
                              함께해 주신 여정에 감사드리며,
                              이전 레벨에 따라 특별 보상을 드립니다.
                              """, font: .body, color: .black300)
                    Spacer().frame(height: TokenSpacing.xxl)
                    rewardInfoList
                }
                .frame(height: 384)
                .scrollIndicators(.never)
            }
            TextButton(text: "닫기", type: .primary, size: .medium, action: {})
        }
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
    }

    private var rewardInfoList: some View {
        VStack(spacing: TokenSpacing.md) {
            ItemLabel(text: "보상 정보", font: .subheadline, color: .white300)
                .frame(height: 36)
                .frame(maxWidth: .infinity)
                .background(.orange500)
            ForEach(rewards.indices, id: \.self) { index in
                rewardInfoRow(rewards[index])
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, TokenSpacing.xs)
        .padding(.vertical, TokenSpacing.sm)
        .background(.beige100)
    }

    private func rewardInfoRow(_ updateReward: UpdateReward) -> some View {
        let rewards = updateReward.rewards
        return HStack(alignment: .center, spacing: TokenSpacing.sm) {
            Image.duImage(updateReward.userType.imagePrefix)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipped()

            VStack(alignment: .leading, spacing: TokenSpacing.xs) {
                ItemLabel(
                    text: updateReward.userType.title,
                    font: .subheadline,
                    color: .black300
                )

                HStack(spacing: TokenSpacing.md) {
                    ForEach(rewards.indices, id: \.self) { index in
                        let reward = rewards[index]
                        ItemLabel(
                            text: reward.countString,
                            icon: reward.icon,
                            iconSize: .size20,
                            font: .subheadline,
                            color: .black300
                        )
                    }
                }
            }
        }
    }
}

extension Reward {
    var countString: String {
        switch self {
        case .diamond(let count): return "\(count)"
        case .consumable(_, let count): return "\(count)"
        }
    }

    var icon: DUIconName {
        switch self {
        case .diamond: return .diamond
        case .consumable(let type, count: _):
            switch type {
            case .coffee: return .coffee
            case .energyDrink: return .energyDrink
            }
        }
    }
}

#Preview {
    UpdateRewardPopupView()
}
