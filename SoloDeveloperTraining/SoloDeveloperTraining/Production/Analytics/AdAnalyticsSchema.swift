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
