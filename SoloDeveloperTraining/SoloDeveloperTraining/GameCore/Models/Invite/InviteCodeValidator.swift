//
//  InviteCodeValidator.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation

private enum Constant {
    /// 대문자·숫자 6자리
    static let codePattern = "(?<![A-Za-z0-9])[A-Z0-9]{\(InviteConstants.codeLength)}(?![A-Za-z0-9])"
}

final class InviteCodeValidator {

    /// 입력값을 초대 코드 형식으로 정리
    func normalize(_ input: String) -> String {
        let filtered = input
            .uppercased()
            .filter { $0.isASCII && ($0.isLetter || $0.isNumber) }
        return String(filtered.prefix(InviteConstants.codeLength))
    }

    /// 문자열에서 초대 코드 추출
    func extractCode(from text: String) -> String? {
        guard let range = text.range(of: Constant.codePattern, options: .regularExpression) else { return nil }
        return String(text[range])
    }

    /// 초대 코드 유효성을 검증
    func validateFormat(_ code: String) -> InviteCodeValidationResult {
        let code = normalize(code)
        guard code.count == InviteConstants.codeLength,
              code.allSatisfy({ $0.isASCII && ($0.isUppercase || $0.isNumber) })
        else { return .invalidFormat }
        return .valid
    }
}
