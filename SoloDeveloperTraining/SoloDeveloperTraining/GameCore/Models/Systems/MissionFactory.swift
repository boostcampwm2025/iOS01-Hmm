//
//  MissionFactory.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-08.
//

import Foundation

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length

/// 미션 목록을 생성하는 팩토리
struct MissionFactory {

    // MARK: - Mission Type

    /// 미션 타입별 업데이트 조건과 완료 조건 정의
    enum MissionType {
        case tap
        case languageMatch
        case bugDodge
        case stackItem
        case playTime
        case coffee
        case energyDrink
        case languageConsecutive
        case bugDodgeConsecutive
        case stackConsecutive
        case tutorial
        case career

        /// Record로부터 현재 값을 가져오는 조건
        var currentValue: (Record) -> Int {
            switch self {
            case .tap:
                return { $0.totalTapCount }
            case .languageMatch:
                return { $0.languageCorrectCount }
            case .bugDodge:
                return { $0.goldHitCount }
            case .stackItem:
                return { $0.stackingSuccessCount }
            case .playTime:
                return { Int($0.totalPlayTime) }
            case .coffee:
                return { $0.coffeeUseCount }
            case .energyDrink:
                return { $0.energyDrinkUseCount }
            case .languageConsecutive:
                return { $0.languageConsecutiveCorrect }
            case .bugDodgeConsecutive:
                return { $0.dodgeConsecutiveSuccess }
            case .stackConsecutive:
                return { $0.stackConsecutiveSuccess }
            case .tutorial:
                return { $0.tutorialCompleted ? 1 : 0 }
            case .career:
                return { $0.hasAchievedJuniorDeveloper ? 1 : 0 }
            }
        }

        /// 완료 조건 (nil이면 기본 체크: currentValue >= targetValue)
        var completeCondition: ((Record) -> Bool)? {
            switch self {
            case .tutorial:
                return { $0.tutorialCompleted }
            case .career:
                return { $0.hasAchievedJuniorDeveloper }
            default:
                return nil
            }
        }
    }

    // MARK: - Mission Configuration

    /// 미션 생성을 위한 설정 구조체
    struct MissionConfig {
        let id: Int
        let title: String
        let description: String
        let targetValue: Int
        let reward: Cost
        let type: MissionType
    }

    // MARK: - Factory Method

    /// 전체 미션 목록 생성
    /// - Returns: 모든 미션의 배열 (총 32개)
    static func createAllMissions() -> [Mission] {
        let configs: [MissionConfig] = [
            // MARK: - 코드짜기 (탭)
            MissionConfig(
                id: MissionConstants.CodeTap.id1,
                title: MissionConstants.CodeTap.title1,
                description: MissionConstants.CodeTap.description1,
                targetValue: MissionConstants.CodeTap.target1,
                reward: MissionConstants.CodeTap.reward1,
                type: .tap
            ),
            MissionConfig(
                id: MissionConstants.CodeTap.id2,
                title: MissionConstants.CodeTap.title2,
                description: MissionConstants.CodeTap.description2,
                targetValue: MissionConstants.CodeTap.target2,
                reward: MissionConstants.CodeTap.reward2,
                type: .tap
            ),
            MissionConfig(
                id: MissionConstants.CodeTap.id3,
                title: MissionConstants.CodeTap.title3,
                description: MissionConstants.CodeTap.description3,
                targetValue: MissionConstants.CodeTap.target3,
                reward: MissionConstants.CodeTap.reward3,
                type: .tap
            ),

            // MARK: - 언어맞추기 (맞춘 횟수)
            MissionConfig(
                id: MissionConstants.LanguageMatch.id1,
                title: MissionConstants.LanguageMatch.title1,
                description: MissionConstants.LanguageMatch.description1,
                targetValue: MissionConstants.LanguageMatch.target1,
                reward: MissionConstants.LanguageMatch.reward1,
                type: .languageMatch
            ),
            MissionConfig(
                id: MissionConstants.LanguageMatch.id2,
                title: MissionConstants.LanguageMatch.title2,
                description: MissionConstants.LanguageMatch.description2,
                targetValue: MissionConstants.LanguageMatch.target2,
                reward: MissionConstants.LanguageMatch.reward2,
                type: .languageMatch
            ),
            MissionConfig(
                id: MissionConstants.LanguageMatch.id3,
                title: MissionConstants.LanguageMatch.title3,
                description: MissionConstants.LanguageMatch.description3,
                targetValue: MissionConstants.LanguageMatch.target3,
                reward: MissionConstants.LanguageMatch.reward3,
                type: .languageMatch
            ),

            // MARK: - 버그피하기 (골드 획득)
            MissionConfig(
                id: MissionConstants.BugDodge.id1,
                title: MissionConstants.BugDodge.title1,
                description: MissionConstants.BugDodge.description1,
                targetValue: MissionConstants.BugDodge.target1,
                reward: MissionConstants.BugDodge.reward1,
                type: .bugDodge
            ),
            MissionConfig(
                id: MissionConstants.BugDodge.id2,
                title: MissionConstants.BugDodge.title2,
                description: MissionConstants.BugDodge.description2,
                targetValue: MissionConstants.BugDodge.target2,
                reward: MissionConstants.BugDodge.reward2,
                type: .bugDodge
            ),
            MissionConfig(
                id: MissionConstants.BugDodge.id3,
                title: MissionConstants.BugDodge.title3,
                description: MissionConstants.BugDodge.description3,
                targetValue: MissionConstants.BugDodge.target3,
                reward: MissionConstants.BugDodge.reward3,
                type: .bugDodge
            ),

            // MARK: - 물건쌓기
            MissionConfig(
                id: MissionConstants.StackItem.id1,
                title: MissionConstants.StackItem.title1,
                description: MissionConstants.StackItem.description1,
                targetValue: MissionConstants.StackItem.target1,
                reward: MissionConstants.StackItem.reward1,
                type: .stackItem
            ),
            MissionConfig(
                id: MissionConstants.StackItem.id2,
                title: MissionConstants.StackItem.title2,
                description: MissionConstants.StackItem.description2,
                targetValue: MissionConstants.StackItem.target2,
                reward: MissionConstants.StackItem.reward2,
                type: .stackItem
            ),
            MissionConfig(
                id: MissionConstants.StackItem.id3,
                title: MissionConstants.StackItem.title3,
                description: MissionConstants.StackItem.description3,
                targetValue: MissionConstants.StackItem.target3,
                reward: MissionConstants.StackItem.reward3,
                type: .stackItem
            ),

            // MARK: - 플레이타임
            MissionConfig(
                id: MissionConstants.PlayTime.id1,
                title: MissionConstants.PlayTime.title1,
                description: MissionConstants.PlayTime.description1,
                targetValue: MissionConstants.PlayTime.targetHours1 * 3600,
                reward: MissionConstants.PlayTime.reward1,
                type: .playTime
            ),
            MissionConfig(
                id: MissionConstants.PlayTime.id2,
                title: MissionConstants.PlayTime.title2,
                description: MissionConstants.PlayTime.description2,
                targetValue: MissionConstants.PlayTime.targetHours2 * 3600,
                reward: MissionConstants.PlayTime.reward2,
                type: .playTime
            ),
            MissionConfig(
                id: MissionConstants.PlayTime.id3,
                title: MissionConstants.PlayTime.title3,
                description: MissionConstants.PlayTime.description3,
                targetValue: MissionConstants.PlayTime.targetHours3 * 3600,
                reward: MissionConstants.PlayTime.reward3,
                type: .playTime
            ),

            // MARK: - 커피
            MissionConfig(
                id: MissionConstants.Coffee.id1,
                title: MissionConstants.Coffee.title1,
                description: MissionConstants.Coffee.description1,
                targetValue: MissionConstants.Coffee.target1,
                reward: MissionConstants.Coffee.reward1,
                type: .coffee
            ),
            MissionConfig(
                id: MissionConstants.Coffee.id2,
                title: MissionConstants.Coffee.title2,
                description: MissionConstants.Coffee.description2,
                targetValue: MissionConstants.Coffee.target2,
                reward: MissionConstants.Coffee.reward2,
                type: .coffee
            ),
            MissionConfig(
                id: MissionConstants.Coffee.id3,
                title: MissionConstants.Coffee.title3,
                description: MissionConstants.Coffee.description3,
                targetValue: MissionConstants.Coffee.target3,
                reward: MissionConstants.Coffee.reward3,
                type: .coffee
            ),

            // MARK: - 박하스
            MissionConfig(
                id: MissionConstants.EnergyDrink.id1,
                title: MissionConstants.EnergyDrink.title1,
                description: MissionConstants.EnergyDrink.description1,
                targetValue: MissionConstants.EnergyDrink.target1,
                reward: MissionConstants.EnergyDrink.reward1,
                type: .energyDrink
            ),
            MissionConfig(
                id: MissionConstants.EnergyDrink.id2,
                title: MissionConstants.EnergyDrink.title2,
                description: MissionConstants.EnergyDrink.description2,
                targetValue: MissionConstants.EnergyDrink.target2,
                reward: MissionConstants.EnergyDrink.reward2,
                type: .energyDrink
            ),
            MissionConfig(
                id: MissionConstants.EnergyDrink.id3,
                title: MissionConstants.EnergyDrink.title3,
                description: MissionConstants.EnergyDrink.description3,
                targetValue: MissionConstants.EnergyDrink.target3,
                reward: MissionConstants.EnergyDrink.reward3,
                type: .energyDrink
            ),

            // MARK: - 언어맞추기 (연속 성공)
            MissionConfig(
                id: MissionConstants.LanguageConsecutive.id1,
                title: MissionConstants.LanguageConsecutive.title1,
                description: MissionConstants.LanguageConsecutive.description1,
                targetValue: MissionConstants.LanguageConsecutive.target1,
                reward: MissionConstants.LanguageConsecutive.reward1,
                type: .languageConsecutive
            ),
            MissionConfig(
                id: MissionConstants.LanguageConsecutive.id2,
                title: MissionConstants.LanguageConsecutive.title2,
                description: MissionConstants.LanguageConsecutive.description2,
                targetValue: MissionConstants.LanguageConsecutive.target2,
                reward: MissionConstants.LanguageConsecutive.reward2,
                type: .languageConsecutive
            ),
            MissionConfig(
                id: MissionConstants.LanguageConsecutive.id3,
                title: MissionConstants.LanguageConsecutive.title3,
                description: MissionConstants.LanguageConsecutive.description3,
                targetValue: MissionConstants.LanguageConsecutive.target3,
                reward: MissionConstants.LanguageConsecutive.reward3,
                type: .languageConsecutive
            ),

            // MARK: - 버그피하기 (연속 성공)
            MissionConfig(
                id: MissionConstants.BugDodgeConsecutive.id1,
                title: MissionConstants.BugDodgeConsecutive.title1,
                description: MissionConstants.BugDodgeConsecutive.description1,
                targetValue: MissionConstants.BugDodgeConsecutive.target1,
                reward: MissionConstants.BugDodgeConsecutive.reward1,
                type: .bugDodgeConsecutive
            ),
            MissionConfig(
                id: MissionConstants.BugDodgeConsecutive.id2,
                title: MissionConstants.BugDodgeConsecutive.title2,
                description: MissionConstants.BugDodgeConsecutive.description2,
                targetValue: MissionConstants.BugDodgeConsecutive.target2,
                reward: MissionConstants.BugDodgeConsecutive.reward2,
                type: .bugDodgeConsecutive
            ),
            MissionConfig(
                id: MissionConstants.BugDodgeConsecutive.id3,
                title: MissionConstants.BugDodgeConsecutive.title3,
                description: MissionConstants.BugDodgeConsecutive.description3,
                targetValue: MissionConstants.BugDodgeConsecutive.target3,
                reward: MissionConstants.BugDodgeConsecutive.reward3,
                type: .bugDodgeConsecutive
            ),

            // MARK: - 데이터 쌓기 (연속 성공)
            MissionConfig(
                id: MissionConstants.StackConsecutive.id1,
                title: MissionConstants.StackConsecutive.title1,
                description: MissionConstants.StackConsecutive.description1,
                targetValue: MissionConstants.StackConsecutive.target1,
                reward: MissionConstants.StackConsecutive.reward1,
                type: .stackConsecutive
            ),
            MissionConfig(
                id: MissionConstants.StackConsecutive.id2,
                title: MissionConstants.StackConsecutive.title2,
                description: MissionConstants.StackConsecutive.description2,
                targetValue: MissionConstants.StackConsecutive.target2,
                reward: MissionConstants.StackConsecutive.reward2,
                type: .stackConsecutive
            ),
            MissionConfig(
                id: MissionConstants.StackConsecutive.id3,
                title: MissionConstants.StackConsecutive.title3,
                description: MissionConstants.StackConsecutive.description3,
                targetValue: MissionConstants.StackConsecutive.target3,
                reward: MissionConstants.StackConsecutive.reward3,
                type: .stackConsecutive
            ),

            // MARK: - 커리어
            MissionConfig(
                id: MissionConstants.Career.id,
                title: MissionConstants.Career.title,
                description: MissionConstants.Career.description,
                targetValue: 1,
                reward: MissionConstants.Career.reward,
                type: .career
            ),

            // MARK: - 튜토리얼
            MissionConfig(
                id: MissionConstants.Tutorial.id,
                title: MissionConstants.Tutorial.title,
                description: MissionConstants.Tutorial.description,
                targetValue: 1,
                reward: MissionConstants.Tutorial.reward,
                type: .tutorial
            )
        ]

        return configs.map { createMission(from: $0) }
    }

    // MARK: - Private Helper

    /// MissionConfig로부터 Mission 인스턴스를 생성합니다.
    private static func createMission(from config: MissionConfig) -> Mission {
        Mission(
            id: config.id,
            title: config.title,
            description: config.description,
            targetValue: config.targetValue,
            updateCondition: config.type.currentValue,
            completeCondition: config.type.completeCondition,
            reward: config.reward
        )
    }
}
