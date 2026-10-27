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
        }
    }
}
