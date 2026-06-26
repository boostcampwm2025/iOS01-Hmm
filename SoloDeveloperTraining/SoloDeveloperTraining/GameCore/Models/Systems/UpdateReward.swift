//
//  UpdateReward.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/25/26.
//

struct UpdateReward {
    let userType: RewardUserType
    let rewards: [Reward]
}

enum RewardUserType: Hashable {
    case newUser
    case originUser(Career)
}
