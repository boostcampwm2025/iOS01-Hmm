//
//  InviteAnalyticsSchema.swift
//  SoloDeveloperTraining
//

enum InviteAnalyticsEvent: String {
    case linkShared = "share_invite_link"
    case codeInputViewed = "view_invite_code_input"
    case codeInputSkipped = "skip_invite_code_input"
    case accepted = "accept_invite"
    case rewardClaimed = "claim_referral_reward"
}

enum InviteShareChannel: String {
    case kakao
    case line
    case url
    case code
}

enum InviteCodeEntryType: String {
    case auto
    case manual
}

enum InviteCodeInputMethod: String {
    case deepLink = "deep_link"
    case clipboard
    case manual
}
