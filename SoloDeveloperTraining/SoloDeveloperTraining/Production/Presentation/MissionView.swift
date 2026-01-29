//
//  MissionView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/21/26.
//

import SwiftUI

private enum Constant {
    static let vertical: CGFloat = 15
    static let gridVeticalSpacing: CGFloat = 14
    static let minWidth: CGFloat = 115
}

struct MissionView: View {
    private let user: User
    private let missionSystem: MissionSystem

    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    init(user: User) {
        self.user = user
        self.missionSystem = user.record.missionSystem
    }

    var body: some View {
        VStack(spacing: Constant.vertical) {
            ProgressBar(
                maxValue: Double(missionSystem.allCount),
                currentValue: Double(missionSystem.claimedCount),
                text: "\(missionSystem.claimedCount) / \(missionSystem.allCount)"
            )
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: Constant.minWidth))],
                    spacing: Constant.gridVeticalSpacing
                ) {
                    ForEach(missionSystem.missions, id: \.id) { mission in
                        MissionCard(
                            title: mission.title,
                            reward: mission.reward,
                            imageName: mission.type.level.imageName,
                            condition: mission.description,
                            buttonState: toButtonState(
                                missionCardState: mission
                                    .missionCardState),
                            onButtonTap: {
                                missionCardDidTapHandler(
                                    mission: mission
                                )
                            }
                        )
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .padding(.horizontal)
        .toast(isShowing: $showToast, message: toastMessage)

    }
}

private extension MissionView {
    func toButtonState(missionCardState: MissionCardState) -> MissionCardButton.ButtonState {
        switch missionCardState {
        case .claimed:
                .claimed
        case .claimable:
                .claimable
        case .inProgress(let currentValue, let totalValue):
                .inProgress(currentValue: currentValue, totalValue: totalValue)
        }
    }

    func missionCardDidTapHandler(mission: Mission) {
        if mission.missionCardState == .claimable {
            missionSystem.claimMissionReward(mission: mission, wallet: user.wallet)
            SoundService.shared.trigger(.missionAcquired)
            showToast = false
            let reward = mission.reward
            if reward.gold > 0 && reward.diamond > 0 {
                toastMessage = "미션을 달성했습니다.\n보상: \(reward.gold.formatted) 골드, \(reward.diamond.formatted) 다이아"
            } else if reward.gold > 0 {
                toastMessage = "미션을 달성했습니다.\n보상: \(reward.gold.formatted) 골드"
            } else {
                toastMessage = "미션을 달성했습니다.\n보상: \(reward.diamond.formatted) 다이아"
            }
            showToast = true
        } else {
            showToast = false
            toastMessage = mission.missionCardState == .claimed ? "이미 보유한 미션입니다." : "아직 달성하지 못한 미션입니다."
            showToast = true
        }
    }
}
