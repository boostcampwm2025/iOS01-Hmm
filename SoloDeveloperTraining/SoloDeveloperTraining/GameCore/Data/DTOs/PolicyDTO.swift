//
//  PolicyDTO.swift
//  SoloDeveloperTraining
//

import Foundation

enum PolicyDataField: String {
    case career, fever, game, skill, consumable, equipment, housing, system, ad
}

struct PolicyDTO: Codable {
    var version: String
    var career: CareerPolicyDTO
    var fever: FeverPolicyDTO
    var game: GamePolicyDTO
    var skill: SkillPolicyDTO
    var consumable: ConsumablePolicyDTO
    var equipment: EquipmentPolicyDTO
    var housing: HousingPolicyDTO
    var system: SystemPolicyDTO
    var ad: AdPolicyDTO?
}

extension PolicyDTO {
    // 기본값 (PolicyStore 초기화 전 사용, Policy.* 참조 금지)
    static var defaultValues: PolicyDTO {
        return PolicyDTO(
            version: "1.0.0",
            career: CareerPolicyDTO(
                unemployed: 0,
                laptopOwner: 100_000,
                aspiringDeveloper: 1_000_000,
                juniorDeveloper: 20_000_000,
                normalDeveloper: 2_000_000_000,
                nightOwlDeveloper: 20_000_000_000,
                skilledDeveloper: 200_000_000_000,
                famousDeveloper: 2_000_000_000_000,
                allRounderDeveloper: 100_000_000_000_000,
                worldClassDeveloper: 2_000_000_000_000_000
            ),
            fever: FeverPolicyDTO(
                maxPercent: 400.0,
                decreaseInterval: 0.05,
                stageThreshold: FeverStageThresholdDTO(
                    stage0: 0,
                    stage1: 100,
                    stage2: 200,
                    stage3: 300
                ),
                multiplier: FeverMultiplierDTO(
                    stage0: 1.0,
                    stage1: 1.5,
                    stage2: 2.5,
                    stage3: 5.0
                ),
                tap: FeverTapDTO(
                    decreasePercent: 1.5,
                    gainPerTap: 5.0
                ),
                language: FeverLanguageDTO(
                    decreasePercent: 1.5,
                    gainPerCorrect: 33.0,
                    lossPerIncorrect: -33.0
                ),
                dodge: FeverDodgeDTO(
                    decreasePercent: 1.2,
                    gainPerSmallGold: 33.0,
                    gainPerLargeGold: 50.0,
                    gainPerBugDodge: 15.0,
                    lossPerBugHit: -20.0
                ),
                stack: FeverStackDTO(
                    decreasePercent: 1.0,
                    gainPerSuccess: 80.0,
                    lossPerFailure: -40.0
                )
            ),
            game: GamePolicyDTO(
                language: GameLanguageDTO(
                    incorrectGoldLossMultiplier: 0.5
                ),
                dodge: GameDodgeDTO(
                    smallGoldMultiplier: 1.5,
                    largeGoldMultiplier: 2.0,
                    bugHitLossGoldMultiplier: 0.5,
                    bugDodgeGoldMultiplier: 0.5,
                    updateFPS: 120.0,
                    spawnInterval: 0.3,
                    fallSpeed: 3.0,
                    smallGoldSpawnRate: 7,
                    largeGoldSpawnRate: 3,
                    bugSpawnRate: 90,
                    motion: GameDodgeDTO.MotionDTO(
                        deadZoneThreshold: 0.05,
                        maxSpeed: 2000.0,
                        minSpeed: 300.0
                    )
                ),
                stack: GameStackDTO(
                    failureGoldLossMultiplier: 0.5
                ),
                quiz: GameQuizDTO(
                    questionsPerGame: 3,
                    secondsPerQuestion: 20,
                    diamondsPerCorrect: 5
                )
            ),
            skill: SkillPolicyDTO(
                beginnerMinLevel: 1,
                beginnerMaxLevel: 999,
                intermediateMinLevel: 0,
                intermediateMaxLevel: 999,
                advancedMinLevel: 0,
                advancedMaxLevel: 999,
                tap: SkillTapDTO(
                    baseGold: 1,
                    beginnerGoldMultiplier: 1,
                    intermediateGoldMultiplier: 10,
                    advancedGoldMultiplier: 100,
                    beginnerGoldCostMultiplier: 10,
                    intermediateGoldCostMultiplier: 150,
                    advancedGoldCostMultiplier: 2500,
                    diamondCostDivider: 100,
                    diamondCostMultiplier: 10,
                    intermediateUnlockLevel: 200,
                    advancedUnlockLevel: 300
                ),
                language: SkillLanguageDTO(
                    baseGold: 45,
                    beginnerGoldMultiplier: 45,
                    intermediateGoldMultiplier: 450,
                    advancedGoldMultiplier: 4500,
                    beginnerGoldCostMultiplier: 450,
                    intermediateGoldCostMultiplier: 6750,
                    advancedGoldCostMultiplier: 112_500,
                    diamondCostDivider: 100,
                    diamondCostMultiplier: 10,
                    intermediateUnlockLevel: 200,
                    advancedUnlockLevel: 300
                ),
                dodge: SkillDodgeDTO(
                    baseGold: 87_000,
                    beginnerGoldMultiplier: 87_000,
                    intermediateGoldMultiplier: 870_000,
                    advancedGoldMultiplier: 8_700_000,
                    beginnerGoldCostMultiplier: 870_000,
                    intermediateGoldCostMultiplier: 13_050_000,
                    advancedGoldCostMultiplier: 217_500_000,
                    diamondCostDivider: 100,
                    diamondCostMultiplier: 10,
                    intermediateUnlockLevel: 200,
                    advancedUnlockLevel: 300
                ),
                stack: SkillStackDTO(
                    baseGold: 2_250_000,
                    beginnerGoldMultiplier: 2_250_000,
                    intermediateGoldMultiplier: 22_500_000,
                    advancedGoldMultiplier: 225_000_000,
                    beginnerGoldCostMultiplier: 22_500_000,
                    intermediateGoldCostMultiplier: 3_375_000_000,
                    advancedGoldCostMultiplier: 56_250_000_000,
                    diamondCostDivider: 100,
                    diamondCostMultiplier: 10,
                    intermediateUnlockLevel: 200,
                    advancedUnlockLevel: 300
                )
            ),
            consumable: ConsumablePolicyDTO(
                coffee: CoffeeDTO(
                    duration: 15,
                    buffMultiplier: 2.0,
                    priceDiamond: 5
                ),
                energyDrink: EnergyDrinkDTO(
                    duration: 20,
                    buffMultiplier: 3.0,
                    priceDiamond: 10
                )
            ),
            equipment: EquipmentPolicyDTO(
                brokenUpgradeCost: 100_000,
                cheapUpgradeCost: 2_000_000,
                vintageUpgradeCost: 40_000_000,
                decentUpgradeCost: 1_000_000_000,
                premiumUpgradeCost: 20_000_000_000,
                diamondUpgradeCost: 200_000_000_000,
                limitedUpgradeCost: 1_000_000_000_000,
                nationalTreasureUpgradeCost: 4_000_000_000_000,
                brokenUpgradeDiamond: 5,
                cheapUpgradeDiamond: 10,
                vintageUpgradeDiamond: 20,
                decentUpgradeDiamond: 35,
                premiumUpgradeDiamond: 50,
                diamondUpgradeDiamond: 80,
                limitedUpgradeDiamond: 120,
                nationalTreasureUpgradeDiamond: 0,
                brokenSuccessRate: 1.0,
                cheapSuccessRate: 0.8,
                vintageSuccessRate: 0.6,
                decentSuccessRate: 0.4,
                premiumSuccessRate: 0.3,
                diamondSuccessRate: 0.2,
                limitedSuccessRate: 0.1,
                nationalTreasureSuccessRate: 0.05,
                keyboard: EquipmentItemDTO(
                    brokenGoldPerSecond: 0,
                    cheapGoldPerSecond: 1_250,
                    vintageGoldPerSecond: 30_000,
                    decentGoldPerSecond: 750_000,
                    premiumGoldPerSecond: 17_500_000,
                    diamondGoldPerSecond: 200_000_000,
                    limitedGoldPerSecond: 1_250_000_000,
                    nationalTreasureGoldPerSecond: 6_000_000_000
                ),
                mouse: EquipmentItemDTO(
                    brokenGoldPerSecond: 0,
                    cheapGoldPerSecond: 1_250,
                    vintageGoldPerSecond: 30_000,
                    decentGoldPerSecond: 750_000,
                    premiumGoldPerSecond: 17_500_000,
                    diamondGoldPerSecond: 200_000_000,
                    limitedGoldPerSecond: 1_250_000_000,
                    nationalTreasureGoldPerSecond: 6_000_000_000
                ),
                monitor: EquipmentItemDTO(
                    brokenGoldPerSecond: 0,
                    cheapGoldPerSecond: 1_250,
                    vintageGoldPerSecond: 30_000,
                    decentGoldPerSecond: 750_000,
                    premiumGoldPerSecond: 17_500_000,
                    diamondGoldPerSecond: 200_000_000,
                    limitedGoldPerSecond: 1_250_000_000,
                    nationalTreasureGoldPerSecond: 6_000_000_000
                ),
                chair: EquipmentItemDTO(
                    brokenGoldPerSecond: 0,
                    cheapGoldPerSecond: 1_250,
                    vintageGoldPerSecond: 30_000,
                    decentGoldPerSecond: 750_000,
                    premiumGoldPerSecond: 17_500_000,
                    diamondGoldPerSecond: 200_000_000,
                    limitedGoldPerSecond: 1_250_000_000,
                    nationalTreasureGoldPerSecond: 6_000_000_000
                )
            ),
            housing: HousingPolicyDTO(
                streetPurchaseCost: 0,
                semiBasementPurchaseCost: 10_000_000,
                rooftopPurchaseCost: 200_000_000,
                villaPurchaseCost: 10_000_000_000,
                apartmentPurchaseCost: 100_000_000_000,
                housePurchaseCost: 1_000_000_000_000,
                pentHousePurchaseCost: 4_000_000_000_000,
                streetGoldPerSecond: 0,
                semiBasementGoldPerSecond: 2_500,
                rooftopGoldPerSecond: 50_000,
                villaGoldPerSecond: 2_500_000,
                apartmentGoldPerSecond: 25_000_000,
                houseGoldPerSecond: 250_000_000,
                pentHouseGoldPerSecond: 1_000_000_000
            ),
            system: SystemPolicyDTO(
                autoGain: AutoGainDTO(interval: 1.0),
                buff: BuffDTO(decreaseInterval: 1.0),
                scenario: ScenarioPolicyDTO(maxLevelupQueueSize: 3)
            ),
            ad: nil
        )
    }
}
