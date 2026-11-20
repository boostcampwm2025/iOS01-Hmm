//
//  InviteLink.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 11/20/26.
//

import Foundation

private enum Constant {
    /// 초대 랜딩 페이지를 제공하는 Firebase Hosting 도메인
    static let baseURL = "https://solodevelopertraining.web.app"
    /// 초대 랜딩 페이지 경로
    static let invitePath = "invite"
    /// 초대 코드 쿼리 이름
    static let codeQueryName = "code"
}

/// 친구 초대 링크와 공유 문구
enum InviteLink {
    /// 공유 문구 첫 줄
    static let inviteMessage = "1인 개발자 키우기에서 같이 성장해요!"

    /// 초대 랜딩 페이지 URL
    /// - 예: `https://solodevelopertraining.web.app/invite?code=AB1234`
    static func urlString(code: String) -> String {
        "\(Constant.baseURL)/\(Constant.invitePath)?\(Constant.codeQueryName)=\(code)"
    }

    /// 링크 복사·기타 공유에 쓰는 문구 (문구 + 초대 코드 + 랜딩 페이지 URL)
    static func shareMessage(code: String) -> String {
        """
        \(inviteMessage)
        초대 코드: \(code)
        \(urlString(code: code))
        """
    }
}
