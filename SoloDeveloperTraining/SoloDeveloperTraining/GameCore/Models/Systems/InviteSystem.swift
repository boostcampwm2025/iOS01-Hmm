//
//  InviteSystem.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation
import Observation

/// 친구 초대 상태 관리
@Observable
final class InviteSystem {
    private let repository: any InviteRepository
    private let grantStore: InviteRewardGrantStorage
    private let userRepository: UserRepository

    /// 내 초대 코드
    private(set) var myCode: String
    /// 내 초대 코드를 입력한 친구 목록
    private(set) var invitedFriends: [InvitedFriend]

    /// 초대 완료 인원
    var invitedCount: Int { invitedFriends.count }

    /// 지금까지 받은 초대 보상 다이아
    var claimedDiamond: Int {
        invitedFriends.filter(\.isRewardClaimed).count * InviteConstants.inviterRewardDiamond
    }

    /// 보상을 아직 받지 않은 친구 목록
    var pendingFriends: [InvitedFriend] {
        invitedFriends.filter { !$0.isRewardClaimed }
    }

    init() {
        self.myCode = ""
        self.invitedFriends = []
        self.repository = DefaultInviteRepository()
        self.grantStore = InviteRewardGrantStorage()
        self.userRepository = FileManagerUserRepository()
    }

    init(
        myCode: String,
        invitedFriends: [InvitedFriend],
        repository: any InviteRepository,
        grantStore: InviteRewardGrantStorage,
        userRepository: UserRepository
    ) {
        self.myCode = myCode
        self.invitedFriends = invitedFriends
        self.repository = repository
        self.grantStore = grantStore
        self.userRepository = userRepository
    }

    /// 최초 초대 프로필을 준비한다. 코드 입력을 건너뛰어도 닉네임을 저장한다.
    func initializeProfile(nickname: String) async throws {
        myCode = try await repository.initializeProfile(nickname: nickname)
    }

    /// 초대 코드 등록 후 서버가 반환한 피초대자 grant ID를 기기에 저장한다.
    /// 웰컴 다이아는 이후 닉네임 설정 완료 시 로컬 지갑에 지급한다.
    func applyInviteCode(_ code: String, nickname: String) async throws {
        try await initializeProfile(nickname: nickname)
        let grantId = try await repository.applyCode(code)
        grantStore.record(grantId)
    }

    /// 서버의 내 코드와 초대 목록을 최신 상태로 갱신한다.
    func refreshStatus() async {
        do {
            myCode = try await repository.initializeProfile()
            invitedFriends = try await repository.fetchInvitedFriends().map { friend in
                var friend = friend
                friend.isRewardClaimed = friend.isRewardClaimed || grantStore.contains(friend.grantId)
                return friend
            }
        } catch {
            // 일시적인 조회 실패 시 현재 화면의 상태를 유지한다.
        }
    }

    /// 서버에서 수령된 보상 중 로컬 지갑에 아직 반영되지 않은 항목을 복구한다.
    func syncRewards(user: User) async -> [InvitedFriend] {
        do {
            let synced = try await repository.fetchClaimedRewards()
            var didChangeWallet = false
            for grant in synced where !grantStore.contains(grant.grantId) {
                user.wallet.addDiamond(grant.role.diamondAmount)
                grantStore.record(grant.grantId)
                markClaimed(grantId: grant.grantId)
                didChangeWallet = true
            }
            if didChangeWallet {
                try? await userRepository.save(user)
            }
            return pendingFriends
        } catch {
            return pendingFriends
        }
    }

    /// 친구 초대 보상을 서버에서 수령 처리한 뒤 로컬 지갑에 반영한다.
    @discardableResult
    func claimInviteReward(friend: InvitedFriend, user: User) async -> Bool {
        guard let index = invitedFriends.firstIndex(where: { $0.id == friend.id }),
              !invitedFriends[index].isRewardClaimed
        else { return false }

        if grantStore.contains(friend.grantId) {
            invitedFriends[index].isRewardClaimed = true
            return false
        }

        do {
            let grantId = try await repository.claimReward(grantId: friend.grantId)
            user.wallet.addDiamond(InviteConstants.inviterRewardDiamond)
            grantStore.record(grantId)
            try? await userRepository.save(user)
            invitedFriends[index].isRewardClaimed = true
            return true
        } catch let error as InviteFunctionsError where error == .rewardAlreadyClaimed {
            user.wallet.addDiamond(InviteConstants.inviterRewardDiamond)
            grantStore.record(friend.grantId)
            try? await userRepository.save(user)
            invitedFriends[index].isRewardClaimed = true
            return true
        } catch {
            return false
        }
    }

    private func markClaimed(grantId: String) {
        if let index = invitedFriends.firstIndex(where: { $0.grantId == grantId }) {
            invitedFriends[index].isRewardClaimed = true
        }
    }
}
