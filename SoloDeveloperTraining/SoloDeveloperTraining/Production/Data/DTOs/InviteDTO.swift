import Foundation

/// 서버와 일치해야 하는 보상 수령 상태 값.
enum InviteRewardStatus: String {
    case pending = "PENDING"
    case claimed = "CLAIMED"
}

struct InviteProfileDTO {
    let inviteCode: String
}

struct InviteApplyDTO {
    let inviteeGrant: InviteGrantDTO
}

/// 서버는 보상 식별자와 역할만 반환한다.
struct InviteGrantDTO {
    let grantId: String
    let role: InviteRewardRole
}

struct InviteStatusDTO {
    let invitations: [InviteInvitationStatusDTO]
}

struct InviteInvitationStatusDTO {
    let invitationId: String
    let inviteeNickname: String
    let createdAt: Date?
    let inviterRewardStatus: InviteRewardStatus
}

struct InviteSyncDTO {
    let claimed: [InviteGrantDTO]
}
