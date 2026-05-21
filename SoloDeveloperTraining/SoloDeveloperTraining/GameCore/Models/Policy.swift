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
        static var unemployed: Int { policyStore.current.career.unemployed }
        static var laptopOwner: Int { policyStore.current.career.laptopOwner }
        static var aspiringDeveloper: Int { policyStore.current.career.aspiringDeveloper }
        static var juniorDeveloper: Int { policyStore.current.career.juniorDeveloper }
        static var normalDeveloper: Int { policyStore.current.career.normalDeveloper }
        static var nightOwlDeveloper: Int { policyStore.current.career.nightOwlDeveloper }
        static var skilledDeveloper: Int { policyStore.current.career.skilledDeveloper }
        static var famousDeveloper: Int { policyStore.current.career.famousDeveloper }
        static var allRounderDeveloper: Int { policyStore.current.career.allRounderDeveloper }
        static var worldClassDeveloper: Int { policyStore.current.career.worldClassDeveloper }
    }

    // MARK: - 피버 시스템 (쾌감 증대)
    enum Fever {
        /// 공통 설정
        static var maxPercent: Double { policyStore.current.fever.maxPercent }
        static var decreaseInterval: TimeInterval { policyStore.current.fever.decreaseInterval }

        /// 피버 단계 경계값
        enum StageThreshold {
            static var stage0: Double { policyStore.current.fever.stageThreshold.stage0 }
            static var stage1: Double { policyStore.current.fever.stageThreshold.stage1 }
            static var stage2: Double { policyStore.current.fever.stageThreshold.stage2 }
            static var stage3: Double { policyStore.current.fever.stageThreshold.stage3 }
        }

        /// 피버 단계별 배수 (상향 조정: 피버 시 확실한 보상)
        enum Multiplier {
            static var stage0: Double { policyStore.current.fever.multiplier.stage0 }
            static var stage1: Double { policyStore.current.fever.multiplier.stage1 }
            static var stage2: Double { policyStore.current.fever.multiplier.stage2 }
            static var stage3: Double { policyStore.current.fever.multiplier.stage3 }
        }

        /// 코드 짜기 (TapGame) — 피버 상승량 대폭 하향
        enum Tap {
            static var decreasePercent: Double { policyStore.current.fever.tap.decreasePercent }
            static var gainPerTap: Double { policyStore.current.fever.tap.gainPerTap }
        }

        /// 언어 맞추기 (LanguageGame)
        enum Language {
            static var decreasePercent: Double { policyStore.current.fever.language.decreasePercent }
            static var gainPerCorrect: Double { policyStore.current.fever.language.gainPerCorrect }
            static var lossPerIncorrect: Double { policyStore.current.fever.language.lossPerIncorrect }
        }

        /// 버그 피하기 (DodgeGame)
        enum Dodge {
            static var decreasePercent: Double { policyStore.current.fever.dodge.decreasePercent }
            static var gainPerSmallGold: Double { policyStore.current.fever.dodge.gainPerSmallGold }
            static var gainPerLargeGold: Double { policyStore.current.fever.dodge.gainPerLargeGold }
            static var gainPerBugDodge: Double { policyStore.current.fever.dodge.gainPerBugDodge }
            static var lossPerBugHit: Double { policyStore.current.fever.dodge.lossPerBugHit }
        }

        /// 데이터 쌓기 (StackGame)
        enum Stack {
            static var decreasePercent: Double { policyStore.current.fever.stack.decreasePercent }
            static var gainPerSuccess: Double { policyStore.current.fever.stack.gainPerSuccess }
            static var lossPerFailure: Double { policyStore.current.fever.stack.lossPerFailure }
        }
    }

    // MARK: - 게임별 상수
    enum Game {
        /// 게임별 해금 조건 (2단계씩: 탭 0 → 언어 2 → 버그 4 → 데이터 6)
        enum GameUnlock {
            static var tap: Int { Policy.Career.unemployed }
            static var language: Int { Policy.Career.aspiringDeveloper }
            static var dodge: Int { Policy.Career.normalDeveloper }
            static var stack: Int { Policy.Career.skilledDeveloper }
        }

        /// 코드 짜기 (TapGame)
        enum Tap {}  // 특수 상수 없음

        /// 언어 맞추기 (LanguageGame)
        enum Language {
            static var incorrectGoldLossMultiplier: Double { policyStore.current.game.language.incorrectGoldLossMultiplier }
        }

        /// 버그 피하기 (DodgeGame)
        enum Dodge {
            // 골드
            static var smallGoldMultiplier: Double { policyStore.current.game.dodge.smallGoldMultiplier }
            static var largeGoldMultiplier: Double { policyStore.current.game.dodge.largeGoldMultiplier }
            static var bugHitLossGoldMultiplier: Double { policyStore.current.game.dodge.bugHitLossGoldMultiplier }
            static var bugDodgeGoldMultiplier: Double { policyStore.current.game.dodge.bugDodgeGoldMultiplier }

            // GameCore 설정
            static var updateFPS: Double { policyStore.current.game.dodge.updateFPS }
            static var spawnInterval: TimeInterval { policyStore.current.game.dodge.spawnInterval }
            static var fallSpeed: CGFloat { CGFloat(policyStore.current.game.dodge.fallSpeed) }

            // 생성 확률 (%)
            static var smallGoldSpawnRate: Int { policyStore.current.game.dodge.smallGoldSpawnRate }
            static var largeGoldSpawnRate: Int { policyStore.current.game.dodge.largeGoldSpawnRate }
            static var bugSpawnRate: Int { policyStore.current.game.dodge.bugSpawnRate }

            /// 모션 시스템
            enum Motion {
                static var deadZoneThreshold: Double { policyStore.current.game.dodge.motion.deadZoneThreshold }
                static var maxSpeed: CGFloat { CGFloat(policyStore.current.game.dodge.motion.maxSpeed) }
                static var minSpeed: CGFloat { CGFloat(policyStore.current.game.dodge.motion.minSpeed) }
            }
        }

        /// 데이터 쌓기 (StackGame)
        enum Stack {
            static var failureGoldLossMultiplier: Double { policyStore.current.game.stack.failureGoldLossMultiplier }
        }

        /// 퀴즈 게임 (QuizGame)
        enum Quiz {
            static var questionsPerGame: Int { policyStore.current.game.quiz.questionsPerGame }
            static var secondsPerQuestion: Int { policyStore.current.game.quiz.secondsPerQuestion }
            static var diamondsPerCorrect: Int { policyStore.current.game.quiz.diamondsPerCorrect }
        }
    }

    // MARK: - 스킬 시스템 (초반 성장 가속)
    // *전략: 초반 스킬 비용을 낮추고 효율을 높여 '클리커'의 재미를 느끼게 함
    enum Skill {
        // 공통 레벨 범위 (모든 게임 통일)
        static var beginnerMinLevel: Int { policyStore.current.skill.beginnerMinLevel }
        static var beginnerMaxLevel: Int { policyStore.current.skill.beginnerMaxLevel }
        static var intermediateMinLevel: Int { policyStore.current.skill.intermediateMinLevel }
        static var intermediateMaxLevel: Int { policyStore.current.skill.intermediateMaxLevel }
        static var advancedMinLevel: Int { policyStore.current.skill.advancedMinLevel }
        static var advancedMaxLevel: Int { policyStore.current.skill.advancedMaxLevel }

        /// 코드 짜기 (TapGame)
        enum Tap {
            static var baseGold: Int { policyStore.current.skill.tap.baseGold }
            static var beginnerGoldMultiplier: Int { policyStore.current.skill.tap.beginnerGoldMultiplier }
            static var intermediateGoldMultiplier: Int { policyStore.current.skill.tap.intermediateGoldMultiplier }
            static var advancedGoldMultiplier: Int { policyStore.current.skill.tap.advancedGoldMultiplier }
            static var beginnerGoldCostMultiplier: Int { policyStore.current.skill.tap.beginnerGoldCostMultiplier }
            static var intermediateGoldCostMultiplier: Int { policyStore.current.skill.tap.intermediateGoldCostMultiplier }
            static var advancedGoldCostMultiplier: Int { policyStore.current.skill.tap.advancedGoldCostMultiplier }
            static var diamondCostDivider: Int { policyStore.current.skill.tap.diamondCostDivider }
            static var diamondCostMultiplier: Int { policyStore.current.skill.tap.diamondCostMultiplier }
            static var intermediateUnlockLevel: Int { policyStore.current.skill.tap.intermediateUnlockLevel }
            static var advancedUnlockLevel: Int { policyStore.current.skill.tap.advancedUnlockLevel }
        }

        /// 언어 맞추기 (LanguageGame)
        enum Language {
            static var baseGold: Int { policyStore.current.skill.language.baseGold }
            static var beginnerGoldMultiplier: Int { policyStore.current.skill.language.beginnerGoldMultiplier }
            static var intermediateGoldMultiplier: Int { policyStore.current.skill.language.intermediateGoldMultiplier }
            static var advancedGoldMultiplier: Int { policyStore.current.skill.language.advancedGoldMultiplier }
            static var beginnerGoldCostMultiplier: Int { policyStore.current.skill.language.beginnerGoldCostMultiplier }
            static var intermediateGoldCostMultiplier: Int { policyStore.current.skill.language.intermediateGoldCostMultiplier }
            static var advancedGoldCostMultiplier: Int { policyStore.current.skill.language.advancedGoldCostMultiplier }
            static var diamondCostDivider: Int { policyStore.current.skill.language.diamondCostDivider }
            static var diamondCostMultiplier: Int { policyStore.current.skill.language.diamondCostMultiplier }
            static var intermediateUnlockLevel: Int { policyStore.current.skill.language.intermediateUnlockLevel }
            static var advancedUnlockLevel: Int { policyStore.current.skill.language.advancedUnlockLevel }
        }

        /// 버그 피하기 (DodgeGame)
        enum Dodge {
            static var baseGold: Int { policyStore.current.skill.dodge.baseGold }
            static var beginnerGoldMultiplier: Int { policyStore.current.skill.dodge.beginnerGoldMultiplier }
            static var intermediateGoldMultiplier: Int { policyStore.current.skill.dodge.intermediateGoldMultiplier }
            static var advancedGoldMultiplier: Int { policyStore.current.skill.dodge.advancedGoldMultiplier }
            static var beginnerGoldCostMultiplier: Int { policyStore.current.skill.dodge.beginnerGoldCostMultiplier }
            static var intermediateGoldCostMultiplier: Int { policyStore.current.skill.dodge.intermediateGoldCostMultiplier }
            static var advancedGoldCostMultiplier: Int { policyStore.current.skill.dodge.advancedGoldCostMultiplier }
            static var diamondCostDivider: Int { policyStore.current.skill.dodge.diamondCostDivider }
            static var diamondCostMultiplier: Int { policyStore.current.skill.dodge.diamondCostMultiplier }
            static var intermediateUnlockLevel: Int { policyStore.current.skill.dodge.intermediateUnlockLevel }
            static var advancedUnlockLevel: Int { policyStore.current.skill.dodge.advancedUnlockLevel }
        }

        /// 데이터 쌓기 (StackGame)
        enum Stack {
            static var baseGold: Int { policyStore.current.skill.stack.baseGold }
            static var beginnerGoldMultiplier: Int { policyStore.current.skill.stack.beginnerGoldMultiplier }
            static var intermediateGoldMultiplier: Int { policyStore.current.skill.stack.intermediateGoldMultiplier }
            static var advancedGoldMultiplier: Int { policyStore.current.skill.stack.advancedGoldMultiplier }
            static var beginnerGoldCostMultiplier: Int { policyStore.current.skill.stack.beginnerGoldCostMultiplier }
            static var intermediateGoldCostMultiplier: Int { policyStore.current.skill.stack.intermediateGoldCostMultiplier }
            static var advancedGoldCostMultiplier: Int { policyStore.current.skill.stack.advancedGoldCostMultiplier }
            static var diamondCostDivider: Int { policyStore.current.skill.stack.diamondCostDivider }
            static var diamondCostMultiplier: Int { policyStore.current.skill.stack.diamondCostMultiplier }
            static var intermediateUnlockLevel: Int { policyStore.current.skill.stack.intermediateUnlockLevel }
            static var advancedUnlockLevel: Int { policyStore.current.skill.stack.advancedUnlockLevel }
        }
    }

    // MARK: - 소비 아이템 (효과 강화)
    enum Consumable {
        /// 커피 (1초당 3씩 증가)
        enum Coffee {
            static var duration: Int { policyStore.current.consumable.coffee.duration }
            static var buffMultiplier: Double { policyStore.current.consumable.coffee.buffMultiplier }
            static var priceDiamond: Int { policyStore.current.consumable.coffee.priceDiamond }
        }

        /// 박하스 (1초당 6씩 증가)
        enum EnergyDrink {
            static var duration: Int { policyStore.current.consumable.energyDrink.duration }
            static var buffMultiplier: Double { policyStore.current.consumable.energyDrink.buffMultiplier }
            static var priceDiamond: Int { policyStore.current.consumable.energyDrink.priceDiamond }
        }
    }

    // MARK: - 장비 아이템
    // *밸런스: 업그레이드 비용 20×, 초당 골드 5× (부동산과 동일 비율)
    enum Equipment {
        // 업그레이드 비용 (골드)
        static var brokenUpgradeCost: Int { policyStore.current.equipment.brokenUpgradeCost }
        static var cheapUpgradeCost: Int { policyStore.current.equipment.cheapUpgradeCost }
        static var vintageUpgradeCost: Int { policyStore.current.equipment.vintageUpgradeCost }
        static var decentUpgradeCost: Int { policyStore.current.equipment.decentUpgradeCost }
        static var premiumUpgradeCost: Int { policyStore.current.equipment.premiumUpgradeCost }
        static var diamondUpgradeCost: Int { policyStore.current.equipment.diamondUpgradeCost }
        static var limitedUpgradeCost: Int { policyStore.current.equipment.limitedUpgradeCost }
        static var nationalTreasureUpgradeCost: Int { policyStore.current.equipment.nationalTreasureUpgradeCost }

        // 업그레이드 비용 (다이아몬드) — 강화 시 골드와 함께 소모
        static var brokenUpgradeDiamond: Int { policyStore.current.equipment.brokenUpgradeDiamond }
        static var cheapUpgradeDiamond: Int { policyStore.current.equipment.cheapUpgradeDiamond }
        static var vintageUpgradeDiamond: Int { policyStore.current.equipment.vintageUpgradeDiamond }
        static var decentUpgradeDiamond: Int { policyStore.current.equipment.decentUpgradeDiamond }
        static var premiumUpgradeDiamond: Int { policyStore.current.equipment.premiumUpgradeDiamond }
        static var diamondUpgradeDiamond: Int { policyStore.current.equipment.diamondUpgradeDiamond }
        static var limitedUpgradeDiamond: Int { policyStore.current.equipment.limitedUpgradeDiamond }
        static var nationalTreasureUpgradeDiamond: Int { policyStore.current.equipment.nationalTreasureUpgradeDiamond }

        // 업그레이드 성공 확률 (모든 장비 공통)
        static var brokenSuccessRate: Double { policyStore.current.equipment.brokenSuccessRate }
        static var cheapSuccessRate: Double { policyStore.current.equipment.cheapSuccessRate }
        static var vintageSuccessRate: Double { policyStore.current.equipment.vintageSuccessRate }
        static var decentSuccessRate: Double { policyStore.current.equipment.decentSuccessRate }
        static var premiumSuccessRate: Double { policyStore.current.equipment.premiumSuccessRate }
        static var diamondSuccessRate: Double { policyStore.current.equipment.diamondSuccessRate }
        static var limitedSuccessRate: Double { policyStore.current.equipment.limitedSuccessRate }
        static var nationalTreasureSuccessRate: Double { policyStore.current.equipment.nationalTreasureSuccessRate }

        /// 초당 획득 골드량 (키보드·마우스·모니터·의자 동일)
        enum Keyboard {
            static var brokenGoldPerSecond: Int { policyStore.current.equipment.keyboard.brokenGoldPerSecond }
            static var cheapGoldPerSecond: Int { policyStore.current.equipment.keyboard.cheapGoldPerSecond }
            static var vintageGoldPerSecond: Int { policyStore.current.equipment.keyboard.vintageGoldPerSecond }
            static var decentGoldPerSecond: Int { policyStore.current.equipment.keyboard.decentGoldPerSecond }
            static var premiumGoldPerSecond: Int { policyStore.current.equipment.keyboard.premiumGoldPerSecond }
            static var diamondGoldPerSecond: Int { policyStore.current.equipment.keyboard.diamondGoldPerSecond }
            static var limitedGoldPerSecond: Int { policyStore.current.equipment.keyboard.limitedGoldPerSecond }
            static var nationalTreasureGoldPerSecond: Int { policyStore.current.equipment.keyboard.nationalTreasureGoldPerSecond }
        }

        /// 마우스
        enum Mouse {
            static var brokenGoldPerSecond: Int { policyStore.current.equipment.mouse.brokenGoldPerSecond }
            static var cheapGoldPerSecond: Int { policyStore.current.equipment.mouse.cheapGoldPerSecond }
            static var vintageGoldPerSecond: Int { policyStore.current.equipment.mouse.vintageGoldPerSecond }
            static var decentGoldPerSecond: Int { policyStore.current.equipment.mouse.decentGoldPerSecond }
            static var premiumGoldPerSecond: Int { policyStore.current.equipment.mouse.premiumGoldPerSecond }
            static var diamondGoldPerSecond: Int { policyStore.current.equipment.mouse.diamondGoldPerSecond }
            static var limitedGoldPerSecond: Int { policyStore.current.equipment.mouse.limitedGoldPerSecond }
            static var nationalTreasureGoldPerSecond: Int { policyStore.current.equipment.mouse.nationalTreasureGoldPerSecond }
        }

        /// 모니터
        enum Monitor {
            static var brokenGoldPerSecond: Int { policyStore.current.equipment.monitor.brokenGoldPerSecond }
            static var cheapGoldPerSecond: Int { policyStore.current.equipment.monitor.cheapGoldPerSecond }
            static var vintageGoldPerSecond: Int { policyStore.current.equipment.monitor.vintageGoldPerSecond }
            static var decentGoldPerSecond: Int { policyStore.current.equipment.monitor.decentGoldPerSecond }
            static var premiumGoldPerSecond: Int { policyStore.current.equipment.monitor.premiumGoldPerSecond }
            static var diamondGoldPerSecond: Int { policyStore.current.equipment.monitor.diamondGoldPerSecond }
            static var limitedGoldPerSecond: Int { policyStore.current.equipment.monitor.limitedGoldPerSecond }
            static var nationalTreasureGoldPerSecond: Int { policyStore.current.equipment.monitor.nationalTreasureGoldPerSecond }
        }

        /// 의자
        enum Chair {
            static var brokenGoldPerSecond: Int { policyStore.current.equipment.chair.brokenGoldPerSecond }
            static var cheapGoldPerSecond: Int { policyStore.current.equipment.chair.cheapGoldPerSecond }
            static var vintageGoldPerSecond: Int { policyStore.current.equipment.chair.vintageGoldPerSecond }
            static var decentGoldPerSecond: Int { policyStore.current.equipment.chair.decentGoldPerSecond }
            static var premiumGoldPerSecond: Int { policyStore.current.equipment.chair.premiumGoldPerSecond }
            static var diamondGoldPerSecond: Int { policyStore.current.equipment.chair.diamondGoldPerSecond }
            static var limitedGoldPerSecond: Int { policyStore.current.equipment.chair.limitedGoldPerSecond }
            static var nationalTreasureGoldPerSecond: Int { policyStore.current.equipment.chair.nationalTreasureGoldPerSecond }
        }
    }

    // MARK: - 부동산 아이템 (로망 실현 및 자동 사냥 기지)
    // *밸런스: 가격·초당 골드를 분당 3배수 경제에 맞춤 (가격 20×, 초당 골드 5× → 회수 시간 약 4배)
    enum Housing {
        // 구입 비용
        static var streetPurchaseCost: Int { policyStore.current.housing.streetPurchaseCost }
        static var semiBasementPurchaseCost: Int { policyStore.current.housing.semiBasementPurchaseCost }
        static var rooftopPurchaseCost: Int { policyStore.current.housing.rooftopPurchaseCost }
        static var villaPurchaseCost: Int { policyStore.current.housing.villaPurchaseCost }
        static var apartmentPurchaseCost: Int { policyStore.current.housing.apartmentPurchaseCost }
        static var housePurchaseCost: Int { policyStore.current.housing.housePurchaseCost }
        static var pentHousePurchaseCost: Int { policyStore.current.housing.pentHousePurchaseCost }

        // 초당 골드 획득 (분당 = ×60)
        static var streetGoldPerSecond: Int { policyStore.current.housing.streetGoldPerSecond }
        static var semiBasementGoldPerSecond: Int { policyStore.current.housing.semiBasementGoldPerSecond }
        static var rooftopGoldPerSecond: Int { policyStore.current.housing.rooftopGoldPerSecond }
        static var villaGoldPerSecond: Int { policyStore.current.housing.villaGoldPerSecond }
        static var apartmentGoldPerSecond: Int { policyStore.current.housing.apartmentGoldPerSecond }
        static var houseGoldPerSecond: Int { policyStore.current.housing.houseGoldPerSecond }
        static var pentHouseGoldPerSecond: Int { policyStore.current.housing.pentHouseGoldPerSecond }
    }

    // MARK: - 기타 시스템
    enum System {
        /// 자동 획득 시스템 (AutoGainSystem)
        enum AutoGain {
            static var interval: TimeInterval { policyStore.current.system.autoGain.interval }
        }

        /// 버프 시스템 (BuffSystem)
        enum Buff {
            static var decreaseInterval: TimeInterval { policyStore.current.system.buff.decreaseInterval }
        }
    }

    // MARK: - 시나리오 시스템
    enum Scenario {
        static var maxLevelupQueueSize: Int { policyStore.current.system.scenario?.maxLevelupQueueSize ?? 3 }
    }
}
