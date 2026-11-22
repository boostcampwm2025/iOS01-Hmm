//
//  InviteLink.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 11/20/26.
//

import Foundation

private enum Constant {
    /// 초대 랜딩 페이지를 제공하는 Firebase Hosting 호스트
    static let host = "solodevelopertraining.web.app"
    /// 초대 랜딩 페이지 기본 URL
    static let baseURL = "https://" + host
    /// 앱 커스텀 스킴 (`devup://invite?code=...`)
    static let appScheme = "devup"
    /// 초대 랜딩 페이지 경로 (커스텀 스킴에서는 host)
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

    /// 앱으로 들어온 URL에서 초대 코드 추출
    /// - Universal Link: `https://solodevelopertraining.web.app/invite?code=AB1234`
    /// - 커스텀 스킴: `devup://invite?code=AB1234`
    /// - 초대 링크가 아니거나(엔딩 공유 등) 코드 형식이 틀리면 nil
    static func code(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              isInviteLink(components),
              let rawCode = components.queryItems?
                .first(where: { $0.name == Constant.codeQueryName })?
                .value
        else { return nil }

        // 대문자 변환과 앞뒤 공백 제거만 허용하고, 그 외 문자가 섞이면 잘못된 코드로 본다.
        let code = rawCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let validator = InviteCodeValidator()
        guard validator.normalize(code) == code,
              validator.validateFormat(code).isValid
        else { return nil }
        return code
    }
}

private extension InviteLink {
    /// 초대 랜딩 페이지 또는 앱 스킴의 초대 경로인지
    static func isInviteLink(_ components: URLComponents) -> Bool {
        switch components.scheme?.lowercased() {
        case "https":
            let path = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            return components.host?.lowercased() == Constant.host && path == Constant.invitePath
        case Constant.appScheme:
            return components.host?.lowercased() == Constant.invitePath
        default:
            return false
        }
    }
}
