//
//  Policy.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/26/26.
//

import Foundation

enum Policy {
    // MARK: - 커리어 시스템 (기준점)
    /// 단계별 필요 누적 재산
    enum Career {
        static let unemployed = 0
        static let laptopOwner = 1_000 // 1천
        static let aspiringDeveloper = 10_000 // 1만
        static let juniorDeveloper = 100_000 // 10만
        static let normalDeveloper = 1_000_000 // 100만
        static let nightOwlDeveloper = 10_000_000 // 1,000만
        static let skilledDeveloper = 100_000_000 // 1억
        static let famousDeveloper = 2_000_000_000 // 20억
        static let allRounderDeveloper = 50_000_000_000 // 500억
        static let worldClassDeveloper = 1_000_000_000_000 // 1조
    }

    // MARK: - 피버 시스템 (쾌감 증대)
    enum Fever {
        /// 공통 설정
        static let maxPercent: Double = 400.0
        static let decreaseInterval: TimeInterval = 0.05

        /// 피버 단계 경계값
        enum StageThreshold {
            static let stage0: Double = 0
            static let stage1: Double = 100
            static let stage2: Double = 200
            static let stage3: Double = 300
        }

        /// 피버 단계별 배수 (상향 조정: 피버 시 확실한 보상)
        enum Multiplier {
            static let stage0: Double = 1.0 // 0~100
            static let stage1: Double = 1.5 // 1.2 -> 1.5
            static let stage2: Double = 2.5 // 1.5 -> 2.5
            static let stage3: Double = 5.0 // 2.0 -> 5.0
        }

        /// 코드 짜기 (TapGame)
        enum Tap {
            static let decreasePercent: Double = 1.5
            static let gainPerTap: Double = 10.0
        }

        /// 언어 맞추기 (LanguageGame)
        enum Language {
            static let decreasePercent: Double = 1.5
            static let gainPerCorrect: Double = 33.0
            static let lossPerIncorrect: Double = -33.0
        }

        /// 버그 피하기 (DodgeGame)
        enum Dodge {
            static let decreasePercent: Double = 1.5
            static let gainPerSmallGold: Double = 33.0
            static let gainPerLargeGold: Double = 33.0
            static let gainPerBugDodge: Double = 10.0
            static let lossPerBugHit: Double = -50.0
        }

        /// 데이터 쌓기 (StackGame)
        enum Stack {
            static let decreasePercent: Double = 0.5
            static let gainPerSuccess: Double = 80.0
            static let lossPerFailure: Double = -40.0
        }
    }

    // MARK: - 게임별 상수
    enum Game {
        /// 코드 짜기 (TapGame)
        enum Tap {}  // 특수 상수 없음

        /// 언어 맞추기 (LanguageGame)
        enum Language {
            static let incorrectGoldLossMultiplier: Double = 0.5 // 오답시 골드 감소 (획득량의 0.5배)
        }

        /// 버그 피하기 (DodgeGame)
        enum Dodge {
            // 골드
            static let smallGoldMultiplier: Double = 1.5
            static let largeGoldMultiplier: Double = 2.0
            static let bugHitLossGoldMultiplier: Double = 0.5 // 버그 맞으면 골드 감소 (획득량의 0.5배)
            static let bugDodgeGoldMultiplier: Double = 0.5 // 버그 피하면 골드 획득

            // GameCore 설정
            static let updateFPS: Double = 120.0                // 업데이트 주기: 120fps
            static let spawnInterval: TimeInterval = 0.3        // 낙하물 생성 간격
            static let fallSpeed: CGFloat = 3.0                 // 낙하 속도

            // 생성 확률 (%)
            static let smallGoldSpawnRate: Int = 7
            static let largeGoldSpawnRate: Int = 3
            static let bugSpawnRate: Int = 90

            /// 모션 시스템
            enum Motion {
                static let deadZoneThreshold: Double = 0.05
                static let maxSpeed: CGFloat = 2000.0
                static let minSpeed: CGFloat = 300.0
            }
        }

        /// 데이터 쌓기 (StackGame)
        enum Stack {
            static let failureGoldLossMultiplier: Double = 0.5  // 실패시 골드 감소 (획득량의 0.5배)
        }

        /// 퀴즈 게임 (QuizGame)
        enum Quiz {
            static let questionsPerGame: Int = 3                // 게임당 문제 수
            static let secondsPerQuestion: Int = 60             // 문제당 제한 시간
            static let diamondsPerCorrect: Int = 5              // 정답당 다이아
        }
    }

    // MARK: - 스킬 시스템 (초반 성장 가속)
    // *전략: 초반 스킬 비용을 낮추고 효율을 높여 '클리커'의 재미를 느끼게 함
    enum Skill {
        // 공통 레벨 범위 (모든 게임 통일)
        static let beginnerMinLevel: Int = 1
        static let beginnerMaxLevel: Int = 9999
        static let intermediateMinLevel: Int = 0
        static let intermediateMaxLevel: Int = 9999
        static let advancedMinLevel: Int = 0
        static let advancedMaxLevel: Int = 9999

        /// 코드 짜기 (TapGame)
        enum Tap {
            // 기본 골드 단위 (상향: 최소 1)
            static let baseGold: Int = 1

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 10
            static let intermediateGoldMultiplier: Int = 15
            static let advancedGoldMultiplier: Int = 20

            // 업그레이드 비용 증가량
            static let beginnerGoldCostMultiplier: Int = 5
            static let intermediateGoldCostMultiplier: Int = 15
            static let advancedGoldCostMultiplier: Int = 25
            static let diamondCostDivider: Int = 1000
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 500
            static let advancedUnlockLevel: Int = 500
        }

        /// 언어 맞추기 (LanguageGame)
        enum Language {
            // 기본 골드 단위 (상향: 최소 1)
            static let baseGold: Int = 1

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 10
            static let intermediateGoldMultiplier: Int = 15
            static let advancedGoldMultiplier: Int = 20

            // 업그레이드 비용 증가량
            static let beginnerGoldCostMultiplier: Int = 5
            static let intermediateGoldCostMultiplier: Int = 15
            static let advancedGoldCostMultiplier: Int = 25
            static let diamondCostDivider: Int = 1000
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 500
            static let advancedUnlockLevel: Int = 500
        }

        /// 버그 피하기 (DodgeGame)
        enum Dodge {
            // 기본 골드 단위 (상향: 최소 1)
            static let baseGold: Int = 1

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 10
            static let intermediateGoldMultiplier: Int = 15
            static let advancedGoldMultiplier: Int = 20

            // 업그레이드 비용 증가량
            static let beginnerGoldCostMultiplier: Int = 5
            static let intermediateGoldCostMultiplier: Int = 15
            static let advancedGoldCostMultiplier: Int = 25
            static let diamondCostDivider: Int = 1000
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 500
            static let advancedUnlockLevel: Int = 500
        }

        /// 데이터 쌓기 (StackGame)
        enum Stack {
            // 기본 골드 단위 (상향: 최소 1)
            static let baseGold: Int = 1

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 10
            static let intermediateGoldMultiplier: Int = 15
            static let advancedGoldMultiplier: Int = 20

            // 업그레이드 비용 증가량
            static let beginnerGoldCostMultiplier: Int = 5
            static let intermediateGoldCostMultiplier: Int = 15
            static let advancedGoldCostMultiplier: Int = 25
            static let diamondCostDivider: Int = 1000
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 500
            static let advancedUnlockLevel: Int = 500
        }
    }

    // MARK: - 소비 아이템 (효과 강화)
    enum Consumable {
        /// 커피 (1초당 3씩 증가)
        enum Coffee {
            static let duration: Int = 15
            static let buffMultiplier: Double = 2.0
            static let priceDiamond: Int = 5
        }

        /// 박하스 (1초당 6씩 증가)
        enum EnergyDrink {
            static let duration: Int = 20
            static let buffMultiplier: Double = 3.0
            static let priceDiamond: Int = 10
        }
    }

    // MARK: - 장비 아이템 (가성비 개선)
    // *전략: 장비 4종(키보드, 마우스, 모니터, 의자)을 다 맞추면 다음 부동산으로 가기 쉽도록 설계
    enum Equipment {
        // 업그레이드 비용 (진입 장벽 완화)
        static let brokenUpgradeCost: Int = 3_000
        static let cheapUpgradeCost: Int = 30_000
        static let vintageUpgradeCost: Int = 300_000
        static let decentUpgradeCost: Int = 500_000
        static let premiumUpgradeCost: Int = 1_000_000
        static let diamondUpgradeCost: Int = 2_000_000
        static let limitedUpgradeCost: Int = 5_000_000
        static let nationalTreasureUpgradeCost: Int = 999_999_999_999

        // 업그레이드 성공 확률 (모든 장비 공통)
        static let brokenSuccessRate: Double = 1.0
        static let cheapSuccessRate: Double = 0.8
        static let vintageSuccessRate: Double = 0.6
        static let decentSuccessRate: Double = 0.4
        static let premiumSuccessRate: Double = 0.3
        static let diamondSuccessRate: Double = 0.2
        static let limitedSuccessRate: Double = 0.1
        static let nationalTreasureSuccessRate: Double = 0.05

        /// 초당 획득 골드량
        /// 장비 하나당 '다음 등급 장비 비용'의 1/100 정도는 벌어줘야 방치형 요소가 성립됨
        /// 키보드
        enum Keyboard {
            static let brokenGoldPerSecond: Int = 300
            static let cheapGoldPerSecond: Int = 3_000
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 1_000_000
            static let premiumGoldPerSecond: Int = 20_000_000
            static let diamondGoldPerSecond: Int = 500_000_000
            static let limitedGoldPerSecond: Int = 8_000_000_000
            static let nationalTreasureGoldPerSecond: Int = 100_000_000_000
        }

        /// 마우스
        enum Mouse {
            static let brokenGoldPerSecond: Int = 300
            static let cheapGoldPerSecond: Int = 3_000
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 1_000_000
            static let premiumGoldPerSecond: Int = 20_000_000
            static let diamondGoldPerSecond: Int = 500_000_000
            static let limitedGoldPerSecond: Int = 8_000_000_000
            static let nationalTreasureGoldPerSecond: Int = 100_000_000_000
        }

        /// 모니터
        enum Monitor {
            static let brokenGoldPerSecond: Int = 300
            static let cheapGoldPerSecond: Int = 3_000
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 1_000_000
            static let premiumGoldPerSecond: Int = 20_000_000
            static let diamondGoldPerSecond: Int = 500_000_000
            static let limitedGoldPerSecond: Int = 8_000_000_000
            static let nationalTreasureGoldPerSecond: Int = 100_000_000_000
        }

        /// 의자
        enum Chair {
            static let brokenGoldPerSecond: Int = 300
            static let cheapGoldPerSecond: Int = 3_000
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 1_000_000
            static let premiumGoldPerSecond: Int = 20_000_000
            static let diamondGoldPerSecond: Int = 500_000_000
            static let limitedGoldPerSecond: Int = 8_000_000_000
            static let nationalTreasureGoldPerSecond: Int = 100_000_000_000
        }
    }

    // MARK: - 부동산 아이템 (로망 실현 및 자동 사냥 기지)
    // *전략: 부동산 가격은 비싸지만, 이사 가면 기본 소득(Basic Income)이 확 늘어나도록 설정
    enum Housing {
        // 구입 비용
        static let streetPurchaseCost: Int = 0
        static let semiBasementPurchaseCost: Int = 500_000
        static let rooftopPurchaseCost: Int = 10_000_000
        static let villaPurchaseCost: Int = 500_000_000
        static let apartmentPurchaseCost: Int = 5_000_000_000
        static let housePurchaseCost: Int = 50_000_000_000
        static let pentHousePurchaseCost: Int = 200_000_000_000

        // 초당 골드 획득
        static let streetGoldPerSecond: Int = 0
        static let semiBasementGoldPerSecond: Int = 500
        static let rooftopGoldPerSecond: Int = 10_000
        static let villaGoldPerSecond: Int = 500_000
        static let apartmentGoldPerSecond: Int = 5_000_000
        static let houseGoldPerSecond: Int = 50_000_000
        static let pentHouseGoldPerSecond: Int = 200_000_000
    }

    // MARK: - 기타 시스템
    enum System {
        /// 자동 획득 시스템 (AutoGainSystem)
        enum AutoGain {
            static let interval: TimeInterval = 1.0  // 자동 획득 주기 (초)
        }

        /// 버프 시스템 (BuffSystem)
        enum Buff {
            static let decreaseInterval: TimeInterval = 1.0  // 버프 감소 주기 (초)
        }
    }
}
