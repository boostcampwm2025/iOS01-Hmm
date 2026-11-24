//
//  InviteLinkTests.swift
//  SoloDeveloperTrainingTests
//

import Foundation
import Testing
@testable import SoloDeveloperTraining

@MainActor
struct InviteLinkTests {

    // MARK: - 생성

    @Test("초대 코드로 랜딩 페이지 URL을 만든다")
    func urlStringContainsCode() {
        #expect(
            InviteLink.urlString(code: "AB1234")
                == "https://solodevelopertraining.web.app/invite?code=AB1234"
        )
    }

    @Test("공유 문구는 안내 문구, 초대 코드, 랜딩 페이지 URL 순서로 구성된다")
    func shareMessageContainsCodeAndURL() {
        let lines = InviteLink.shareMessage(code: "AB1234").components(separatedBy: "\n")

        #expect(lines == [
            InviteLink.inviteMessage,
            "초대 코드: AB1234",
            "https://solodevelopertraining.web.app/invite?code=AB1234"
        ])
    }

    @Test("만든 URL을 다시 파싱하면 같은 코드가 나온다")
    func generatedURLRoundTrips() throws {
        let url = try #require(URL(string: InviteLink.urlString(code: "Z9Y8X7")))

        #expect(InviteLink.code(from: url) == "Z9Y8X7")
    }

    // MARK: - 파싱 성공

    @Test(
        "초대 링크에서 코드를 꺼낸다",
        arguments: [
            "https://solodevelopertraining.web.app/invite?code=AB1234",
            "https://solodevelopertraining.web.app/invite/?code=AB1234",
            "https://SoloDeveloperTraining.web.app/invite?code=AB1234",
            "https://solodevelopertraining.web.app/invite?entry_source=kakao&code=AB1234",
            "devup://invite?code=AB1234",
            "devup://invite/?code=AB1234"
        ]
    )
    func parsesInviteLinks(urlString: String) throws {
        let url = try #require(URL(string: urlString))

        #expect(InviteLink.code(from: url) == "AB1234")
    }

    @Test(
        "소문자와 앞뒤 공백은 정규화한다",
        arguments: [
            "https://solodevelopertraining.web.app/invite?code=ab1234",
            "https://solodevelopertraining.web.app/invite?code=%20AB1234%20",
            "devup://invite?code=aB1234"
        ]
    )
    func normalizesCode(urlString: String) throws {
        let url = try #require(URL(string: urlString))

        #expect(InviteLink.code(from: url) == "AB1234")
    }

    // MARK: - 파싱 실패

    @Test(
        "코드 형식이 틀리면 nil을 반환한다",
        arguments: [
            "https://solodevelopertraining.web.app/invite?code=AB12",
            "https://solodevelopertraining.web.app/invite?code=AB1234XY",
            "https://solodevelopertraining.web.app/invite?code=AB-123",
            "https://solodevelopertraining.web.app/invite?code=",
            "devup://invite?code=%ED%95%9C%EA%B8%80AB12"
        ]
    )
    func rejectsInvalidCode(urlString: String) throws {
        let url = try #require(URL(string: urlString))

        #expect(InviteLink.code(from: url) == nil)
    }

    @Test(
        "초대 링크가 아니면 nil을 반환한다",
        arguments: [
            // 엔딩 공유 링크
            "https://solodevelopertraining.web.app/aceDeveloper?share_id=abc&result_id=1&code=AB1234",
            // 랜딩 페이지 루트
            "https://solodevelopertraining.web.app/?code=AB1234",
            // 하위 경로
            "https://solodevelopertraining.web.app/invite/extra?code=AB1234",
            // 다른 도메인
            "https://example.com/invite?code=AB1234",
            // http
            "http://solodevelopertraining.web.app/invite?code=AB1234",
            // 앱 스킴의 다른 host
            "devup://share?code=AB1234",
            // 카카오 스킴
            "kakao1234://kakaolink?code=AB1234"
        ]
    )
    func rejectsNonInviteLinks(urlString: String) throws {
        let url = try #require(URL(string: urlString))

        #expect(InviteLink.code(from: url) == nil)
    }

    @Test(
        "code 쿼리가 없으면 nil을 반환한다",
        arguments: [
            "https://solodevelopertraining.web.app/invite",
            "https://solodevelopertraining.web.app/invite?invite_code=AB1234",
            "devup://invite"
        ]
    )
    func rejectsMissingCode(urlString: String) throws {
        let url = try #require(URL(string: urlString))

        #expect(InviteLink.code(from: url) == nil)
    }
}
