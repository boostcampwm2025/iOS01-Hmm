//
//  Validator.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import Foundation

enum ValidationResult {
    case empty
    case valid
    case invalid(String)
}

private enum Constant {
    static let pattern: String = "^[가-힣a-zA-Z0-9]+$"

    enum Length {
        static let min: Int = 2
        static let max: Int = 7
    }

    enum Text {
        static let invalidCharacter = "한글, 숫자, 영어만 사용 가능하며 공백은 사용할 수 없습니다."
        static let tooShort = "닉네임은 최소 \(Length.min)자 이상이어야 합니다."
        static let tooLong = "닉네임은 최대 \(Length.max)자까지 입력 가능합니다."
    }
}

final class Validator {
    private var nicknameRegex: NSRegularExpression? {
        try? NSRegularExpression(pattern: Constant.pattern, options: [])
    }

    /// 닉네임을 검증하고 결과를 반환합니다.
    func validate(_ nickname: String) -> ValidationResult {
        if nickname.isEmpty {
            return .empty
        }

        // 한글, 숫자, 영어만 허용 (공백 불가)
        guard let regex = nicknameRegex,
            regex.firstMatch(in: nickname, options: [], range: NSRange(location: 0, length: nickname.utf16.count)) != nil
        else {
            return .invalid(Constant.Text.invalidCharacter)
        }

        if nickname.count < Constant.Length.min {
            return .invalid(Constant.Text.tooShort)
        }

        if nickname.count > Constant.Length.max {
            return .invalid(Constant.Text.tooLong)
        }

        return .valid
    }

    /// 닉네임이 유효한지 확인합니다.
    func isValid(_ nickname: String) -> Bool {
        // 한글, 숫자, 영어만 허용 (공백 불가)
        guard let regex = nicknameRegex,
            regex.firstMatch(in: nickname, options: [], range: NSRange(location: 0, length: nickname.utf16.count)) != nil
        else {
            return false
        }

        return nickname.count >= Constant.Length.min && nickname.count <= Constant.Length.max && !nickname.isEmpty
    }
}
