//
//  InvitedFriend.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation

/// 내 초대 코드를 입력한 친구
struct InvitedFriend: Identifiable, Hashable {
    /// 친구 식별용 ID
    let id: UUID
    /// 친구 닉네임
    let nickname: String
    /// 친구가 내 초대 코드를 입력한 시각
    let invitedAt: Date
    /// 초대 보상 수령 여부
    var isRewardClaimed: Bool

    init(
        id: UUID = UUID(),
        nickname: String,
        invitedAt: Date,
        isRewardClaimed: Bool = false
    ) {
        self.id = id
        self.nickname = nickname
        self.invitedAt = invitedAt
        self.isRewardClaimed = isRewardClaimed
    }
}
