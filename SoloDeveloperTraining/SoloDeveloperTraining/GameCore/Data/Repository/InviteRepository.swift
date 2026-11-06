/// 초대 서버 데이터에 접근하고 앱 모델로 변환한다.
protocol InviteRepository {
    func initializeProfile(nickname: String?) async throws -> String
    func applyCode(_ code: String) async throws -> String
    func fetchInvitedFriends() async throws -> [InvitedFriend]
    func claimReward(grantId: String) async throws -> String
    func fetchClaimedRewards() async throws -> [(grantId: String, role: InviteRewardRole)]
}

extension InviteRepository {
    func initializeProfile() async throws -> String {
        try await initializeProfile(nickname: nil)
    }
}
