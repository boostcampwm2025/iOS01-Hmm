//
//  InviteConstants.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/28/26.
//

import Foundation

/// 친구 초대 관련 상수 정의
enum InviteConstants {
    // MARK: - 보상
    /// 초대 코드를 입력한 유저(피초대자)가 받는 웰컴 보상 다이아
    static let welcomeRewardDiamond = 50
    /// 친구가 내 코드를 입력했을 때 초대자가 받는 다이아 (친구 1명당)
    static let inviterRewardDiamond = 50

    // MARK: - 초대 코드
    /// 초대 코드 길이 (영문 대문자 + 숫자)
    static let codeLength = 6
}
