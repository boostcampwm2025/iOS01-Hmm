//
//  OfflineRewardManager.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/20/26.
//

import Foundation

/// 오프라인 보상 검증 및 지급 관리자
@MainActor
final class OfflineRewardManager {

    /// 보상 지급 결과
    enum RewardResult {
        case awarded(gold: Int, hoursElapsed: Double)
        case notEligible(reason: NotEligibleReason)
    }

    /// 보상 받을 수 없는 이유
    enum NotEligibleReason {
        case newUser                    // 신규 유저
        case notEnoughTime              // 3시간 미만
        case timeManipulationDetected   // 시간 조작 감지
        case networkUnavailable         // 네트워크 없음
        case noGoldPerSecond            // 부동산 없음 (goldPerSecond = 0)
    }

    /// 오프라인 보상 체크 및 지급
    /// - Parameter user: 사용자 객체
    /// - Returns: 보상 결과
    func checkAndAwardOfflineReward(user: User) async -> RewardResult {
        let state = user.record.offlineRewardState

        // 신규 유저 체크
        guard let lastExitTime = state.lastExitTime else {
            return .notEligible(reason: .newUser)
        }

        // timeSource에 따라 검증 분기
        if state.timeSource == TimeSource.server {
            // 서버 시간으로 저장된 케이스
            return await validateWithServerTime(user: user, lastExitTime: lastExitTime)
        } else {
            // 기기 시간으로 저장된 케이스
            return await validateWithDeviceTime(user: user, state: state, lastExitTime: lastExitTime)
        }
    }

    // MARK: - Private Methods

    /// 서버 시간 기반 검증
    private func validateWithServerTime(user: User, lastExitTime: TimeInterval) async -> RewardResult {
        // 현재 서버 시간 조회
        guard let currentServerTime = try? await TimeService.fetchCurrentTime() else {
            return .notEligible(reason: .networkUnavailable)
        }

        // 경과 시간 체크
        guard TimeValidator.hasEnoughTimePassed(savedTime: lastExitTime, currentTime: currentServerTime) else {
            return .notEligible(reason: .notEnoughTime)
        }

        // 보상 지급
        return awardReward(user: user, lastExitTime: lastExitTime, currentTime: currentServerTime)
    }

    /// 기기 시간 기반 검증
    private func validateWithDeviceTime(user: User, state: OfflineRewardState, lastExitTime: TimeInterval) async -> RewardResult {
        guard let savedUptime = state.lastSystemUptime else {
            return .notEligible(reason: .networkUnavailable)
        }

        let currentTime = Date().timeIntervalSince1970
        let currentUptime = ProcessInfo.processInfo.systemUptime

        // 재부팅 감지
        if TimeValidator.isDeviceRebooted(savedUptime: savedUptime, currentUptime: currentUptime) {
            // 재부팅 시 서버 시간 필수
            guard let serverTime = try? await TimeService.fetchCurrentTime() else {
                return .notEligible(reason: .networkUnavailable)
            }

            // 서버 시간 기준으로 경과 시간 체크
            guard TimeValidator.hasEnoughTimePassed(savedTime: lastExitTime, currentTime: serverTime) else {
                return .notEligible(reason: .notEnoughTime)
            }

            return awardReward(user: user, lastExitTime: lastExitTime, currentTime: serverTime)
        }

        // 재부팅 안 했으면 교차 검증
        guard TimeValidator.validateTimeConsistency(
            savedTime: lastExitTime,
            savedUptime: savedUptime,
            currentTime: currentTime,
            currentUptime: currentUptime
        ) else {
            return .notEligible(reason: .timeManipulationDetected)
        }

        // 경과 시간 체크
        guard TimeValidator.hasEnoughTimePassed(savedTime: lastExitTime, currentTime: currentTime) else {
            return .notEligible(reason: .notEnoughTime)
        }

        // 보상 지급
        return awardReward(user: user, lastExitTime: lastExitTime, currentTime: currentTime)
    }

    /// 보상 계산
    private func awardReward(user: User, lastExitTime: TimeInterval, currentTime: TimeInterval) -> RewardResult {
        let elapsed = currentTime - lastExitTime
        let hoursElapsed = elapsed / 3600.0

        // 부동산의 초당 골드 획득량 가져오기
        let goldPerSecond = user.inventory.housing.goldPerSecond

        // 초당 골드가 0이면 보상 없음 (길바닥 케이스)
        guard goldPerSecond > 0 else {
            return .notEligible(reason: .noGoldPerSecond)
        }

        // 오프라인 보상 계산: 초당 골드 × 경과 시간
        let offlineGold = Int(Double(goldPerSecond) * elapsed)

        return .awarded(gold: offlineGold, hoursElapsed: hoursElapsed)
    }
}
