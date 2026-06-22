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
    enum Length {
        static let min: Int = 2
        static let max: Int = 7
    }

    enum Text {
        static let tooShort = "닉네임은 최소 \(Length.min)자 이상이어야 합니다."
        static let tooLong = "닉네임은 최대 \(Length.max)자까지 입력 가능합니다."
    }
}

final class Validator {

    func validate(_ nickname: String) -> ValidationResult {
        if nickname.isEmpty { return .empty }
        if nickname.count < Constant.Length.min { return .invalid(Constant.Text.tooShort) }
        if nickname.count > Constant.Length.max { return .invalid(Constant.Text.tooLong) }
        return .valid
    }

    func isValid(_ nickname: String) -> Bool {
        let count = nickname.count
        return !nickname.isEmpty && count >= Constant.Length.min && count <= Constant.Length.max
    }
}
