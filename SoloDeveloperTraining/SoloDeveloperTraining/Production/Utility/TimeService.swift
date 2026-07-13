//
//  TimeService.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/20/26.
//

import Foundation

/// 서버 시간 조회 서비스
enum TimeService {
    enum TimeServiceError: Error {
        case invalidResponse
        case allServersFailed
    }

    /// 신뢰할 수 있는 서버 목록 (fallback 순서)
    private static let serverURLs = [
        "https://www.apple.com",
        "https://www.google.com"
    ]

    /// 서버로부터 현재 시간 조회
    static func fetchCurrentTime() async throws -> TimeInterval {
        let timeout = Policy.OfflineReward.serverTimeTimeout

        // 여러 서버 순차 시도
        for urlString in serverURLs {
            if let time = try? await fetchTimeFromServer(urlString, timeout: timeout) {
                return time
            }
        }

        // 모든 서버 실패
        throw TimeServiceError.allServersFailed
    }

    /// 특정 서버에서 시간 조회
    private static func fetchTimeFromServer(_ urlString: String, timeout: TimeInterval) async throws -> TimeInterval {
        guard let url = URL(string: urlString) else {
            throw TimeServiceError.invalidResponse
        }

        // HEAD 요청 생성 (본문 없이 헤더만)
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = "HEAD"

        // 요청 전송
        let (_, response) = try await URLSession.shared.data(for: request)

        // HTTP 응답에서 Date 헤더 추출
        guard let httpResponse = response as? HTTPURLResponse,
              let dateString = httpResponse.value(forHTTPHeaderField: "Date") else {
            throw TimeServiceError.invalidResponse
        }

        // RFC 2822 형식의 날짜 문자열 파싱
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        formatter.timeZone = TimeZone(abbreviation: "GMT")

        guard let date = formatter.date(from: dateString) else {
            throw TimeServiceError.invalidResponse
        }

        // Unix timestamp 반환
        return date.timeIntervalSince1970
    }
}
