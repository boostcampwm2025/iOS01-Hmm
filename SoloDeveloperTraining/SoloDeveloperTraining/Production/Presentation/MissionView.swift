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
                                if mission.missionCardState == .claimable {
                                    missionSystem
                                        .claimMissionReward(
                                            mission: mission,
                                            wallet: user.wallet
                                        )
                                    // 이미 획득한 미션이나, 진행 중인 미션의 경우 안내 토스트?
                                }
                            }
                        )
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .padding(.horizontal)

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
}
