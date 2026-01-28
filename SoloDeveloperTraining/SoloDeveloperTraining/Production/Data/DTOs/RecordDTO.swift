//
//  RecordDTO.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-26.
//

import Foundation

struct RecordDTO: Codable {
    // Financial Records
    let totalEarnedMoney: Int
    let totalSpentMoney: Int
    let totalSkillUpgradeCost: Int
    let totalEquipmentEnhancementCost: Int
    let totalConsumablePurchaseCost: Int
    let totalHousingMoveCost: Int

    // Tap Records
    let totalTapCount: Int

    // Language Game Records
    let languageCorrectCount: Int
    let languageConsecutiveCorrect: Int

    // Bug Dodging Records
    let dodgeGoldCollectedCount: Int
    let dodgeMaxCombo: Int
    let dodgeBugAvoidedCount: Int
    let dodgeBugCollectCount: Int

    // Stacking Game Records
    let stackingSuccessCount: Int
    let stackConsecutiveSuccess: Int

    // Consumable Usage Records
    let coffeeUseCount: Int
    let energyDrinkUseCount: Int

    // Play Time Records
    let totalPlayTime: TimeInterval
    let tapGamePlayTime: TimeInterval
    let languageGamePlayTime: TimeInterval
    let dodgeGamePlayTime: TimeInterval
    let stackGamePlayTime: TimeInterval

    // Tutorial Records
    let tutorialCompleted: Bool

    // Career Records
    let hasAchievedJuniorDeveloper: Bool

    // Mission States
    let missionStates: [MissionStateDTO]

    init(from record: Record) {
        self.totalEarnedMoney = record.totalEarnedMoney
        self.totalSpentMoney = record.totalSpentMoney
        self.totalSkillUpgradeCost = record.totalSkillUpgradeCost
        self.totalEquipmentEnhancementCost = record.totalEquipmentEnhancementCost
        self.totalConsumablePurchaseCost = record.totalConsumablePurchaseCost
        self.totalHousingMoveCost = record.totalHousingMoveCost
        self.totalTapCount = record.totalTapCount
        self.languageCorrectCount = record.languageCorrectCount
        self.languageConsecutiveCorrect = record.languageConsecutiveCorrect
        self.dodgeGoldCollectedCount = record.dodgeGoldCollectedCount
        self.dodgeMaxCombo = record.dodgeMaxCombo
        self.dodgeBugAvoidedCount = record.dodgeBugAvoidedCount
        self.dodgeBugCollectCount = record.dodgeBugCollectCount
        self.stackingSuccessCount = record.stackingSuccessCount
        self.stackConsecutiveSuccess = record.stackConsecutiveSuccess
        self.coffeeUseCount = record.coffeeUseCount
        self.energyDrinkUseCount = record.energyDrinkUseCount
        self.totalPlayTime = record.totalPlayTime
        self.tapGamePlayTime = record.tapGamePlayTime
        self.languageGamePlayTime = record.languageGamePlayTime
        self.dodgeGamePlayTime = record.dodgeGamePlayTime
        self.stackGamePlayTime = record.stackGamePlayTime
        self.tutorialCompleted = record.tutorialCompleted
        self.hasAchievedJuniorDeveloper = record.hasAchievedJuniorDeveloper
        self.missionStates = record.missionSystem.missions.map { MissionStateDTO(from: $0) }
    }

    func toRecord() -> Record {
        let record = Record(missionSystem: MissionSystem(missions: MissionFactory.createAllMissions()))

        // Financial Records
        record.totalEarnedMoney = totalEarnedMoney
        record.totalSpentMoney = totalSpentMoney
        record.totalSkillUpgradeCost = totalSkillUpgradeCost
        record.totalEquipmentEnhancementCost = totalEquipmentEnhancementCost
        record.totalConsumablePurchaseCost = totalConsumablePurchaseCost
        record.totalHousingMoveCost = totalHousingMoveCost

        // Tap Records
        record.totalTapCount = totalTapCount

        // Language Game Records
        record.languageCorrectCount = languageCorrectCount
        record.languageConsecutiveCorrect = languageConsecutiveCorrect

        // Bug Dodging Records
        record.dodgeGoldCollectedCount = dodgeGoldCollectedCount
        record.dodgeMaxCombo = dodgeMaxCombo
        record.dodgeBugAvoidedCount = dodgeBugAvoidedCount
        record.dodgeBugCollectCount = dodgeBugCollectCount

        // Stacking Game Records
        record.stackingSuccessCount = stackingSuccessCount
        record.stackConsecutiveSuccess = stackConsecutiveSuccess

        // Consumable Usage Records
        record.coffeeUseCount = coffeeUseCount
        record.energyDrinkUseCount = energyDrinkUseCount

        // Play Time Records
        record.totalPlayTime = totalPlayTime
        record.tapGamePlayTime = tapGamePlayTime
        record.languageGamePlayTime = languageGamePlayTime
        record.dodgeGamePlayTime = dodgeGamePlayTime
        record.stackGamePlayTime = stackGamePlayTime

        // Tutorial Records
        record.tutorialCompleted = tutorialCompleted

        // Career Records
        record.hasAchievedJuniorDeveloper = hasAchievedJuniorDeveloper

        // Mission States 복원
        for missionState in missionStates {
            if let mission = record.missionSystem.missions.first(where: { $0.id == missionState.id }) {
                mission.currentValue = missionState.currentValue
                mission.state = missionState.state.toMissionState()
            }
        }

        return record
    }
}

struct MissionStateDTO: Codable {
    let id: Int
    let currentValue: Int
    let state: MissionStateRawDTO

    init(from mission: Mission) {
        self.id = mission.id
        self.currentValue = mission.currentValue
        self.state = MissionStateRawDTO(from: mission.state)
    }
}

struct MissionStateRawDTO: Codable {
    let rawValue: Int

    init(from state: Mission.State) {
        self.rawValue = state.rawValue
    }

    func toMissionState() -> Mission.State {
        Mission.State(rawValue: rawValue) ?? .inProgress
    }
}
