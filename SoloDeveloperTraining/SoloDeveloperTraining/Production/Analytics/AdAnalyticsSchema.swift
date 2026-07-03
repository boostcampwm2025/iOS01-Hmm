//
//  AdAnalyticsSchema.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/4/26.
//

enum AdAnalyticsEvent: String {
    case offerViewed = "ad_offer_viewed"
    case watchClicked = "ad_watch_clicked"
    case watchCompleted = "ad_watch_completed"
    case rewardClaimed = "ad_reward_claimed"
    case offerDismissed = "ad_offer_dismissed"
}

enum AdPlacementType {
    case consumable(screenID: String)
    case workExit(screenID: String)
    case equipmentEnhance(screenID: String)
    case reselectionReward(screenID: String)
    case skillReward(screenID: String)
    case quizReward(screenID: String)
    case offlineReward(screenID: String)

    var screenID: String {
        switch self {
        case .consumable(let id),
             .workExit(let id),
             .equipmentEnhance(let id),
             .reselectionReward(let id),
             .skillReward(let id),
             .quizReward(let id),
             .offlineReward(let id):
            return id
        }
    }
}

enum AdRewardType: String {
    case gold
    case diamond
    case coffee
    case energyDrink
    case reselect
    case skillBoost
    case enhanceRateBoost
}

enum AdOfferDismissReasonType: String {
    case close
    case unknown
}
