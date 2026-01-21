//
//  MissionView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/21/26.
//

import SwiftUI

private enum Constant {
    static let vertical: CGFloat = 15
}

struct MissionView: View {
    private let user: User
    private let missionSystem = MissionSystem(
        missions: MissionFactory.createAllMissions()
    )

    init(user: User) {
        self.user = user
    }

    var allCount: Int {
        missionSystem.missions.count
    }

    var claimedCount: Int {
        missionSystem.missions.count { $0.state == .claimed }
    }

    var body: some View {
        VStack(spacing: Constant.vertical) {
            ProgressBar(
                maxValue: Double(allCount),
                currentValue: Double(claimedCount),
                text: "\(claimedCount) / \(allCount)"
            )
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 115))],
                    spacing: 14
                ) {
                    ForEach(missionSystem.missions, id: \.id) { mission in
                        MissionCard(
                            title: mission.title,
                            reward: mission.reward,
                            imageName: mission.type.level.imageName,
                            condition: mission.description,
                            buttonState: mission.buttonState,
                            onButtonTap: {
                                if mission.buttonState == .claimable {
                                    mission.claim()
                                }
                            }
                        )
                    }
                }
            }.scrollIndicators(.never)
        }.padding(.horizontal)
    }
}
