import Foundation

// MARK: - Double 포맷 유틸리티

extension Double {
    /// 게임 밸런스 값을 표시용 문자열로 변환합니다.
    /// isDouble: true이면 소수점 3자리까지, false이면 정수로 표시합니다.
    func policyFormatted(isDouble: Bool) -> String {
        if isDouble {
            let rounded = (self * 1000).rounded() / 1000
            if rounded.truncatingRemainder(dividingBy: 1) == 0 { return String(Int(rounded)) }
            return String(format: "%.3f", rounded)
                .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
        } else {
            return String(Int(self.rounded()))
        }
    }
}

// MARK: - PolicyField

struct PolicyField: Identifiable {
    let id: String          // Firestore 경로 (예: "fever.tap.gainPerTap")
    let group: String       // 사이드바 그룹 (예: "피버")
    let section: String     // 섹션 헤더 (예: "탭")
    let name: String        // 한글 항목명 (예: "탭당 획득량")
    let isDouble: Bool
    var rawInput: String
    var resolvedValue: Double

    var hasFormula: Bool { rawInput.trimmingCharacters(in: .whitespaces).hasPrefix("=") }

    var displayValue: String { resolvedValue.policyFormatted(isDouble: isDouble) }

    /// 입력값 자체가 숫자/수식이 아닌 경우의 포맷 오류 (최우선 검사)
    var inputFormatError: String? {
        let trimmed = rawInput.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "값을 입력하세요." }
        if trimmed.hasPrefix("=") { return nil } // 수식은 별도 평가
        if Double(trimmed) == nil { return "숫자를 입력하세요." }
        return nil
    }

    /// 단일 필드 규칙 위반 메시지 (nil = 유효)
    var singleFieldError: String? {
        if inputFormatError != nil { return nil } // 포맷 오류가 있으면 중복 표시 안 함
        return PolicyFieldMeta.validationRules[id]?.validate(resolvedValue)
    }

    /// 규칙 힌트 텍스트
    var validationHint: String? {
        PolicyFieldMeta.validationRules[id]?.hint
    }
}

// MARK: - PolicyFieldMeta

struct PolicyFieldMeta {
    let id: String
    let group: String
    let section: String
    let name: String
    let isDouble: Bool
}

// MARK: - 전체 필드 목록

extension PolicyFieldMeta {

    static let all: [PolicyFieldMeta] = career + fever + game + skill + equipment + housing + consumable + system + ad

    // MARK: 커리어

    private static let career: [PolicyFieldMeta] = [
        .init(id: "career.unemployed",          group: "커리어", section: "", name: "백수",             isDouble: false),
        .init(id: "career.laptopOwner",         group: "커리어", section: "", name: "노트북 보유자",     isDouble: false),
        .init(id: "career.aspiringDeveloper",   group: "커리어", section: "", name: "개발자 지망생",     isDouble: false),
        .init(id: "career.juniorDeveloper",     group: "커리어", section: "", name: "하찮은 개발자",     isDouble: false),
        .init(id: "career.normalDeveloper",     group: "커리어", section: "", name: "아무튼 개발자",     isDouble: false),
        .init(id: "career.nightOwlDeveloper",   group: "커리어", section: "", name: "밤 새는 개발자",    isDouble: false),
        .init(id: "career.skilledDeveloper",    group: "커리어", section: "", name: "유능한 개발자",     isDouble: false),
        .init(id: "career.famousDeveloper",     group: "커리어", section: "", name: "유명한 개발자",     isDouble: false),
        .init(id: "career.allRounderDeveloper", group: "커리어", section: "", name: "올라운더 개발자",   isDouble: false),
        .init(id: "career.worldClassDeveloper", group: "커리어", section: "", name: "월드클래스 개발자", isDouble: false),
    ]

    // MARK: 피버

    private static let fever: [PolicyFieldMeta] = [
        .init(id: "fever.maxPercent",       group: "피버", section: "기본", name: "최대 퍼센트",   isDouble: true),
        .init(id: "fever.decreaseInterval", group: "피버", section: "기본", name: "감소 간격(초)",  isDouble: true),
        .init(id: "fever.stageThreshold.stage0", group: "피버", section: "단계 임계값", name: "0단계", isDouble: true),
        .init(id: "fever.stageThreshold.stage1", group: "피버", section: "단계 임계값", name: "1단계", isDouble: true),
        .init(id: "fever.stageThreshold.stage2", group: "피버", section: "단계 임계값", name: "2단계", isDouble: true),
        .init(id: "fever.stageThreshold.stage3", group: "피버", section: "단계 임계값", name: "3단계", isDouble: true),
        .init(id: "fever.multiplier.stage0", group: "피버", section: "배율", name: "0단계", isDouble: true),
        .init(id: "fever.multiplier.stage1", group: "피버", section: "배율", name: "1단계", isDouble: true),
        .init(id: "fever.multiplier.stage2", group: "피버", section: "배율", name: "2단계", isDouble: true),
        .init(id: "fever.multiplier.stage3", group: "피버", section: "배율", name: "3단계", isDouble: true),
        .init(id: "fever.tap.decreasePercent", group: "피버", section: "탭", name: "감소 퍼센트",  isDouble: true),
        .init(id: "fever.tap.gainPerTap",      group: "피버", section: "탭", name: "탭당 획득량",  isDouble: true),
        .init(id: "fever.language.decreasePercent",  group: "피버", section: "언어", name: "감소 퍼센트",   isDouble: true),
        .init(id: "fever.language.gainPerCorrect",   group: "피버", section: "언어", name: "정답당 획득량", isDouble: true),
        .init(id: "fever.language.lossPerIncorrect", group: "피버", section: "언어", name: "오답당 손실량", isDouble: true),
        .init(id: "fever.dodge.decreasePercent",  group: "피버", section: "닷지", name: "감소 퍼센트",        isDouble: true),
        .init(id: "fever.dodge.gainPerSmallGold", group: "피버", section: "닷지", name: "소형 골드당 획득량", isDouble: true),
        .init(id: "fever.dodge.gainPerLargeGold", group: "피버", section: "닷지", name: "대형 골드당 획득량", isDouble: true),
        .init(id: "fever.dodge.gainPerBugDodge",  group: "피버", section: "닷지", name: "버그 회피당 획득량", isDouble: true),
        .init(id: "fever.dodge.lossPerBugHit",    group: "피버", section: "닷지", name: "버그 피격당 손실량", isDouble: true),
        .init(id: "fever.stack.decreasePercent", group: "피버", section: "스택", name: "감소 퍼센트",   isDouble: true),
        .init(id: "fever.stack.gainPerSuccess",  group: "피버", section: "스택", name: "성공당 획득량", isDouble: true),
        .init(id: "fever.stack.lossPerFailure",  group: "피버", section: "스택", name: "실패당 손실량", isDouble: true),
    ]

    // MARK: 게임

    private static let game: [PolicyFieldMeta] = [
        .init(id: "game.language.incorrectGoldLossMultiplier", group: "게임", section: "언어", name: "오답 골드 손실 배율", isDouble: true),
        .init(id: "game.dodge.smallGoldMultiplier",      group: "게임", section: "닷지", name: "소형 골드 배율",      isDouble: true),
        .init(id: "game.dodge.largeGoldMultiplier",      group: "게임", section: "닷지", name: "대형 골드 배율",      isDouble: true),
        .init(id: "game.dodge.bugHitLossGoldMultiplier", group: "게임", section: "닷지", name: "버그 피격 손실 배율", isDouble: true),
        .init(id: "game.dodge.bugDodgeGoldMultiplier",   group: "게임", section: "닷지", name: "버그 회피 골드 배율", isDouble: true),
        .init(id: "game.dodge.updateFPS",                group: "게임", section: "닷지", name: "업데이트 FPS",        isDouble: true),
        .init(id: "game.dodge.spawnInterval",            group: "게임", section: "닷지", name: "오브젝트 생성 간격",  isDouble: true),
        .init(id: "game.dodge.fallSpeed",                group: "게임", section: "닷지", name: "낙하 속도",           isDouble: true),
        .init(id: "game.dodge.smallGoldSpawnRate",       group: "게임", section: "닷지", name: "소형 골드 생성률",    isDouble: false),
        .init(id: "game.dodge.largeGoldSpawnRate",       group: "게임", section: "닷지", name: "대형 골드 생성률",    isDouble: false),
        .init(id: "game.dodge.bugSpawnRate",             group: "게임", section: "닷지", name: "버그 생성률",         isDouble: false),
        .init(id: "game.dodge.motion.deadZoneThreshold", group: "게임", section: "닷지 모션", name: "데드존 임계값", isDouble: true),
        .init(id: "game.dodge.motion.maxSpeed",          group: "게임", section: "닷지 모션", name: "최대 속도",     isDouble: true),
        .init(id: "game.dodge.motion.minSpeed",          group: "게임", section: "닷지 모션", name: "최소 속도",     isDouble: true),
        .init(id: "game.stack.failureGoldLossMultiplier", group: "게임", section: "스택", name: "실패 골드 손실 배율", isDouble: true),
        .init(id: "game.quiz.questionsPerGame",   group: "게임", section: "퀴즈", name: "게임당 문제 수",    isDouble: false),
        .init(id: "game.quiz.secondsPerQuestion", group: "게임", section: "퀴즈", name: "문제당 시간(초)",   isDouble: false),
        .init(id: "game.quiz.diamondsPerCorrect", group: "게임", section: "퀴즈", name: "정답당 다이아몬드", isDouble: false),
    ]

    // MARK: 스킬

    private static let skillLevelRange: [PolicyFieldMeta] = [
        .init(id: "skill.beginnerMinLevel",     group: "스킬", section: "레벨 범위", name: "초급 최소 레벨", isDouble: false),
        .init(id: "skill.beginnerMaxLevel",     group: "스킬", section: "레벨 범위", name: "초급 최대 레벨", isDouble: false),
        .init(id: "skill.intermediateMinLevel", group: "스킬", section: "레벨 범위", name: "중급 최소 레벨", isDouble: false),
        .init(id: "skill.intermediateMaxLevel", group: "스킬", section: "레벨 범위", name: "중급 최대 레벨", isDouble: false),
        .init(id: "skill.advancedMinLevel",     group: "스킬", section: "레벨 범위", name: "고급 최소 레벨", isDouble: false),
        .init(id: "skill.advancedMaxLevel",     group: "스킬", section: "레벨 범위", name: "고급 최대 레벨", isDouble: false),
    ]

    private static func skillFields(prefix: String, section: String) -> [PolicyFieldMeta] {
        [
            .init(id: "\(prefix).baseGold",                       group: "스킬", section: section, name: "기본 골드",          isDouble: false),
            .init(id: "\(prefix).beginnerGoldMultiplier",         group: "스킬", section: section, name: "초급 골드 배율",      isDouble: false),
            .init(id: "\(prefix).intermediateGoldMultiplier",     group: "스킬", section: section, name: "중급 골드 배율",      isDouble: false),
            .init(id: "\(prefix).advancedGoldMultiplier",         group: "스킬", section: section, name: "고급 골드 배율",      isDouble: false),
            .init(id: "\(prefix).beginnerGoldCostMultiplier",     group: "스킬", section: section, name: "초급 골드 비용 배율", isDouble: false),
            .init(id: "\(prefix).intermediateGoldCostMultiplier", group: "스킬", section: section, name: "중급 골드 비용 배율", isDouble: false),
            .init(id: "\(prefix).advancedGoldCostMultiplier",     group: "스킬", section: section, name: "고급 골드 비용 배율", isDouble: false),
            .init(id: "\(prefix).diamondCostDivider",             group: "스킬", section: section, name: "다이아 비용 분배",    isDouble: false),
            .init(id: "\(prefix).diamondCostMultiplier",          group: "스킬", section: section, name: "다이아 비용 배율",    isDouble: false),
            .init(id: "\(prefix).intermediateUnlockLevel",        group: "스킬", section: section, name: "중급 해금 레벨",      isDouble: false),
            .init(id: "\(prefix).advancedUnlockLevel",            group: "스킬", section: section, name: "고급 해금 레벨",      isDouble: false),
        ]
    }

    private static let skill: [PolicyFieldMeta] = skillLevelRange
        + skillFields(prefix: "skill.tap",      section: "탭")
        + skillFields(prefix: "skill.language", section: "언어")
        + skillFields(prefix: "skill.dodge",    section: "닷지")
        + skillFields(prefix: "skill.stack",    section: "스택")

    // MARK: 장비

    private static let rarities: [(key: String, name: String)] = [
        ("broken",           "고장난"),
        ("cheap",            "싸구려"),
        ("vintage",          "빈티지"),
        ("decent",           "쓸만한"),
        ("premium",          "고오급"),
        ("diamond",          "다이아"),
        ("limited",          "한정판"),
        ("nationalTreasure", "국보급"),
    ]

    private static let equipment: [PolicyFieldMeta] = {
        var fields: [PolicyFieldMeta] = []
        for r in rarities {
            fields.append(.init(id: "equipment.\(r.key)UpgradeCost",    group: "장비", section: "업그레이드 골드 비용",  name: r.name, isDouble: false))
        }
        for r in rarities {
            fields.append(.init(id: "equipment.\(r.key)UpgradeDiamond", group: "장비", section: "업그레이드 다이아 비용", name: r.name, isDouble: false))
        }
        for r in rarities {
            fields.append(.init(id: "equipment.\(r.key)SuccessRate",    group: "장비", section: "업그레이드 성공률",      name: r.name, isDouble: true))
        }
        let items: [(key: String, name: String)] = [
            ("keyboard", "키보드"), ("mouse", "마우스"), ("monitor", "모니터"), ("chair", "의자")
        ]
        for item in items {
            for r in rarities {
                fields.append(.init(
                    id: "equipment.\(item.key).\(r.key)GoldPerSecond",
                    group: "장비",
                    section: "\(item.name) 초당 골드",
                    name: r.name,
                    isDouble: false
                ))
            }
        }
        return fields
    }()

    // MARK: 주거

    private static let housings: [(key: String, name: String)] = [
        ("street",       "길바닥"),
        ("semiBasement", "반지하"),
        ("rooftop",      "옥탑방"),
        ("villa",        "빌라"),
        ("apartment",    "아파트"),
        ("house",        "단독주택"),
        ("pentHouse",    "펜트하우스"),
    ]

    private static let housing: [PolicyFieldMeta] = {
        var fields: [PolicyFieldMeta] = []
        for h in housings {
            fields.append(.init(id: "housing.\(h.key)PurchaseCost",  group: "주거", section: "구매 비용", name: h.name, isDouble: false))
        }
        for h in housings {
            fields.append(.init(id: "housing.\(h.key)GoldPerSecond", group: "주거", section: "초당 골드", name: h.name, isDouble: false))
        }
        return fields
    }()

    // MARK: 소비 아이템

    private static let consumable: [PolicyFieldMeta] = [
        .init(id: "consumable.coffee.duration",            group: "소비 아이템", section: "커피",         name: "지속 시간(초)", isDouble: false),
        .init(id: "consumable.coffee.buffMultiplier",      group: "소비 아이템", section: "커피",         name: "버프 배율",     isDouble: true),
        .init(id: "consumable.coffee.priceDiamond",        group: "소비 아이템", section: "커피",         name: "다이아 가격",   isDouble: false),
        .init(id: "consumable.energyDrink.duration",       group: "소비 아이템", section: "에너지 드링크", name: "지속 시간(초)", isDouble: false),
        .init(id: "consumable.energyDrink.buffMultiplier", group: "소비 아이템", section: "에너지 드링크", name: "버프 배율",     isDouble: true),
        .init(id: "consumable.energyDrink.priceDiamond",   group: "소비 아이템", section: "에너지 드링크", name: "다이아 가격",   isDouble: false),
    ]

    // MARK: 시스템

    private static let system: [PolicyFieldMeta] = [
        .init(id: "system.autoGain.interval",              group: "시스템", section: "자동 획득", name: "획득 간격(초)",         isDouble: true),
        .init(id: "system.buff.decreaseInterval",          group: "시스템", section: "버프",      name: "감소 간격(초)",         isDouble: true),
        .init(id: "system.scenario.maxLevelupQueueSize",   group: "시스템", section: "시나리오",  name: "레벨업 큐 최대 크기",    isDouble: false),
        .init(id: "system.offlineReward.minimumHours",      group: "시스템", section: "오프라인 보상", name: "최소 경과 시간(시)",          isDouble: true),
        .init(id: "system.offlineReward.serverTimeTimeout", group: "시스템", section: "오프라인 보상", name: "서버 시간 조회 타임아웃(초)", isDouble: true),
        .init(id: "system.offlineReward.allowedTimeDrift",  group: "시스템", section: "오프라인 보상", name: "허용 오차(초)",              isDouble: true),
    ]

    // MARK: 광고

    private static let ad: [PolicyFieldMeta] = [
        .init(id: "ad.skillReward.dailyLimit",       group: "광고", section: "스킬 보상", name: "1일 사용 횟수",    isDouble: false),
        .init(id: "ad.skillReward.rewardMultiplier", group: "광고", section: "스킬 보상", name: "보상 배율",        isDouble: true),
        .init(id: "ad.skillReward.rewardDuration",   group: "광고", section: "스킬 보상", name: "보상 지속 시간(초)", isDouble: false),
    ]
}

// MARK: - PolicyDTO ↔ [PolicyField] 변환

extension PolicyFieldMeta {

    static func makeFields(from policy: PolicyDTO, formulas: [String: String] = [:]) throws -> [PolicyField] {
        let values = try policy.toValueDictionary()
        return all.map { meta in
            // 이전 버전에 없는 신규 필드는 0으로 기본값 설정
            let value = values[meta.id] ?? 0
            let rawInput = formulas[meta.id] ?? (
                meta.isDouble
                    ? String(value)
                    : String(Int(value.rounded()))
            )
            return PolicyField(
                id: meta.id,
                group: meta.group,
                section: meta.section,
                name: meta.name,
                isDouble: meta.isDouble,
                rawInput: rawInput,
                resolvedValue: value
            )
        }
    }

    static func makePolicy(from fields: [PolicyField]) throws -> PolicyDTO {
        let metaMap = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
        var dict: [String: Double] = [:]
        for field in fields {
            dict[field.id] = field.resolvedValue
        }
        return try PolicyDTO.from(dictionary: dict, fieldMetas: metaMap)
    }
}

// MARK: - PolicyDTO 직렬화 확장

extension PolicyDTO {

    func toValueDictionary() throws -> [String: Double] {
        let data = try JSONEncoder().encode(self)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw SerializationError.invalidFormat
        }
        var result: [String: Double] = [:]
        flattenJSON(json, prefix: "", into: &result)
        result.removeValue(forKey: "version")
        return result
    }

    private func flattenJSON(_ json: [String: Any], prefix: String, into result: inout [String: Double]) {
        for (key, value) in json {
            let fullKey = prefix.isEmpty ? key : "\(prefix).\(key)"
            switch value {
            case let nested as [String: Any]:
                flattenJSON(nested, prefix: fullKey, into: &result)
            case let num as NSNumber:
                result[fullKey] = num.doubleValue
            default:
                break
            }
        }
    }

    static func from(dictionary: [String: Double], fieldMetas: [String: PolicyFieldMeta]) throws -> PolicyDTO {
        var nested: [String: Any] = ["version": ""]
        for (key, value) in dictionary {
            let isDouble = fieldMetas[key]?.isDouble ?? true
            let jsonValue: Any = isDouble ? value : Int(value.rounded())
            setNestedValue(jsonValue, for: key.split(separator: ".").map(String.init), in: &nested)
        }
        let data = try JSONSerialization.data(withJSONObject: nested)
        return try JSONDecoder().decode(PolicyDTO.self, from: data)
    }

    private static func setNestedValue(_ value: Any, for keys: [String], in dict: inout [String: Any]) {
        guard !keys.isEmpty else { return }
        if keys.count == 1 {
            dict[keys[0]] = value
        } else {
            var child = (dict[keys[0]] as? [String: Any]) ?? [:]
            setNestedValue(value, for: Array(keys.dropFirst()), in: &child)
            dict[keys[0]] = child
        }
    }

    enum SerializationError: Error {
        case invalidFormat
    }
}
