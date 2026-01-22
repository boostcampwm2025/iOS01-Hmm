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

enum Validator {
    enum Nickname {
        static let minLength: Int = 2
        static let maxLength: Int = 7

        private static let nicknamePattern = "^[가-힣a-zA-Z0-9]+$"
        
        private static var nicknameRegex: NSRegularExpression? {
            try? NSRegularExpression(pattern: nicknamePattern, options: [])
        }

        /// 닉네임을 검증하고 결과를 반환합니다.
        static func validate(_ nickname: String) -> ValidationResult {
            if nickname.isEmpty {
                return .empty
            }

            // 한글, 숫자, 영어만 허용 (공백 불가)
            guard let regex = nicknameRegex,
                  let _ = regex.firstMatch(in: nickname, options: [], range: NSRange(location: 0, length: nickname.utf16.count)) else {
                return .invalid("한글, 숫자, 영어만 사용 가능하며 공백은 사용할 수 없습니다.")
            }

            if nickname.count < minLength {
                return .invalid("닉네임은 최소 \(minLength)자 이상이어야 합니다.")
            }

            if nickname.count > maxLength {
                return .invalid("닉네임은 최대 \(maxLength)자까지 입력 가능합니다.")
            }

            return .valid
        }

        /// 닉네임이 유효한지 확인합니다.
        static func isValid(_ nickname: String) -> Bool {
            // 한글, 숫자, 영어만 허용 (공백 불가)
            guard let regex = nicknameRegex,
                  let _ = regex.firstMatch(in: nickname, options: [], range: NSRange(location: 0, length: nickname.utf16.count)) else {
                return false
            }

            return nickname.count >= minLength && nickname.count <= maxLength && !nickname.isEmpty
        }
    }
}
