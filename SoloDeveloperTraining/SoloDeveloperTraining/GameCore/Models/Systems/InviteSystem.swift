//
//  InviteSystem.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation
import Observation

private enum Constant {
    // TODO: 서버 연동 - 서버에서 받아온 값으로 교체 후 제거
    static let mockMyCode = "ABC000"
    static let mockInvitedFriends: [InvitedFriend] = [
        .init(nickname: "버그사냥꾼", invitedAt: daysAgo(10), isRewardClaimed: true),
        .init(nickname: "밤새는사람", invitedAt: daysAgo(5), isRewardClaimed: true),
        .init(nickname: "신입이에요", invitedAt: daysAgo(1))
    ]

    static func daysAgo(_ days: Int) -> Date {
        Date().addingTimeInterval(-Double(days) * 24 * 60 * 60)
    }
}

/// 친구 초대 상태 관리
@Observable
final class InviteSystem {

    // MARK: - Properties
    /// 내 초대 코드
    private(set) var myCode: String
    /// 내 초대 코드를 입력한 친구 목록
    private(set) var invitedFriends: [InvitedFriend]

    /// 초대 완료 인원
    var invitedCount: Int {
        invitedFriends.count
    }

    /// 지금까지 받은 초대 보상 다이아
    var claimedDiamond: Int {
        invitedFriends.filter(\.isRewardClaimed).count * InviteConstants.inviterRewardDiamond
    }

    /// 보상을 아직 받지 않은 친구 목록
    var pendingFriends: [InvitedFriend] {
        invitedFriends.filter { !$0.isRewardClaimed }
    }

    // MARK: - Initialization
    init(
        myCode: String = Constant.mockMyCode,
        invitedFriends: [InvitedFriend] = Constant.mockInvitedFriends
    ) {
        self.myCode = myCode
        self.invitedFriends = invitedFriends
    }

    /// 친구 초대 보상 수령
    /// - Returns: 수령 성공 여부
    @discardableResult
    func claimInviteReward(friend: InvitedFriend, wallet: Wallet) -> Bool {
        guard let index = invitedFriends.firstIndex(where: { $0.id == friend.id }),
              !invitedFriends[index].isRewardClaimed
        else { return false }

        // TODO: 서버 연동 - 수령 처리 결과를 서버에 반영
        invitedFriends[index].isRewardClaimed = true
        wallet.addDiamond(InviteConstants.inviterRewardDiamond)
        return true
    }
}
