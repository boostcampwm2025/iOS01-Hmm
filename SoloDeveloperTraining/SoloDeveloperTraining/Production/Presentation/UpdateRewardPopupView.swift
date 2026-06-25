//
//  UpdateRewardPopupView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/25/26.
//

import SwiftUI
import DUDesignSystem

struct UpdateRewardPopupView: View {
    let userType: RewardUserType
    let rewards: [UpdateReward]
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: TokenSpacing.xxl) {
            VStack(spacing: TokenSpacing.lg) {
                ItemLabel(text: "업데이트 보상", font: .title2, color: .black300)
                ScrollView {
                    VStack(spacing: TokenSpacing.xxl) {
                        ItemLabel(text: """
                                  더 나은 서비스 제공을 위해\n개발자 키우기가 업데이트되었습니다.\n\n
                                  이번 업데이트로 게임이 처음부터 새롭게 시작됩니다.
                                  더 풍성한 콘텐츠와 함께 최고의 개발자를
                                  키워나갈 수 있도록 준비했습니다.\n\n
                                  함께해 주신 여정에 감사드리며,
                                  이전 레벨에 따라 특별 보상을 드립니다.
                                  """, font: .body, color: .black300)
                        rewardInfoList
                    }
                }
                .frame(height: 384)
                .scrollIndicators(.never)
            }
            TextButton(
                text: "보상 받기",
                type: .primary,
                size: .medium,
                action: onClose
            )
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

extension RewardUserType {
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
    UpdateRewardPopupView(userType: .newUser, rewards: [], onClose: {})
}
