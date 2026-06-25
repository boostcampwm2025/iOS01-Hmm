//
//  DefaultRewardRepository.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/25/26.
//

import Foundation

final class DefaultRewardRepository {

    func fetchAllRewards(for userType: RewardUserType) -> [Reward]? {
        rewards[userType]
    }

    func fetchAllRewards() -> [RewardUserType: [Reward]] {
        rewards
    }

    private let rewards: [RewardUserType: [Reward]] = [
        .newUser: [.diamond(15)],

        .originUser(.unemployed): [.diamond(30)],

        .originUser(.laptopOwner): [
            .diamond(30),
            .consumable(.coffee, count: 3)
        ],

        .originUser(.aspiringDeveloper): [
            .diamond(90),
            .consumable(.coffee, count: 6),
            .consumable(.energyDrink, count: 1)
        ],

        .originUser(.juniorDeveloper): [
            .diamond(120),
            .consumable(.coffee, count: 10),
            .consumable(.energyDrink, count: 2)
        ],

        .originUser(.normalDeveloper): [
            .diamond(150),
            .consumable(.coffee, count: 15),
            .consumable(.energyDrink, count: 7)
        ],

        .originUser(.nightOwlDeveloper): [
            .diamond(180),
            .consumable(.coffee, count: 18),
            .consumable(.energyDrink, count: 12)
        ],

        .originUser(.skilledDeveloper): [
            .diamond(210),
            .consumable(.coffee, count: 21),
            .consumable(.energyDrink, count: 17)
        ],

        .originUser(.famousDeveloper): [
            .diamond(240),
            .consumable(.coffee, count: 24),
            .consumable(.energyDrink, count: 22)
        ],

        .originUser(.allRounderDeveloper): [
            .diamond(270),
            .consumable(.coffee, count: 27),
            .consumable(.energyDrink, count: 27)
        ],

        .originUser(.worldClassDeveloper): [
            .diamond(300),
            .consumable(.coffee, count: 30),
            .consumable(.energyDrink, count: 30)
        ]
    ]
}
