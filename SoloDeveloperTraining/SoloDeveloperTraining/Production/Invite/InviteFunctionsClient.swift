import Foundation
import FirebaseFunctions

private enum Constant {
    static let initializeInviteProfile = "initialize_invite_profile"
    static let updateInviteNickname = "update_invite_nickname"
    static let applyInviteCode = "apply_invite_code"
    static let getInviteStatus = "get_invite_status"
    static let claimInviteReward = "claim_invite_reward"
    static let syncInviteRewards = "sync_invite_rewards"
}

enum InviteFunctionsError: LocalizedError, Equatable {
    case unauthenticated
    case invalidInviteCode
    case inviteCodeNotFound
    case ownInviteCode
    case alreadyApplied
    case nicknameRequired
    case dailyAttemptLimit
    case rewardNotFound
    case rewardAlreadyClaimed
    case forbidden
    case unknown

    init(errorCode: String) {
        switch errorCode {
        case "UNAUTHENTICATED": self = .unauthenticated
        case "INVALID_INVITE_CODE": self = .invalidInviteCode
        case "INVITE_CODE_NOT_FOUND": self = .inviteCodeNotFound
        case "OWN_INVITE_CODE": self = .ownInviteCode
        case "ALREADY_APPLIED": self = .alreadyApplied
        case "NICKNAME_REQUIRED": self = .nicknameRequired
        case "DAILY_ATTEMPT_LIMIT": self = .dailyAttemptLimit
        case "REWARD_NOT_FOUND": self = .rewardNotFound
        case "REWARD_ALREADY_CLAIMED": self = .rewardAlreadyClaimed
        case "FORBIDDEN": self = .forbidden
        default: self = .unknown
        }
    }

    init(error: Error) {
        let nsError = error as NSError
        if nsError.domain == FunctionsErrorDomain,
           nsError.code == FunctionsErrorCode.unauthenticated.rawValue {
            self = .unauthenticated
            return
        }
        if let details = nsError.userInfo[FunctionsErrorDetailsKey] as? [String: Any],
           let errorCode = details["errorCode"] as? String {
            self = InviteFunctionsError(errorCode: errorCode)
            return
        }
        self = InviteFunctionsError(errorCode: nsError.localizedDescription)
    }
}

protocol InviteFunctionsClient {
    func initializeInviteProfile(nickname: String?) async throws -> InviteProfileDTO
    func updateInviteNickname(_ nickname: String) async throws
    func applyInviteCode(_ code: String) async throws -> InviteApplyDTO
    func getInviteStatus() async throws -> InviteStatusDTO
    func claimInviteReward(grantId: String) async throws -> InviteGrantDTO
    func syncInviteRewards() async throws -> InviteSyncDTO
}

extension InviteFunctionsClient {
    func initializeInviteProfile() async throws -> InviteProfileDTO {
        try await initializeInviteProfile(nickname: nil)
    }
}

final class FirebaseInviteFunctionsClient: InviteFunctionsClient {
    private let functions: Functions

    init(functions: Functions = InviteFirebaseEnvironment.functions) {
        self.functions = functions
    }

    func initializeInviteProfile(nickname: String?) async throws -> InviteProfileDTO {
        var request: [String: Any] = [:]
        if let nickname {
            request["nickname"] = nickname
        }
        let payload = try await call(Constant.initializeInviteProfile, request)
        guard let inviteCode = payload["inviteCode"] as? String else {
            throw InviteFunctionsError.unknown
        }
        return InviteProfileDTO(inviteCode: inviteCode)
    }

    func updateInviteNickname(_ nickname: String) async throws {
        _ = try await call(Constant.updateInviteNickname, ["nickname": nickname])
    }

    func applyInviteCode(_ code: String) async throws -> InviteApplyDTO {
        let payload = try await call(Constant.applyInviteCode, ["inviteCode": code])
        guard let inviteeGrant = grant(from: payload["inviteeGrant"]) else {
            throw InviteFunctionsError.unknown
        }
        return InviteApplyDTO(inviteeGrant: inviteeGrant)
    }

    func getInviteStatus() async throws -> InviteStatusDTO {
        let payload = try await call(Constant.getInviteStatus, [:])
        let invitations = try (payload["invitations"] as? [[String: Any]] ?? [])
            .map(invitation(from:))
        return InviteStatusDTO(invitations: invitations)
    }

    func claimInviteReward(grantId: String) async throws -> InviteGrantDTO {
        let payload = try await call(Constant.claimInviteReward, ["grantId": grantId])
        guard let grant = grant(from: payload) else {
            throw InviteFunctionsError.unknown
        }
        return grant
    }

    func syncInviteRewards() async throws -> InviteSyncDTO {
        let payload = try await call(Constant.syncInviteRewards, [:])
        let claimed = try (payload["claimed"] as? [[String: Any]] ?? []).map { payload in
            guard let grant = grant(from: payload) else { throw InviteFunctionsError.unknown }
            return grant
        }
        return InviteSyncDTO(claimed: claimed)
    }
}

private extension FirebaseInviteFunctionsClient {
    func call(_ name: String, _ data: [String: Any]) async throws -> [String: Any] {
        do {
            let result = try await functions.httpsCallable(name).call(data)
            return result.data as? [String: Any] ?? [:]
        } catch {
            throw InviteFunctionsError(error: error)
        }
    }

    func grant(from raw: Any?) -> InviteGrantDTO? {
        guard let payload = raw as? [String: Any],
              let grantId = payload["grantId"] as? String,
              let rawRole = payload["role"] as? String,
              let role = InviteRewardRole(rawValue: rawRole)
        else { return nil }

        return InviteGrantDTO(grantId: grantId, role: role)
    }

    func invitation(from payload: [String: Any]) throws -> InviteInvitationStatusDTO {
        guard let invitationId = payload["invitationId"] as? String,
              let rawStatus = payload["inviterRewardStatus"] as? String,
              let status = InviteRewardStatus(rawValue: rawStatus)
        else { throw InviteFunctionsError.unknown }
        return InviteInvitationStatusDTO(
            invitationId: invitationId,
            inviteeNickname: payload["inviteeNickname"] as? String ?? "친구",
            createdAt: parseDate(payload["createdAt"]),
            inviterRewardStatus: status
        )
    }

    func parseDate(_ raw: Any?) -> Date? {
        guard let text = raw as? String else { return nil }
        return ISO8601DateFormatter().date(from: text)
            ?? ISO8601DateFormatter.withFractionalSeconds.date(from: text)
    }
}

private extension ISO8601DateFormatter {
    static let withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
