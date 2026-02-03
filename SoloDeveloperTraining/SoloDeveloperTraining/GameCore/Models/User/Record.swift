//
//  Record.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class Record {
    /// 미션 시스템을 소유해서 기록을 반영합니다.
    let missionSystem: MissionSystem

    init(missionSystem: MissionSystem = MissionSystem(missions: MissionFactory.createAllMissions())) {
        self.missionSystem = missionSystem
    }

    // MARK: - Financial Records
    /// 누적 획득 재산
    var totalEarnedMoney: Int = 0
    /// 누적 소비 재산
    var totalSpentMoney: Int = 0
    /// 누적 스킬 업그레이드 비용
    var totalSkillUpgradeCost: Int = 0
    /// 누적 장비 강화 비용
    var totalEquipmentEnhancementCost: Int = 0
    /// 누적 소비 아이템 구입 비용
    var totalConsumablePurchaseCost: Int = 0
    /// 누적 부동산 이사 비용
    var totalHousingMoveCost: Int = 0

    // MARK: - Tap Records
    /// 총 탭 횟수
    var totalTapCount: Int = 0

    // MARK: - Language Game Records
    /// 언어 맞추기 성공 횟수
    var languageCorrectCount: Int = 0
    /// 언어 맞추기 연속 성공 횟수
    var languageConsecutiveCorrect: Int = 0

    // MARK: - Bug Dodging Records
    /// 버그피하기 골드 수집 횟수
    var dodgeGoldCollectedCount: Int = 0
    /// 버그피하기 최고 콤보 (역대 최고 연속 회피 횟수)
    var dodgeMaxCombo: Int = 0
    /// 버그피하기 총 버그 회피 횟수
    var dodgeBugAvoidedCount: Int = 0
    /// 버그피하기 버그 수집 횟수
    var dodgeBugCollectCount: Int = 0

    // MARK: - Stacking Game Records
    /// 데이터 쌓기 성공 횟수
    var stackingSuccessCount: Int = 0
    /// 데이터 쌓기 연속 성공 횟수
    var stackConsecutiveSuccess: Int = 0

    // MARK: - Consumable Usage Records
    /// 커피 사용 횟수
    var coffeeUseCount: Int = 0
    /// 에너지 드링크 사용 횟수
    var energyDrinkUseCount: Int = 0

    // MARK: - Play Time Records
    /// 총 플레이 시간
    var totalPlayTime: TimeInterval = 0

    // MARK: - Tutorial Records
    /// 튜토리얼 클리어 여부
    var tutorialCompleted: Bool = false

    // MARK: - Career Records
    /// 하찮은 개발자 달성 여부
    var hasAchievedJuniorDeveloper: Bool = false
}

// MARK: - Record Event
extension Record {
    enum Event {
        // Tap
        case tap(count: Int = 1)

        // Language Game
        case languageCorrect
        case languageIncorrect

        // Bug Dodging
        case dodgeGoldCollect
        case dodgeBugAvoid(currentCombo: Int)
        case dodgeFail

        // Stacking Game
        case stackingSuccess
        case stackingFail

        // Consumables
        case coffeeUse
        case energyDrinkUse

        // Play Time
        case playTime

        // Financial
        case earnMoney(Int)
        case spendMoney(Int)
        case skillUpgrade(cost: Int)
        case equipmentEnhancement(cost: Int)
        case consumablePurchase(cost: Int)
        case housingMove(cost: Int)

        // Achievements
        case tutorialComplete
        case juniorDeveloperAchieve
    }

    /// Record Event 기록
    func record(_ event: Event) {
        switch event {
        case .tap(let count):
            totalTapCount += count

        case .languageCorrect:
            languageCorrectCount += 1
            languageConsecutiveCorrect += 1

        case .languageIncorrect:
            languageConsecutiveCorrect = 0

        case .dodgeGoldCollect:
            dodgeGoldCollectedCount += 1

        case .dodgeBugAvoid(let currentCombo):
            dodgeBugAvoidedCount += 1
            dodgeMaxCombo = max(currentCombo, dodgeMaxCombo)

        case .dodgeFail:
            dodgeBugCollectCount += 1

        case .stackingSuccess:
            stackingSuccessCount += 1
            stackConsecutiveSuccess += 1

        case .stackingFail:
            stackConsecutiveSuccess = 0

        case .coffeeUse:
            coffeeUseCount += 1

        case .energyDrinkUse:
            energyDrinkUseCount += 1

        case .playTime:
            totalPlayTime += 1

        case .earnMoney(let amount):
            totalEarnedMoney += amount

        case .spendMoney(let amount):
            totalSpentMoney += amount

        case .skillUpgrade(let cost):
            totalSkillUpgradeCost += cost

        case .equipmentEnhancement(let cost):
            totalEquipmentEnhancementCost += cost

        case .consumablePurchase(let cost):
            totalConsumablePurchaseCost += cost

        case .housingMove(let cost):
            totalHousingMoveCost += cost

        case .tutorialComplete:
            tutorialCompleted = true

        case .juniorDeveloperAchieve:
            hasAchievedJuniorDeveloper = true
        }
        /// 미션 상태 업데이트
        missionSystem.updateCompletedMissions(record: self)
    }
}
