import Foundation

final class DefaultInviteRepository: InviteRepository {
    private let client: any InviteFunctionsClient

    init(client: any InviteFunctionsClient = FirebaseInviteFunctionsClient()) {
        self.client = client
    }

    func initializeProfile(nickname: String?) async throws -> String {
        try await client.initializeInviteProfile(nickname: nickname).inviteCode
    }

    func applyCode(_ code: String) async throws -> String {
        try await client.applyInviteCode(code).inviteeGrant.grantId
    }

    func fetchInvitedFriends() async throws -> [InvitedFriend] {
        let status = try await client.getInviteStatus()
        return status.invitations.map { invitation in
            InvitedFriend(
                id: invitation.invitationId,
                nickname: invitation.inviteeNickname,
                invitedAt: invitation.createdAt ?? Date(),
                isRewardClaimed: invitation.inviterRewardStatus == .claimed,
                grantId: "\(invitation.invitationId)_inviter"
            )
        }
    }

    func claimReward(grantId: String) async throws -> String {
        try await client.claimInviteReward(grantId: grantId).grantId
    }

    func fetchClaimedRewards() async throws -> [(grantId: String, role: InviteRewardRole)] {
        try await client.syncInviteRewards().claimed.map { (grantId: $0.grantId, role: $0.role) }
    }
}
