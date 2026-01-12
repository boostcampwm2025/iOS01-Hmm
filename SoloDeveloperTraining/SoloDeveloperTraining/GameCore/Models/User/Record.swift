//
//  Record.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

@Observable
final class Record {

    // MARK: - Tap Records
    /// 총 탭 횟수
    var totalTapCount: Int = 0
    /// 탭 게임 플레이 타임
    var tapGamePlayTime: TimeInterval = 0

    // MARK: - Language Game Records
    /// 언어 맞추기 성공 횟수
    var languageCorrectCount: Int = 0
    /// 언어 맞추기 실패 횟수
    var languageFailCount: Int = 0
    /// 언어 맞추기 게임 실행 횟수
    var pairGamePlayCount: Int = 0

    // MARK: - Bug Dodging Records
    /// 버그 충돌 횟수
    var bugHitCount: Int = 0
    /// 재산 먹은 횟수
    var goldHitCount: Int = 0
    /// 버그피하기 게임 실행 횟수
    var dodgeGamePlayCount: Int = 0
    /// 버그피하기 게임 최고 점수
    var dodgeGameBestScore: Int = 0

    // MARK: - Stacking Game Records

    /// 물건 쌓기 성공 횟수
    var stackingSuccessCount: Int = 0
    /// 물건 쌓기 실패 횟수
    var stackingFailCount: Int = 0
    /// 물건 쌓기 폭탄 획득 횟수
    var stackingBombCount: Int = 0
    /// 물건 쌓기 폭탄 회피 횟수
    var stackingBombDodgeCount: Int = 0
    /// 최고 층수
    var stackMaxHeight: Int = 0
    /// 연속 실패 횟수
    var stackConsecutiveFailures: Int = 0
    /// 물건 쌓기 게임 실행 횟수
    var stackGamePlayCount: Int = 0

    // MARK: - Consumable Usage Records
    /// 소비 아이템 총 사용 횟수
    var totalConsumableUseCount: Int = 0
    /// 커피 사용 횟수
    var coffeeUseCount: Int = 0
    /// 에너지 드링크 사용 횟수
    var energyDrinkUseCount: Int = 0

    // MARK: - Financial Records
    /// 누적 획득 재산
    var totalEarnedMoney: Int = 0
    /// 누적 소비 재산
    var totalSpentMoney: Int = 0
    /// 누적 업무 강화 비용
    var totalWorkEnhancementCost: Int = 0
    /// 누적 장비 강화 비용
    var totalEquipmentEnhancementCost: Int = 0
    /// 누적 소비 아이템 구입 비용
    var totalConsumablePurchaseCost: Int = 0
    /// 총 플레이 시간
    var totalPlayTime: TimeInterval = 0
    /// 튜토리얼 클리어 여부
    var tutorialCompleted: Bool = false
}
