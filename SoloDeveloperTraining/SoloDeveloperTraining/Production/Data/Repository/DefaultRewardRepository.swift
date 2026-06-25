//
//  DefaultRewardRepository.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/25/26.
//

final class DefaultRewardRepository {

    func fetchAllRewards(for userType: RewardUserType) -> [Reward]? {
        orderedRewards.first { $0.userType == userType }?.rewards
    }

    func fetchAllRewards() -> [UpdateReward] {
        orderedRewards
    }

    private let orderedRewards: [UpdateReward] = [
        .init(userType: .newUser, rewards: [.diamond(15)]),
        .init(userType: .originUser(.unemployed), rewards: [.diamond(30)]),
        .init(userType: .originUser(.laptopOwner), rewards: [
            .diamond(60),
            .consumable(.coffee, count: 3)
        ]),
        .init(userType: .originUser(.aspiringDeveloper), rewards: [
            .diamond(90),
            .consumable(.coffee, count: 6),
            .consumable(.energyDrink, count: 1)
        ]),
        .init(userType: .originUser(.juniorDeveloper), rewards: [
            .diamond(120),
            .consumable(.coffee, count: 10),
            .consumable(.energyDrink, count: 2)
        ]),
        .init(userType: .originUser(.normalDeveloper), rewards: [
            .diamond(150),
            .consumable(.coffee, count: 15),
            .consumable(.energyDrink, count: 7)
        ]),
        .init(userType: .originUser(.nightOwlDeveloper), rewards: [
            .diamond(180),
            .consumable(.coffee, count: 18),
            .consumable(.energyDrink, count: 12)
        ]),
        .init(userType: .originUser(.skilledDeveloper), rewards: [
            .diamond(210),
            .consumable(.coffee, count: 21),
            .consumable(.energyDrink, count: 17)
        ]),
        .init(userType: .originUser(.famousDeveloper), rewards: [
            .diamond(240),
            .consumable(.coffee, count: 24),
            .consumable(.energyDrink, count: 22)
        ]),
        .init(userType: .originUser(.allRounderDeveloper), rewards: [
            .diamond(270),
            .consumable(.coffee, count: 27),
            .consumable(.energyDrink, count: 27)
        ]),
        .init(userType: .originUser(.worldClassDeveloper), rewards: [
            .diamond(300),
            .consumable(.coffee, count: 30),
            .consumable(.energyDrink, count: 30)
        ])
    ]
}
