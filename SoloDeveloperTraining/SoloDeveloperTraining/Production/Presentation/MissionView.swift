//
//  MissionView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/21/26.
//

import SwiftUI
import DUDesignSystem

struct MissionView: View {
    private let user: User
    private let missionSystem: MissionSystem

    init(user: User) {
        self.user = user
        self.missionSystem = user.record.missionSystem
    }

    var body: some View {
        VStack(spacing: TokenSpacing.md) {
            ZStack {
                DUDesignSystem.ProgressBar(
                    progress: missionSystem.allCount > 0 ? Double(missionSystem.claimedCount) / Double(missionSystem.allCount) : 0
                )
                ItemLabel(text: "\(missionSystem.claimedCount) / \(missionSystem.allCount)", font: .caption, color: .black300)
            }
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: TokenSpacing.xs), count: 3),
                    spacing: TokenSpacing.md
                ) {
                    ForEach(missionSystem.missions, id: \.id) { mission in
                        MissionCard(
                            title: mission.title,
                            goldRewardText: mission.reward.gold > 0 ? mission.reward.gold.formatted : nil,
                            diamondRewardText: mission.reward.diamond > 0 ? mission.reward.diamond.formatted : nil,
                            trophy: mission.type.level.trophyType,
                            condition: mission.description,
                            state: mission.missionCardState.missionCardState,
                            action: { missionCardDidTapHandler(mission: mission) }
                        )
                    }
                }
                .padding(.bottom, TokenGrid.paddingBottom)
            }
            .scrollIndicators(.never)
        }
        .analyticsScreen(.mission)
        .padding(.horizontal, TokenGrid.paddingSide)
    }
}

private extension MissionView {
    func missionCardDidTapHandler(mission: Mission) {
        if mission.missionCardState == .claimable {
            missionSystem.claimMissionReward(mission: mission, wallet: user.wallet, record: user.record)
            SoundService.shared.trigger(.mission)
            let reward = mission.reward
            if reward.gold > 0 && reward.diamond > 0 {
                ToastManager.shared.show("미션을 달성했습니다.\n보상: \(reward.gold.formatted) 골드, \(reward.diamond.formatted) 다이아")
            } else if reward.gold > 0 {
                ToastManager.shared.show("미션을 달성했습니다.\n보상: \(reward.gold.formatted) 골드")
            } else {
                ToastManager.shared.show("미션을 달성했습니다.\n보상: \(reward.diamond.formatted) 다이아")
            }
        } else {
            let message = mission.missionCardState == .claimed ? "이미 보유한 미션입니다." : "아직 달성하지 못한 미션입니다."
            ToastManager.shared.show(message)
        }
    }
}
