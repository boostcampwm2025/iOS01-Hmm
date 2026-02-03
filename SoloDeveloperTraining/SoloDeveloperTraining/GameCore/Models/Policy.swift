//
//  Policy.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/26/26.
//

import Foundation

enum Policy {
    // MARK: - 커리어 시스템 (기준점)
    /// 단계별 필요 누적 재산 (밸런스에 맞춰 약 20× 상향)
    enum Career {
        static let unemployed = 0
        static let laptopOwner = 100_000
        static let aspiringDeveloper = 1_000_000
        static let juniorDeveloper = 20_000_000
        static let normalDeveloper = 2_000_000_000
        static let nightOwlDeveloper = 20_000_000_000
        static let skilledDeveloper = 200_000_000_000
        static let famousDeveloper = 2_000_000_000_000
        static let allRounderDeveloper = 100_000_000_000_000   // 100조
        static let worldClassDeveloper = 2_000_000_000_000_000 // 2000조: 만렙

        /// 게임별 해금 조건 (2단계씩: 탭 0 → 언어 2 → 버그 4 → 데이터 6)
        enum GameUnlock {
            static let tap = unemployed           // 0단계
            static let language = aspiringDeveloper   // 2단계
            static let dodge = normalDeveloper        // 4단계
            static let stack = skilledDeveloper       // 6단계
        }
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

        /// 코드 짜기 (TapGame) — 피버 상승량 대폭 하향
        enum Tap {
            static let decreasePercent: Double = 1.5
            static let gainPerTap: Double = 2.0
        }

        /// 언어 맞추기 (LanguageGame)
        enum Language {
            static let decreasePercent: Double = 1.5
            static let gainPerCorrect: Double = 33.0
            static let lossPerIncorrect: Double = -33.0
        }

        /// 버그 피하기 (DodgeGame)
        enum Dodge {
            static let decreasePercent: Double = 1.2
            static let gainPerSmallGold: Double = 33.0
            static let gainPerLargeGold: Double = 50.0
            static let gainPerBugDodge: Double = 15.0
            static let lossPerBugHit: Double = -20.0
        }

        /// 데이터 쌓기 (StackGame)
        enum Stack {
            static let decreasePercent: Double = 1.0
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
            static let secondsPerQuestion: Int = 20             // 문제당 제한 시간
            static let diamondsPerCorrect: Int = 5              // 정답당 다이아
        }
    }

    // MARK: - 스킬 시스템 (초반 성장 가속)
    // *전략: 초반 스킬 비용을 낮추고 효율을 높여 '클리커'의 재미를 느끼게 함
    enum Skill {
        // 공통 레벨 범위 (모든 게임 통일)
        static let beginnerMinLevel: Int = 1
        static let beginnerMaxLevel: Int = 999
        static let intermediateMinLevel: Int = 0
        static let intermediateMaxLevel: Int = 999
        static let advancedMinLevel: Int = 0
        static let advancedMaxLevel: Int = 999

        /// 코드 짜기 (TapGame)
        enum Tap {
            // 기본 골드 단위 (상향: 최소 1)
            static let baseGold: Int = 1

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 1
            static let intermediateGoldMultiplier: Int = 10
            static let advancedGoldMultiplier: Int = 100

            // 업그레이드 비용 증가량
            static let beginnerGoldCostMultiplier: Int = 10
            static let intermediateGoldCostMultiplier: Int = 150
            static let advancedGoldCostMultiplier: Int = 2500
            static let diamondCostDivider: Int = 100
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 200
            static let advancedUnlockLevel: Int = 300
        }

        /// 언어 맞추기 (LanguageGame)
        /// * 분당 골드 = 탭의 3배 (피버 2.5 기준): 40정답/분 → Lv1,0,0 합 180
        enum Language {
            // 기본 골드 단위
            static let baseGold: Int = 45

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 45
            static let intermediateGoldMultiplier: Int = 450
            static let advancedGoldMultiplier: Int = 4500

            // 업그레이드 비용 증가량 (Tap 대비 스킬 합 비율 45배)
            static let beginnerGoldCostMultiplier: Int = 450
            static let intermediateGoldCostMultiplier: Int = 6750
            static let advancedGoldCostMultiplier: Int = 112_500
            static let diamondCostDivider: Int = 100
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 200
            static let advancedUnlockLevel: Int = 300
        }

        /// 버그 피하기 (DodgeGame)
        /// * 아무튼 개발자(20억) 해금 시 언어(초250·중300·고100) 분당 ~6천만 수준에 맞춤: Lv1,0,0 합 348,000
        enum Dodge {
            // 기본 골드 단위
            static let baseGold: Int = 87_000

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 87_000
            static let intermediateGoldMultiplier: Int = 870_000
            static let advancedGoldMultiplier: Int = 8_700_000

            // 업그레이드 비용 증가량 (스킬 합 비율에 맞춤)
            static let beginnerGoldCostMultiplier: Int = 870_000
            static let intermediateGoldCostMultiplier: Int = 13_050_000
            static let advancedGoldCostMultiplier: Int = 217_500_000
            static let diamondCostDivider: Int = 100
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 200
            static let advancedUnlockLevel: Int = 300
        }

        /// 데이터 쌓기 (StackGame)
        /// * 유능한 개발자(2000억) 해금 시 버그 피하기 대비 보상 상향: Lv1,0,0 합 9,000,000 (순 8회/분 → 분당 ~1.8억)
        enum Stack {
            // 기본 골드 단위
            static let baseGold: Int = 2_250_000

            // 티어별 골드 획득 증가량
            static let beginnerGoldMultiplier: Int = 2_250_000
            static let intermediateGoldMultiplier: Int = 22_500_000
            static let advancedGoldMultiplier: Int = 225_000_000

            // 업그레이드 비용 증가량 (스킬 합 비율에 맞춤)
            static let beginnerGoldCostMultiplier: Int = 22_500_000
            static let intermediateGoldCostMultiplier: Int = 3_375_000_000
            static let advancedGoldCostMultiplier: Int = 56_250_000_000
            static let diamondCostDivider: Int = 100
            static let diamondCostMultiplier: Int = 10

            // 스킬 해금 조건
            static let intermediateUnlockLevel: Int = 200
            static let advancedUnlockLevel: Int = 300
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

    // MARK: - 장비 아이템
    // *밸런스: 업그레이드 비용 20×, 초당 골드 5× (부동산과 동일 비율)
    enum Equipment {
        // 업그레이드 비용 (골드)
        static let brokenUpgradeCost: Int = 100_000
        static let cheapUpgradeCost: Int = 2_000_000
        static let vintageUpgradeCost: Int = 40_000_000
        static let decentUpgradeCost: Int = 1_000_000_000
        static let premiumUpgradeCost: Int = 20_000_000_000
        static let diamondUpgradeCost: Int = 200_000_000_000
        static let limitedUpgradeCost: Int = 1_000_000_000_000
        static let nationalTreasureUpgradeCost: Int = 4_000_000_000_000

        // 업그레이드 비용 (다이아몬드) — 강화 시 골드와 함께 소모
        static let brokenUpgradeDiamond: Int = 5
        static let cheapUpgradeDiamond: Int = 10
        static let vintageUpgradeDiamond: Int = 20
        static let decentUpgradeDiamond: Int = 35
        static let premiumUpgradeDiamond: Int = 50
        static let diamondUpgradeDiamond: Int = 80
        static let limitedUpgradeDiamond: Int = 120
        static let nationalTreasureUpgradeDiamond: Int = 0

        // 업그레이드 성공 확률 (모든 장비 공통)
        static let brokenSuccessRate: Double = 1.0
        static let cheapSuccessRate: Double = 0.8
        static let vintageSuccessRate: Double = 0.6
        static let decentSuccessRate: Double = 0.4
        static let premiumSuccessRate: Double = 0.3
        static let diamondSuccessRate: Double = 0.2
        static let limitedSuccessRate: Double = 0.1
        static let nationalTreasureSuccessRate: Double = 0.05

        /// 초당 획득 골드량 (키보드·마우스·모니터·의자 동일)
        enum Keyboard {
            static let brokenGoldPerSecond: Int = 0
            static let cheapGoldPerSecond: Int = 1_250
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 750_000
            static let premiumGoldPerSecond: Int = 17_500_000
            static let diamondGoldPerSecond: Int = 200_000_000
            static let limitedGoldPerSecond: Int = 1_250_000_000
            static let nationalTreasureGoldPerSecond: Int = 6_000_000_000
        }

        /// 마우스
        enum Mouse {
            static let brokenGoldPerSecond: Int = 0
            static let cheapGoldPerSecond: Int = 1_250
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 750_000
            static let premiumGoldPerSecond: Int = 17_500_000
            static let diamondGoldPerSecond: Int = 200_000_000
            static let limitedGoldPerSecond: Int = 1_250_000_000
            static let nationalTreasureGoldPerSecond: Int = 6_000_000_000
        }

        /// 모니터
        enum Monitor {
            static let brokenGoldPerSecond: Int = 0
            static let cheapGoldPerSecond: Int = 1_250
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 750_000
            static let premiumGoldPerSecond: Int = 17_500_000
            static let diamondGoldPerSecond: Int = 200_000_000
            static let limitedGoldPerSecond: Int = 1_250_000_000
            static let nationalTreasureGoldPerSecond: Int = 6_000_000_000
        }

        /// 의자
        enum Chair {
            static let brokenGoldPerSecond: Int = 0
            static let cheapGoldPerSecond: Int = 1_250
            static let vintageGoldPerSecond: Int = 30_000
            static let decentGoldPerSecond: Int = 750_000
            static let premiumGoldPerSecond: Int = 17_500_000
            static let diamondGoldPerSecond: Int = 200_000_000
            static let limitedGoldPerSecond: Int = 1_250_000_000
            static let nationalTreasureGoldPerSecond: Int = 6_000_000_000
        }
    }

    // MARK: - 부동산 아이템 (로망 실현 및 자동 사냥 기지)
    // *밸런스: 가격·초당 골드를 분당 3배수 경제에 맞춤 (가격 20×, 초당 골드 5× → 회수 시간 약 4배)
    enum Housing {
        // 구입 비용
        static let streetPurchaseCost: Int = 0
        static let semiBasementPurchaseCost: Int = 10_000_000
        static let rooftopPurchaseCost: Int = 200_000_000
        static let villaPurchaseCost: Int = 10_000_000_000
        static let apartmentPurchaseCost: Int = 100_000_000_000
        static let housePurchaseCost: Int = 1_000_000_000_000
        static let pentHousePurchaseCost: Int = 4_000_000_000_000

        // 초당 골드 획득 (분당 = ×60)
        static let streetGoldPerSecond: Int = 0
        static let semiBasementGoldPerSecond: Int = 2_500
        static let rooftopGoldPerSecond: Int = 50_000
        static let villaGoldPerSecond: Int = 2_500_000
        static let apartmentGoldPerSecond: Int = 25_000_000
        static let houseGoldPerSecond: Int = 250_000_000
        static let pentHouseGoldPerSecond: Int = 1_000_000_000
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
