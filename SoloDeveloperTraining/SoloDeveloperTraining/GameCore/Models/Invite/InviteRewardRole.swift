/// 초대 관계에서 보상을 받는 쪽. 재화 수량은 iOS에서 결정한다.
enum InviteRewardRole: String {
    case inviter
    case invitee

    var diamondAmount: Int {
        switch self {
        case .inviter: InviteConstants.inviterRewardDiamond
        case .invitee: InviteConstants.welcomeRewardDiamond
        }
    }
}
