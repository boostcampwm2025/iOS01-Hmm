//
//  MissionFactory.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-08.
//

import Foundation

/// 미션 목록을 생성하는 팩토리
struct MissionFactory {
    /// 전체 미션 목록을 생성합니다.
    /// - Returns: 모든 미션의 배열
    static func createAllMissions() -> [Mission] {
        [
            // MARK: - 탭 관련 미션
            createTapMission(id: 1, title: "탭따구리", targetCount: 10000, reward: Cost(diamond: 15)),
            createTapMission(id: 6, title: "신의 손가락", targetCount: 100000, reward: Cost(diamond: 30)),

            // MARK: - 아이템 사용 관련 미션
            createCoffeeMission(id: 2, title: "커피 학살자", targetCount: 10000, reward: Cost(gold: 150000)),
            createEnergyDrinkMission(id: 7, title: "에너지 수호자", targetCount: 10000, reward: Cost(gold: 150000)),

            // MARK: - 플레이 시간 관련 미션
            createTotalPlayTimeMission(id: 3, title: "거북목의 형상", hours: 100, reward: Cost(gold: 150000)),
            createTapGamePlayTimeMission(id: 5, title: "판교의 등대", hours: 3, reward: Cost(diamond: 15)),

            // MARK: - 튜토리얼 관련 미션
            createTutorialMission(id: 4, title: "충실한 기본기", reward: Cost(gold: 1000)),

            // MARK: - 언어 맞추기 게임 관련 미션
            createLanguageGameMission(id: 8, title: "정답 자판기", targetCount: 1000, reward: Cost()),
            createLanguageGameMission(id: 9, title: "인간 스캐너", targetCount: 2000, reward: Cost()),
            createLanguageGameMission(id: 10, title: "명탐정의 돋보기", targetCount: 5000, reward: Cost()),
            createLanguageGameMission(id: 11, title: "현미경 눈동자", targetCount: 10000, reward: Cost()),

            // MARK: - 버그 피하기 게임 관련 미션
            createDodgeGamePlayCountMission(id: 12, title: "로그는 쌓이고", targetCount: 1000, reward: Cost()),
            createDodgeGamePlayCountMission(id: 13, title: "버그와의 공존", targetCount: 10000, reward: Cost()),
            createDodgeGameBestScoreMission(id: 14, title: "정상이라는 착각", targetScore: 100, reward: Cost()),
            createDodgeGameBestScoreMission(id: 15, title: "러브버그", targetScore: 500, reward: Cost()),

            // MARK: - 물건 쌓기 게임 관련 미션
            createStackingFailureMission(id: 16, title: "트롤의 왕", targetCount: 100, reward: Cost()),
            createStackingHeightMission(id: 17, title: "바벨탑 건축가", targetHeight: 1000, reward: Cost()),
            createStackingBombDodgeMission(id: 18, title: "회피의 달인", targetCount: 100, reward: Cost()),
            createStackingBombCountMission(id: 19, title: "붐버맨", targetCount: 100, reward: Cost())
        ]
    }

    // MARK: - 탭 관련 미션 생성
    private static func createTapMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "탭 \(targetCount)회 달성",
            targetValue: targetCount,
            updateCondition: { $0.totalTapCount },
            completeCondition: { $0.totalTapCount >= targetCount },
            reward: reward
        )
    }

    // MARK: - 아이템 사용 관련 미션 생성
    private static func createCoffeeMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "커피 \(targetCount)회 달성",
            targetValue: targetCount,
            updateCondition: { $0.coffeeUseCount },
            completeCondition: { $0.coffeeUseCount >= targetCount },
            reward: reward
        )
    }

    private static func createEnergyDrinkMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "박하스 \(targetCount)회 달성",
            targetValue: targetCount,
            updateCondition: { $0.energyDrinkUseCount },
            completeCondition: { $0.energyDrinkUseCount >= targetCount },
            reward: reward
        )
    }

    // MARK: - 플레이 시간 관련 미션 생성
    private static func createTotalPlayTimeMission(id: Int, title: String, hours: Int, reward: Cost) -> Mission {
        let seconds = hours * 3600
        return Mission(
            id: id,
            title: title,
            description: "총 플레이 \(hours)시간",
            targetValue: seconds,
            updateCondition: { Int($0.totalPlayTime) },
            completeCondition: { $0.totalPlayTime >= TimeInterval(seconds) },
            reward: reward
        )
    }

    private static func createTapGamePlayTimeMission(id: Int, title: String, hours: Int, reward: Cost) -> Mission {
        let seconds = hours * 3600
        return Mission(
            id: id,
            title: title,
            description: "코드짜기 누적 플레이 시간 \(hours)시간 달성",
            targetValue: seconds,
            updateCondition: { Int($0.tapGamePlayTime) },
            completeCondition: { $0.tapGamePlayTime >= TimeInterval(seconds) },
            reward: reward
        )
    }

    // MARK: - 튜토리얼 관련 미션 생성
    private static func createTutorialMission(id: Int, title: String, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "유저가 튜토리얼을 완료하면 수여",
            targetValue: 1,
            updateCondition: { $0.tutorialCompleted ? 1 : 0 },
            completeCondition: { $0.tutorialCompleted },
            reward: reward
        )
    }

    // MARK: - 언어 맞추기 게임 관련 미션 생성
    private static func createLanguageGameMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "정답 \(targetCount)회 달성",
            targetValue: targetCount,
            updateCondition: { $0.languageCorrectCount },
            completeCondition: { $0.languageCorrectCount >= targetCount },
            reward: reward
        )
    }

    // MARK: - 버그 피하기 게임 관련 미션 생성
    private static func createDodgeGamePlayCountMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "버그 피하기 \(targetCount)회 달성",
            targetValue: targetCount,
            updateCondition: { $0.dodgeGamePlayCount },
            completeCondition: { $0.dodgeGamePlayCount >= targetCount },
            reward: reward
        )
    }

    private static func createDodgeGameBestScoreMission(id: Int, title: String, targetScore: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "버그 피하기 \(targetScore)점 달성",
            targetValue: targetScore,
            updateCondition: { $0.dodgeGameBestScore },
            completeCondition: { $0.dodgeGameBestScore >= targetScore },
            reward: reward
        )
    }

    // MARK: - 물건 쌓기 게임 관련 미션 생성
    private static func createStackingFailureMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "물건 \(targetCount)회 투하 실패",
            targetValue: targetCount,
            updateCondition: { $0.stackConsecutiveFailures },
            completeCondition: { $0.stackConsecutiveFailures >= targetCount },
            reward: reward
        )
    }

    private static func createStackingHeightMission(id: Int, title: String, targetHeight: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "물건 \(targetHeight)층 쌓기 달성",
            targetValue: targetHeight,
            updateCondition: { $0.stackMaxHeight },
            completeCondition: { $0.stackMaxHeight >= targetHeight },
            reward: reward
        )
    }

    private static func createStackingBombDodgeMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "폭탄 \(targetCount)회 회피 달성",
            targetValue: targetCount,
            updateCondition: { $0.stackingBombDodgeCount },
            completeCondition: { $0.stackingBombDodgeCount >= targetCount },
            reward: reward
        )
    }

    private static func createStackingBombCountMission(id: Int, title: String, targetCount: Int, reward: Cost) -> Mission {
        Mission(
            id: id,
            title: title,
            description: "폭탄 \(targetCount)회 투하 달성",
            targetValue: targetCount,
            updateCondition: { $0.stackingBombCount },
            completeCondition: { $0.stackingBombCount >= targetCount },
            reward: reward
        )
    }
}
