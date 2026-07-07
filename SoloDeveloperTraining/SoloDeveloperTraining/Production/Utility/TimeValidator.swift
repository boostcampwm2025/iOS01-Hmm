//
//  TimeValidator.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/20/26.
//

import Foundation

/// 시간 검증 유틸리티 (시간 조작 방지)
enum TimeValidator {

    /// 기기 시간과 systemUptime의 일관성 검증
    /// - Parameters:
    ///   - savedTime: 저장된 기기 시간 (Unix timestamp)
    ///   - savedUptime: 저장된 systemUptime
    ///   - currentTime: 현재 기기 시간 (Unix timestamp)
    ///   - currentUptime: 현재 systemUptime
    /// - Returns: 검증 통과 여부
    static func validateTimeConsistency(
        savedTime: TimeInterval,
        savedUptime: TimeInterval,
        currentTime: TimeInterval,
        currentUptime: TimeInterval
    ) -> Bool {
        // 기기 시간 차이 계산
        let deviceTimeDiff = currentTime - savedTime

        // SystemUptime 차이 계산
        let uptimeDiff = currentUptime - savedUptime

        // 두 값의 오차 계산
        let drift = abs(deviceTimeDiff - uptimeDiff)

        // 허용 오차 이내인지 확인
        return drift <= Policy.OfflineReward.allowedTimeDrift
    }

    /// 재부팅 감지
    /// - Parameters:
    ///   - savedUptime: 저장된 systemUptime
    ///   - currentUptime: 현재 systemUptime
    /// - Returns: 재부팅 여부
    static func isDeviceRebooted(
        savedUptime: TimeInterval,
        currentUptime: TimeInterval
    ) -> Bool {
        // 현재 uptime이 저장된 uptime보다 작으면 재부팅
        return currentUptime < savedUptime
    }

    /// 충분한 시간이 경과했는지 확인
    /// - Parameters:
    ///   - savedTime: 저장된 시간
    ///   - currentTime: 현재 시간
    /// - Returns: 최소 시간 경과 여부
    static func hasEnoughTimePassed(
        savedTime: TimeInterval,
        currentTime: TimeInterval
    ) -> Bool {
        let elapsedTimeSecond = currentTime - savedTime
        return elapsedTimeSecond >= Policy.OfflineReward.minimumHours * 3600
    }
}
