//
//  InviteCodeValidationResult.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation

/// 초대 코드 입력 후 확인 결과
enum InviteCodeValidationResult {
    /// 정상 코드
    case valid
    /// 없는 코드
    case notFound
    /// 본인의 초대 코드
    case ownCode
    /// 형식 오류
    case invalidFormat
    /// 이미 초대 코드를 등록함
    case alreadyApplied
    /// 일일 시도 횟수 초과
    case dailyLimit
    /// 인증 또는 서버 오류
    case serverError

    var isValid: Bool {
        self == .valid
    }

    /// 입력 필드 하단에 노출할 문구
    var message: String {
        switch self {
        case .valid: "코드가 확인되었습니다."
        case .notFound: "코드를 확인해주세요."
        case .ownCode: "본인의 코드는 사용할 수 없습니다."
        case .invalidFormat: "초대 코드는 영문과 숫자 \(InviteConstants.codeLength)자리예요."
        case .alreadyApplied: "이미 초대 코드를 입력했어요."
        case .dailyLimit: "오늘은 더 이상 입력할 수 없어요."
        case .serverError: "잠시 후 다시 시도해주세요."
        }
    }
}

extension InviteCodeValidationResult {
    init(error: InviteFunctionsError) {
        switch error {
        case .invalidInviteCode: self = .invalidFormat
        case .inviteCodeNotFound: self = .notFound
        case .ownInviteCode: self = .ownCode
        case .alreadyApplied: self = .alreadyApplied
        case .dailyAttemptLimit: self = .dailyLimit
        default: self = .serverError
        }
    }
}
