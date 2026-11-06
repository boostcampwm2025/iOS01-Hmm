//
//  InvitedFriend.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation

/// 내 초대 코드를 입력한 친구
struct InvitedFriend: Identifiable, Hashable {
    /// 서버 invitation ID
    let id: String
    /// 친구 닉네임
    let nickname: String
    /// 친구가 내 초대 코드를 입력한 시각
    let invitedAt: Date
    /// 초대 보상 수령 여부
    var isRewardClaimed: Bool
    /// 초대자 보상 grant ID
    let grantId: String

    init(
        id: String,
        nickname: String,
        invitedAt: Date,
        isRewardClaimed: Bool = false,
        grantId: String
    ) {
        self.id = id
        self.nickname = nickname
        self.invitedAt = invitedAt
        self.isRewardClaimed = isRewardClaimed
        self.grantId = grantId
    }
}
