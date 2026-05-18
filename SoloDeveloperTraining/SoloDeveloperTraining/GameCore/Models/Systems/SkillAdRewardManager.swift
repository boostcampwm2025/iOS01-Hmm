//
//  SkillAdRewardManager.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/18/26.
//

import Foundation

enum SkillAdRewardManager {
    // 1일 한도 수
    static let dailyLimit = 3
    // 실제 적용 배수
    static let rewardMultiplier: Double = 2
    // 지속 시간
    static let rewardDuration: TimeInterval = 5 * 60

    private static var rewardEndDate: Date?

    // 현재 사용중 여부 체크
    static func isRewardActive(user: User, now: Date = Date()) -> Bool {
        remainingRewardSeconds(user: user, now: now) > 0
    }

    // 1일 한도 내인지 확인
    static func canUseRewardToday(user: User, now: Date = Date()) -> Bool {
        resetDailyCountIfNeeded(user: user, now: now)
        return user.record.skillAdRewardState.useCount < dailyLimit
    }

    // 광고 시청을 완료한 이후 호출, 버프 종료 시각 계산
    static func grantReward(user: User, now: Date = Date()) {
        resetDailyCountIfNeeded(user: user, now: now)
        guard !isRewardActive(user: user, now: now) else { return }
        guard canUseRewardToday(user: user, now: now) else { return }

        user.record.skillAdRewardState.useCount += 1
        rewardEndDate = now.addingTimeInterval(rewardDuration)
    }

    // 골드 계산시 해당 값을 참조
    static func currentMultiplier(user: User) -> Double {
        isRewardActive(user: user) ? rewardMultiplier : 1
    }

    // 남은 시간 계산
    static func remainingRewardSeconds(user: User, now: Date = Date()) -> Int {
        guard let rewardEndDate, rewardEndDate > now else { return 0 }
        return min(Int(rewardDuration), Int(ceil(rewardEndDate.timeIntervalSince(now))))
    }

    static func remainingTimeText(user: User, now: Date = Date()) -> String? {
        let remainingSeconds = remainingRewardSeconds(user: user, now: now)
        guard remainingSeconds > 0 else { return nil }

        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "업무 효율 대박: %02d:%02d", minutes, seconds)
    }
}

private extension SkillAdRewardManager {
    // 한도 초기화가 필요할 경우 리셋
    static func resetDailyCountIfNeeded(user: User, now: Date = Date()) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        if let usedDate = user.record.skillAdRewardState.usedDate,
           calendar.startOfDay(for: usedDate) == today {
            return
        }

        user.record.skillAdRewardState.usedDate = today
        user.record.skillAdRewardState.useCount = 0
    }
}
