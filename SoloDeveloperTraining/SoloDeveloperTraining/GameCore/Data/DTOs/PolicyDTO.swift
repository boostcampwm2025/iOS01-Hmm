//
//  PolicyDTO.swift
//  SoloDeveloperTraining
//

import Foundation

enum PolicyDataField: String {
    case career, fever, game, skill, consumable, equipment, housing, system
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

    // 기본값
    static var defaultValues: PolicyDTO {
        return PolicyDTO(
            version: "1.0.0",
            career: CareerPolicyDTO(
                unemployed: Policy.Career.unemployed,
                laptopOwner: Policy.Career.laptopOwner,
                aspiringDeveloper: Policy.Career.aspiringDeveloper,
                juniorDeveloper: Policy.Career.juniorDeveloper,
                normalDeveloper: Policy.Career.normalDeveloper,
                nightOwlDeveloper: Policy.Career.nightOwlDeveloper,
                skilledDeveloper: Policy.Career.skilledDeveloper,
                famousDeveloper: Policy.Career.famousDeveloper,
                allRounderDeveloper: Policy.Career.allRounderDeveloper,
                worldClassDeveloper: Policy.Career.worldClassDeveloper
            ),
            fever: FeverPolicyDTO(
                maxPercent: Policy.Fever.maxPercent,
                decreaseInterval: Policy.Fever.decreaseInterval,
                stageThreshold: FeverStageThresholdDTO(
                    stage0: Policy.Fever.StageThreshold.stage0,
                    stage1: Policy.Fever.StageThreshold.stage1,
                    stage2: Policy.Fever.StageThreshold.stage2,
                    stage3: Policy.Fever.StageThreshold.stage3
                ),
                multiplier: FeverMultiplierDTO(
                    stage0: Policy.Fever.Multiplier.stage0,
                    stage1: Policy.Fever.Multiplier.stage1,
                    stage2: Policy.Fever.Multiplier.stage2,
                    stage3: Policy.Fever.Multiplier.stage3
                ),
                tap: FeverTapDTO(
                    decreasePercent: Policy.Fever.Tap.decreasePercent,
                    gainPerTap: Policy.Fever.Tap.gainPerTap
                ),
                language: FeverLanguageDTO(
                    decreasePercent: Policy.Fever.Language.decreasePercent,
                    gainPerCorrect: Policy.Fever.Language.gainPerCorrect,
                    lossPerIncorrect: Policy.Fever.Language.lossPerIncorrect
                ),
                dodge: FeverDodgeDTO(
                    decreasePercent: Policy.Fever.Dodge.decreasePercent,
                    gainPerSmallGold: Policy.Fever.Dodge.gainPerSmallGold,
                    gainPerLargeGold: Policy.Fever.Dodge.gainPerLargeGold,
                    gainPerBugDodge: Policy.Fever.Dodge.gainPerBugDodge,
                    lossPerBugHit: Policy.Fever.Dodge.lossPerBugHit
                ),
                stack: FeverStackDTO(
                    decreasePercent: Policy.Fever.Stack.decreasePercent,
                    gainPerSuccess: Policy.Fever.Stack.gainPerSuccess,
                    lossPerFailure: Policy.Fever.Stack.lossPerFailure
                )
            ),
            game: GamePolicyDTO(
                language: GameLanguageDTO(
                    incorrectGoldLossMultiplier: Policy.Game.Language.incorrectGoldLossMultiplier
                ),
                dodge: GameDodgeDTO(
                    smallGoldMultiplier: Policy.Game.Dodge.smallGoldMultiplier,
                    largeGoldMultiplier: Policy.Game.Dodge.largeGoldMultiplier,
                    bugHitLossGoldMultiplier: Policy.Game.Dodge.bugHitLossGoldMultiplier,
                    bugDodgeGoldMultiplier: Policy.Game.Dodge.bugDodgeGoldMultiplier,
                    updateFPS: Policy.Game.Dodge.updateFPS,
                    spawnInterval: Policy.Game.Dodge.spawnInterval,
                    fallSpeed: Policy.Game.Dodge.fallSpeed,
                    smallGoldSpawnRate: Policy.Game.Dodge.smallGoldSpawnRate,
                    largeGoldSpawnRate: Policy.Game.Dodge.largeGoldSpawnRate,
                    bugSpawnRate: Policy.Game.Dodge.bugSpawnRate,
                    motion: GameDodgeDTO.MotionDTO(
                        deadZoneThreshold: Policy.Game.Dodge.Motion.deadZoneThreshold,
                        maxSpeed: Policy.Game.Dodge.Motion.maxSpeed,
                        minSpeed: Policy.Game.Dodge.Motion.minSpeed
                    )
                ),
                stack: GameStackDTO(
                    failureGoldLossMultiplier: Policy.Game.Stack.failureGoldLossMultiplier
                ),
                quiz: GameQuizDTO(
                    questionsPerGame: Policy.Game.Quiz.questionsPerGame,
                    secondsPerQuestion: Policy.Game.Quiz.secondsPerQuestion,
                    diamondsPerCorrect: Policy.Game.Quiz.diamondsPerCorrect
                )
            ),
            skill: SkillPolicyDTO(
                beginnerMinLevel: Policy.Skill.beginnerMinLevel,
                beginnerMaxLevel: Policy.Skill.beginnerMaxLevel,
                intermediateMinLevel: Policy.Skill.intermediateMinLevel,
                intermediateMaxLevel: Policy.Skill.intermediateMaxLevel,
                advancedMinLevel: Policy.Skill.advancedMinLevel,
                advancedMaxLevel: Policy.Skill.advancedMaxLevel,
                tap: SkillTapDTO(
                    baseGold: Policy.Skill.Tap.baseGold,
                    beginnerGoldMultiplier: Policy.Skill.Tap.beginnerGoldMultiplier,
                    intermediateGoldMultiplier: Policy.Skill.Tap.intermediateGoldMultiplier,
                    advancedGoldMultiplier: Policy.Skill.Tap.advancedGoldMultiplier,
                    beginnerGoldCostMultiplier: Policy.Skill.Tap.beginnerGoldCostMultiplier,
                    intermediateGoldCostMultiplier: Policy.Skill.Tap.intermediateGoldCostMultiplier,
                    advancedGoldCostMultiplier: Policy.Skill.Tap.advancedGoldCostMultiplier,
                    diamondCostDivider: Policy.Skill.Tap.diamondCostDivider,
                    diamondCostMultiplier: Policy.Skill.Tap.diamondCostMultiplier,
                    intermediateUnlockLevel: Policy.Skill.Tap.intermediateUnlockLevel,
                    advancedUnlockLevel: Policy.Skill.Tap.advancedUnlockLevel
                ),
                language: SkillLanguageDTO(
                    baseGold: Policy.Skill.Language.baseGold,
                    beginnerGoldMultiplier: Policy.Skill.Language.beginnerGoldMultiplier,
                    intermediateGoldMultiplier: Policy.Skill.Language.intermediateGoldMultiplier,
                    advancedGoldMultiplier: Policy.Skill.Language.advancedGoldMultiplier,
                    beginnerGoldCostMultiplier: Policy.Skill.Language.beginnerGoldCostMultiplier,
                    intermediateGoldCostMultiplier: Policy.Skill.Language.intermediateGoldCostMultiplier,
                    advancedGoldCostMultiplier: Policy.Skill.Language.advancedGoldCostMultiplier,
                    diamondCostDivider: Policy.Skill.Language.diamondCostDivider,
                    diamondCostMultiplier: Policy.Skill.Language.diamondCostMultiplier,
                    intermediateUnlockLevel: Policy.Skill.Language.intermediateUnlockLevel,
                    advancedUnlockLevel: Policy.Skill.Language.advancedUnlockLevel
                ),
                dodge: SkillDodgeDTO(
                    baseGold: Policy.Skill.Dodge.baseGold,
                    beginnerGoldMultiplier: Policy.Skill.Dodge.beginnerGoldMultiplier,
                    intermediateGoldMultiplier: Policy.Skill.Dodge.intermediateGoldMultiplier,
                    advancedGoldMultiplier: Policy.Skill.Dodge.advancedGoldMultiplier,
                    beginnerGoldCostMultiplier: Policy.Skill.Dodge.beginnerGoldCostMultiplier,
                    intermediateGoldCostMultiplier: Policy.Skill.Dodge.intermediateGoldCostMultiplier,
                    advancedGoldCostMultiplier: Policy.Skill.Dodge.advancedGoldCostMultiplier,
                    diamondCostDivider: Policy.Skill.Dodge.diamondCostDivider,
                    diamondCostMultiplier: Policy.Skill.Dodge.diamondCostMultiplier,
                    intermediateUnlockLevel: Policy.Skill.Dodge.intermediateUnlockLevel,
                    advancedUnlockLevel: Policy.Skill.Dodge.advancedUnlockLevel
                ),
                stack: SkillStackDTO(
                    baseGold: Policy.Skill.Stack.baseGold,
                    beginnerGoldMultiplier: Policy.Skill.Stack.beginnerGoldMultiplier,
                    intermediateGoldMultiplier: Policy.Skill.Stack.intermediateGoldMultiplier,
                    advancedGoldMultiplier: Policy.Skill.Stack.advancedGoldMultiplier,
                    beginnerGoldCostMultiplier: Policy.Skill.Stack.beginnerGoldCostMultiplier,
                    intermediateGoldCostMultiplier: Policy.Skill.Stack.intermediateGoldCostMultiplier,
                    advancedGoldCostMultiplier: Policy.Skill.Stack.advancedGoldCostMultiplier,
                    diamondCostDivider: Policy.Skill.Stack.diamondCostDivider,
                    diamondCostMultiplier: Policy.Skill.Stack.diamondCostMultiplier,
                    intermediateUnlockLevel: Policy.Skill.Stack.intermediateUnlockLevel,
                    advancedUnlockLevel: Policy.Skill.Stack.advancedUnlockLevel
                )
            ),
            consumable: ConsumablePolicyDTO(
                coffee: CoffeeDTO(
                    duration: Policy.Consumable.Coffee.duration,
                    buffMultiplier: Policy.Consumable.Coffee.buffMultiplier,
                    priceDiamond: Policy.Consumable.Coffee.priceDiamond
                ),
                energyDrink: EnergyDrinkDTO(
                    duration: Policy.Consumable.EnergyDrink.duration,
                    buffMultiplier: Policy.Consumable.EnergyDrink.buffMultiplier,
                    priceDiamond: Policy.Consumable.EnergyDrink.priceDiamond
                )
            ),
            equipment: EquipmentPolicyDTO(
                brokenUpgradeCost: Policy.Equipment.brokenUpgradeCost,
                cheapUpgradeCost: Policy.Equipment.cheapUpgradeCost,
                vintageUpgradeCost: Policy.Equipment.vintageUpgradeCost,
                decentUpgradeCost: Policy.Equipment.decentUpgradeCost,
                premiumUpgradeCost: Policy.Equipment.premiumUpgradeCost,
                diamondUpgradeCost: Policy.Equipment.diamondUpgradeCost,
                limitedUpgradeCost: Policy.Equipment.limitedUpgradeCost,
                nationalTreasureUpgradeCost: Policy.Equipment.nationalTreasureUpgradeCost,
                brokenUpgradeDiamond: Policy.Equipment.brokenUpgradeDiamond,
                cheapUpgradeDiamond: Policy.Equipment.cheapUpgradeDiamond,
                vintageUpgradeDiamond: Policy.Equipment.vintageUpgradeDiamond,
                decentUpgradeDiamond: Policy.Equipment.decentUpgradeDiamond,
                premiumUpgradeDiamond: Policy.Equipment.premiumUpgradeDiamond,
                diamondUpgradeDiamond: Policy.Equipment.diamondUpgradeDiamond,
                limitedUpgradeDiamond: Policy.Equipment.limitedUpgradeDiamond,
                nationalTreasureUpgradeDiamond: Policy.Equipment.nationalTreasureUpgradeDiamond,
                brokenSuccessRate: Policy.Equipment.brokenSuccessRate,
                cheapSuccessRate: Policy.Equipment.cheapSuccessRate,
                vintageSuccessRate: Policy.Equipment.vintageSuccessRate,
                decentSuccessRate: Policy.Equipment.decentSuccessRate,
                premiumSuccessRate: Policy.Equipment.premiumSuccessRate,
                diamondSuccessRate: Policy.Equipment.diamondSuccessRate,
                limitedSuccessRate: Policy.Equipment.limitedSuccessRate,
                nationalTreasureSuccessRate: Policy.Equipment.nationalTreasureSuccessRate,
                keyboard: EquipmentItemDTO(
                    brokenGoldPerSecond: Policy.Equipment.Keyboard.brokenGoldPerSecond,
                    cheapGoldPerSecond: Policy.Equipment.Keyboard.cheapGoldPerSecond,
                    vintageGoldPerSecond: Policy.Equipment.Keyboard.vintageGoldPerSecond,
                    decentGoldPerSecond: Policy.Equipment.Keyboard.decentGoldPerSecond,
                    premiumGoldPerSecond: Policy.Equipment.Keyboard.premiumGoldPerSecond,
                    diamondGoldPerSecond: Policy.Equipment.Keyboard.diamondGoldPerSecond,
                    limitedGoldPerSecond: Policy.Equipment.Keyboard.limitedGoldPerSecond,
                    nationalTreasureGoldPerSecond: Policy.Equipment.Keyboard.nationalTreasureGoldPerSecond
                ),
                mouse: EquipmentItemDTO(
                    brokenGoldPerSecond: Policy.Equipment.Mouse.brokenGoldPerSecond,
                    cheapGoldPerSecond: Policy.Equipment.Mouse.cheapGoldPerSecond,
                    vintageGoldPerSecond: Policy.Equipment.Mouse.vintageGoldPerSecond,
                    decentGoldPerSecond: Policy.Equipment.Mouse.decentGoldPerSecond,
                    premiumGoldPerSecond: Policy.Equipment.Mouse.premiumGoldPerSecond,
                    diamondGoldPerSecond: Policy.Equipment.Mouse.diamondGoldPerSecond,
                    limitedGoldPerSecond: Policy.Equipment.Mouse.limitedGoldPerSecond,
                    nationalTreasureGoldPerSecond: Policy.Equipment.Mouse.nationalTreasureGoldPerSecond
                ),
                monitor: EquipmentItemDTO(
                    brokenGoldPerSecond: Policy.Equipment.Monitor.brokenGoldPerSecond,
                    cheapGoldPerSecond: Policy.Equipment.Monitor.cheapGoldPerSecond,
                    vintageGoldPerSecond: Policy.Equipment.Monitor.vintageGoldPerSecond,
                    decentGoldPerSecond: Policy.Equipment.Monitor.decentGoldPerSecond,
                    premiumGoldPerSecond: Policy.Equipment.Monitor.premiumGoldPerSecond,
                    diamondGoldPerSecond: Policy.Equipment.Monitor.diamondGoldPerSecond,
                    limitedGoldPerSecond: Policy.Equipment.Monitor.limitedGoldPerSecond,
                    nationalTreasureGoldPerSecond: Policy.Equipment.Monitor.nationalTreasureGoldPerSecond
                ),
                chair: EquipmentItemDTO(
                    brokenGoldPerSecond: Policy.Equipment.Chair.brokenGoldPerSecond,
                    cheapGoldPerSecond: Policy.Equipment.Chair.cheapGoldPerSecond,
                    vintageGoldPerSecond: Policy.Equipment.Chair.vintageGoldPerSecond,
                    decentGoldPerSecond: Policy.Equipment.Chair.decentGoldPerSecond,
                    premiumGoldPerSecond: Policy.Equipment.Chair.premiumGoldPerSecond,
                    diamondGoldPerSecond: Policy.Equipment.Chair.diamondGoldPerSecond,
                    limitedGoldPerSecond: Policy.Equipment.Chair.limitedGoldPerSecond,
                    nationalTreasureGoldPerSecond: Policy.Equipment.Chair.nationalTreasureGoldPerSecond
                )
            ),
            housing: HousingPolicyDTO(
                streetPurchaseCost: Policy.Housing.streetPurchaseCost,
                semiBasementPurchaseCost: Policy.Housing.semiBasementPurchaseCost,
                rooftopPurchaseCost: Policy.Housing.rooftopPurchaseCost,
                villaPurchaseCost: Policy.Housing.villaPurchaseCost,
                apartmentPurchaseCost: Policy.Housing.apartmentPurchaseCost,
                housePurchaseCost: Policy.Housing.housePurchaseCost,
                pentHousePurchaseCost: Policy.Housing.pentHousePurchaseCost,
                streetGoldPerSecond: Policy.Housing.streetGoldPerSecond,
                semiBasementGoldPerSecond: Policy.Housing.semiBasementGoldPerSecond,
                rooftopGoldPerSecond: Policy.Housing.rooftopGoldPerSecond,
                villaGoldPerSecond: Policy.Housing.villaGoldPerSecond,
                apartmentGoldPerSecond: Policy.Housing.apartmentGoldPerSecond,
                houseGoldPerSecond: Policy.Housing.houseGoldPerSecond,
                pentHouseGoldPerSecond: Policy.Housing.pentHouseGoldPerSecond
            ),
            system: SystemPolicyDTO(
                autoGain: AutoGainDTO(interval: Policy.System.AutoGain.interval),
                buff: BuffDTO(decreaseInterval: Policy.System.Buff.decreaseInterval)
            )
        )
    }
}
