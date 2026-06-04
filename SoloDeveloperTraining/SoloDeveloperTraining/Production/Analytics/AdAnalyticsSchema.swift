//
//  AdAnalyticsSchema.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/4/26.
//

enum AdPlacementType: String {
    case consumable
    case workExit
    case equipmentEnhance
    case reselectionReward
    case skillReward
    case quizReward
    case offlineReward
}

enum AdRewardType: String {
    case gold
    case diamond
    case coffee
    case energyDrink
    case reselect
}

enum AdOfferDismissReasonType: String {
    case close
    case background
    case unknown
}
