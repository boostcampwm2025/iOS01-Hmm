//
//  InviteCodeValidator.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation

private enum Constant {
    // TODO: 서버 연동 - 서버 조회로 교체 후 제거
    static let mockExistingCodes: Set<String> = ["ABC123", "ABC456", "ABC789"]
}

final class InviteCodeValidator {

    /// 입력값을 초대 코드 형식으로 정리
    func normalize(_ input: String) -> String {
        let filtered = input
            .uppercased()
            .filter { $0.isASCII && ($0.isLetter || $0.isNumber) }
        return String(filtered.prefix(InviteConstants.codeLength))
    }

    /// 초대 코드 확인
    /// - Parameters:
    ///   - code: 유저가 입력한 코드
    ///   - myCode: 내 초대 코드
    func validate(_ code: String, myCode: String? = nil) async -> InviteCodeValidationResult {
        let code = normalize(code)

        guard isValidFormat(code) else { return .invalidFormat }
        if let myCode, code == myCode { return .ownCode }

        // TODO: 서버 연동 - 코드 존재 여부를 서버에서 조회
        guard Constant.mockExistingCodes.contains(code) else { return .notFound }

        return .valid
    }
}

private extension InviteCodeValidator {
    /// 초대 코드 형식에 맞는지 확인
    func isValidFormat(_ code: String) -> Bool {
        code.count == InviteConstants.codeLength
            && code.allSatisfy { $0.isASCII && ($0.isUppercase || $0.isNumber) }
    }
}
