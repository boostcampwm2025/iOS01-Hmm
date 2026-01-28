//
//  SkillError+UserReadableError.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/20/26.
//

extension SkillError: UserReadableError {
    var message: String {
        switch self {
        case .levelExceeded: "이미 최대 레벨입니다."
        }
    }
}
