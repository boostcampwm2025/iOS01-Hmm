import Foundation

// MARK: - 단일 필드 유효성 규칙

enum ValidationRule {
    case positiveInt           // 정수, > 0
    case nonNegativeInt        // 정수, ≥ 0
    case positiveDouble        // 실수, > 0
    case nonNegativeDouble     // 실수, ≥ 0
    case percent               // 실수, 0 < x ≤ 100
    case zeroToOne             // 실수, 0 < x ≤ 1 (성공률 등)
    case spawnRate             // 정수, ≥ 0 (생성률)

    /// nil = 유효, String = 오류 메시지
    func validate(_ value: Double) -> String? {
        switch self {
        case .positiveInt:
            if value <= 0  { return "0보다 큰 정수여야 합니다." }
            if !value.isInteger { return "정수여야 합니다." }
        case .nonNegativeInt:
            if value < 0   { return "0 이상의 정수여야 합니다." }
            if !value.isInteger { return "정수여야 합니다." }
        case .positiveDouble:
            if value <= 0  { return "0보다 큰 값이어야 합니다." }
        case .nonNegativeDouble:
            if value < 0   { return "0 이상의 값이어야 합니다." }
        case .percent:
            if value <= 0  { return "0보다 큰 값이어야 합니다." }
            if value > 100 { return "100 이하여야 합니다." }
        case .zeroToOne:
            if value <= 0  { return "0보다 큰 값이어야 합니다." }
            if value > 1   { return "1 이하여야 합니다. (예: 0.8 = 80%)" }
        case .spawnRate:
            if value < 0   { return "0 이상의 정수여야 합니다." }
            if !value.isInteger { return "정수여야 합니다." }
        }
        return nil
    }

    var hint: String {
        switch self {
        case .positiveInt:       return "양의 정수"
        case .nonNegativeInt:    return "0 이상 정수"
        case .positiveDouble:    return "양수"
        case .nonNegativeDouble: return "0 이상"
        case .percent:           return "0 초과 ~ 100 이하"
        case .zeroToOne:         return "0 초과 ~ 1 이하"
        case .spawnRate:         return "0 이상 정수"
        }
    }
}

private extension Double {
    var isInteger: Bool { self == self.rounded() }
}

// MARK: - 필드별 규칙 매핑

extension PolicyFieldMeta {

    /// 필드 ID → 단일 필드 유효성 규칙
    static let validationRules: [String: ValidationRule] = {
        var rules: [String: ValidationRule] = [:]

        // 커리어 (골드 임계값 - 양의 정수, 단 unemployed는 0 가능)
        rules["career.unemployed"]          = .nonNegativeInt
        rules["career.laptopOwner"]         = .positiveInt
        rules["career.aspiringDeveloper"]   = .positiveInt
        rules["career.juniorDeveloper"]     = .positiveInt
        rules["career.normalDeveloper"]     = .positiveInt
        rules["career.nightOwlDeveloper"]   = .positiveInt
        rules["career.skilledDeveloper"]    = .positiveInt
        rules["career.famousDeveloper"]     = .positiveInt
        rules["career.allRounderDeveloper"] = .positiveInt
        rules["career.worldClassDeveloper"] = .positiveInt

        // 피버 기본
        rules["fever.maxPercent"]       = .percent
        rules["fever.decreaseInterval"] = .positiveDouble

        // 피버 단계 임계값 (0~100 퍼센트)
        rules["fever.stageThreshold.stage0"] = .nonNegativeDouble
        rules["fever.stageThreshold.stage1"] = .nonNegativeDouble
        rules["fever.stageThreshold.stage2"] = .nonNegativeDouble
        rules["fever.stageThreshold.stage3"] = .nonNegativeDouble

        // 피버 배율
        rules["fever.multiplier.stage0"] = .positiveDouble
        rules["fever.multiplier.stage1"] = .positiveDouble
        rules["fever.multiplier.stage2"] = .positiveDouble
        rules["fever.multiplier.stage3"] = .positiveDouble

        // 피버 탭
        rules["fever.tap.decreasePercent"] = .percent
        rules["fever.tap.gainPerTap"]      = .positiveDouble

        // 피버 언어
        rules["fever.language.decreasePercent"]  = .percent
        rules["fever.language.gainPerCorrect"]   = .positiveDouble
        rules["fever.language.lossPerIncorrect"] = .positiveDouble

        // 피버 닷지
        rules["fever.dodge.decreasePercent"]  = .percent
        rules["fever.dodge.gainPerSmallGold"] = .positiveDouble
        rules["fever.dodge.gainPerLargeGold"] = .positiveDouble
        rules["fever.dodge.gainPerBugDodge"]  = .positiveDouble
        rules["fever.dodge.lossPerBugHit"]    = .positiveDouble

        // 피버 스택
        rules["fever.stack.decreasePercent"] = .percent
        rules["fever.stack.gainPerSuccess"]  = .positiveDouble
        rules["fever.stack.lossPerFailure"]  = .positiveDouble

        // 게임 언어
        rules["game.language.incorrectGoldLossMultiplier"] = .positiveDouble

        // 게임 닷지
        rules["game.dodge.smallGoldMultiplier"]      = .positiveDouble
        rules["game.dodge.largeGoldMultiplier"]      = .positiveDouble
        rules["game.dodge.bugHitLossGoldMultiplier"] = .positiveDouble
        rules["game.dodge.bugDodgeGoldMultiplier"]   = .positiveDouble
        rules["game.dodge.updateFPS"]                = .positiveDouble
        rules["game.dodge.spawnInterval"]            = .positiveDouble
        rules["game.dodge.fallSpeed"]                = .positiveDouble
        rules["game.dodge.smallGoldSpawnRate"]       = .spawnRate
        rules["game.dodge.largeGoldSpawnRate"]       = .spawnRate
        rules["game.dodge.bugSpawnRate"]             = .spawnRate

        // 게임 닷지 모션
        rules["game.dodge.motion.deadZoneThreshold"] = .positiveDouble
        rules["game.dodge.motion.maxSpeed"]          = .positiveDouble
        rules["game.dodge.motion.minSpeed"]          = .positiveDouble

        // 게임 스택
        rules["game.stack.failureGoldLossMultiplier"] = .positiveDouble

        // 게임 퀴즈
        rules["game.quiz.questionsPerGame"]   = .positiveInt
        rules["game.quiz.secondsPerQuestion"] = .positiveInt
        rules["game.quiz.diamondsPerCorrect"] = .positiveInt

        // 스킬 레벨 범위
        rules["skill.beginnerMinLevel"]     = .positiveInt
        rules["skill.beginnerMaxLevel"]     = .positiveInt
        rules["skill.intermediateMinLevel"] = .positiveInt
        rules["skill.intermediateMaxLevel"] = .positiveInt
        rules["skill.advancedMinLevel"]     = .positiveInt
        rules["skill.advancedMaxLevel"]     = .positiveInt

        // 스킬 필드 공통 생성 함수
        func addSkillRules(prefix: String) {
            rules["\(prefix).baseGold"]                       = .positiveInt
            rules["\(prefix).beginnerGoldMultiplier"]         = .positiveInt
            rules["\(prefix).intermediateGoldMultiplier"]     = .positiveInt
            rules["\(prefix).advancedGoldMultiplier"]         = .positiveInt
            rules["\(prefix).beginnerGoldCostMultiplier"]     = .positiveInt
            rules["\(prefix).intermediateGoldCostMultiplier"] = .positiveInt
            rules["\(prefix).advancedGoldCostMultiplier"]     = .positiveInt
            rules["\(prefix).diamondCostDivider"]             = .positiveInt
            rules["\(prefix).diamondCostMultiplier"]          = .positiveInt
            rules["\(prefix).intermediateUnlockLevel"]        = .positiveInt
            rules["\(prefix).advancedUnlockLevel"]            = .positiveInt
        }
        addSkillRules(prefix: "skill.tap")
        addSkillRules(prefix: "skill.language")
        addSkillRules(prefix: "skill.dodge")
        addSkillRules(prefix: "skill.stack")

        // 장비
        let rarities = ["broken","cheap","vintage","decent","premium","diamond","limited","nationalTreasure"]
        for r in rarities {
            rules["equipment.\(r)UpgradeCost"]    = .nonNegativeInt
            rules["equipment.\(r)UpgradeDiamond"] = .nonNegativeInt
            rules["equipment.\(r)SuccessRate"]    = .zeroToOne
        }
        let equipItems = ["keyboard","mouse","monitor","chair"]
        for item in equipItems {
            for r in rarities {
                rules["equipment.\(item).\(r)GoldPerSecond"] = .nonNegativeInt
            }
        }

        // 주거
        let housings = ["street","semiBasement","rooftop","villa","apartment","house","pentHouse"]
        for h in housings {
            rules["housing.\(h)PurchaseCost"]  = .nonNegativeInt
            rules["housing.\(h)GoldPerSecond"] = .nonNegativeInt
        }

        // 소비 아이템
        rules["consumable.coffee.duration"]            = .positiveInt
        rules["consumable.coffee.buffMultiplier"]      = .positiveDouble
        rules["consumable.coffee.priceDiamond"]        = .positiveInt
        rules["consumable.energyDrink.duration"]       = .positiveInt
        rules["consumable.energyDrink.buffMultiplier"] = .positiveDouble
        rules["consumable.energyDrink.priceDiamond"]   = .positiveInt

        // 시스템
        rules["system.autoGain.interval"]     = .positiveDouble
        rules["system.buff.decreaseInterval"] = .positiveDouble

        return rules
    }()
}

// MARK: - 크로스 필드 유효성 검사

struct CrossFieldValidation {

    /// 여러 필드 간 순서 관계 등을 검사하여 [fieldID: 오류메시지] 반환
    static func validate(fields: [PolicyField]) -> [String: String] {
        let map = Dictionary(uniqueKeysWithValues: fields.map { ($0.id, $0.resolvedValue) })
        var errors: [String: String] = [:]

        // 커리어: 오름차순 강제
        let careerOrder: [String] = [
            "career.unemployed", "career.laptopOwner", "career.aspiringDeveloper",
            "career.juniorDeveloper", "career.normalDeveloper", "career.nightOwlDeveloper",
            "career.skilledDeveloper", "career.famousDeveloper",
            "career.allRounderDeveloper", "career.worldClassDeveloper"
        ]
        for i in 1..<careerOrder.count {
            let prev = careerOrder[i - 1]
            let curr = careerOrder[i]
            if let a = map[prev], let b = map[curr], b <= a {
                errors[curr] = "이전 커리어 단계 값(\(Int(a)))보다 커야 합니다."
            }
        }

        // 피버 단계 임계값: stage0 < stage1 < stage2 < stage3
        let thresholds = ["fever.stageThreshold.stage0","fever.stageThreshold.stage1",
                          "fever.stageThreshold.stage2","fever.stageThreshold.stage3"]
        for i in 1..<thresholds.count {
            if let a = map[thresholds[i-1]], let b = map[thresholds[i]], b <= a {
                errors[thresholds[i]] = "이전 단계 임계값(\(a))보다 커야 합니다."
            }
        }

        // 스킬 레벨 범위: beginnerMax < intermediateMin < intermediateMax < advancedMin < advancedMax
        let skillOrder: [(String, String)] = [
            ("skill.beginnerMinLevel", "skill.beginnerMaxLevel"),
            ("skill.beginnerMaxLevel", "skill.intermediateMinLevel"),
            ("skill.intermediateMinLevel", "skill.intermediateMaxLevel"),
            ("skill.intermediateMaxLevel", "skill.advancedMinLevel"),
            ("skill.advancedMinLevel", "skill.advancedMaxLevel"),
        ]
        let skillLabels: [String: String] = [
            "skill.beginnerMinLevel": "초급 최소",
            "skill.beginnerMaxLevel": "초급 최대",
            "skill.intermediateMinLevel": "중급 최소",
            "skill.intermediateMaxLevel": "중급 최대",
            "skill.advancedMinLevel": "고급 최소",
            "skill.advancedMaxLevel": "고급 최대",
        ]
        for (prevID, currID) in skillOrder {
            if let a = map[prevID], let b = map[currID], b <= a {
                let prevLabel = skillLabels[prevID] ?? prevID
                errors[currID] = "\(prevLabel) 레벨(\(Int(a)))보다 커야 합니다."
            }
        }

        // 게임 닷지 모션: minSpeed < maxSpeed
        if let minS = map["game.dodge.motion.minSpeed"],
           let maxS = map["game.dodge.motion.maxSpeed"],
           maxS <= minS {
            errors["game.dodge.motion.maxSpeed"] = "최소 속도(\(minS))보다 커야 합니다."
        }

        return errors
    }
}
