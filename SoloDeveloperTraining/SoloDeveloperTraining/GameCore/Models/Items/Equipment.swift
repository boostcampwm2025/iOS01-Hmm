//
//  Equipment.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 장비 아이템 클래스
final class Equipment: Item {
    // MARK: - Item
    var displayTitle: String {
        return tier.displayTitle + " " + type.displayTitle
    }
    var description: String {
        guard canUpgrade else {
            return "최종 단계"
        }
        let nextTier = EquipmentTier(rawValue: tier.rawValue + 1) ?? .nationalTreasure
        let nextEquipment = Equipment(type: type, tier: nextTier)
        return "강화시 초당 골드 획득량 \(goldPerSecond.formatted) -> \(nextEquipment.goldPerSecond.formatted)"
    }
    var cost: Cost {
        return tier.cost
    }
    var imageName: String {
        return "item_\(type.imageName)_\(tier.imageName)"
    }
    var category: ItemCategory = .equipment

    // MARK: - Equipment
    /// 장비 타입
    var type: EquipmentType
    /// 장비 등급
    var tier: EquipmentTier

    /// 장비 초기화
    init(type: EquipmentType, tier: EquipmentTier) {
        self.type = type
        self.tier = tier
    }

    /// 업그레이드 가능 여부
    var canUpgrade: Bool {
        return tier != .nationalTreasure
    }

    /// 초 당 획득 골드
    var goldPerSecond: Int {
        switch type {
        case .keyboard:
            switch tier {
            case .broken:
                return Policy.Equipment.Keyboard.brokenGoldPerSecond
            case .cheap:
                return Policy.Equipment.Keyboard.cheapGoldPerSecond
            case .vintage:
                return Policy.Equipment.Keyboard.vintageGoldPerSecond
            case .decent:
                return Policy.Equipment.Keyboard.decentGoldPerSecond
            case .premium:
                return Policy.Equipment.Keyboard.premiumGoldPerSecond
            case .diamond:
                return Policy.Equipment.Keyboard.diamondGoldPerSecond
            case .limited:
                return Policy.Equipment.Keyboard.limitedGoldPerSecond
            case .nationalTreasure:
                return Policy.Equipment.Keyboard.nationalTreasureGoldPerSecond
            }
        case .mouse:
            switch tier {
            case .broken:
                return Policy.Equipment.Mouse.brokenGoldPerSecond
            case .cheap:
                return Policy.Equipment.Mouse.cheapGoldPerSecond
            case .vintage:
                return Policy.Equipment.Mouse.vintageGoldPerSecond
            case .decent:
                return Policy.Equipment.Mouse.decentGoldPerSecond
            case .premium:
                return Policy.Equipment.Mouse.premiumGoldPerSecond
            case .diamond:
                return Policy.Equipment.Mouse.diamondGoldPerSecond
            case .limited:
                return Policy.Equipment.Mouse.limitedGoldPerSecond
            case .nationalTreasure:
                return Policy.Equipment.Mouse.nationalTreasureGoldPerSecond
            }
        case .monitor:
            switch tier {
            case .broken:
                return Policy.Equipment.Monitor.brokenGoldPerSecond
            case .cheap:
                return Policy.Equipment.Monitor.cheapGoldPerSecond
            case .vintage:
                return Policy.Equipment.Monitor.vintageGoldPerSecond
            case .decent:
                return Policy.Equipment.Monitor.decentGoldPerSecond
            case .premium:
                return Policy.Equipment.Monitor.premiumGoldPerSecond
            case .diamond:
                return Policy.Equipment.Monitor.diamondGoldPerSecond
            case .limited:
                return Policy.Equipment.Monitor.limitedGoldPerSecond
            case .nationalTreasure:
                return Policy.Equipment.Monitor.nationalTreasureGoldPerSecond
            }
        case .chair:
            switch tier {
            case .broken:
                return Policy.Equipment.Chair.brokenGoldPerSecond
            case .cheap:
                return Policy.Equipment.Chair.cheapGoldPerSecond
            case .vintage:
                return Policy.Equipment.Chair.vintageGoldPerSecond
            case .decent:
                return Policy.Equipment.Chair.decentGoldPerSecond
            case .premium:
                return Policy.Equipment.Chair.premiumGoldPerSecond
            case .diamond:
                return Policy.Equipment.Chair.diamondGoldPerSecond
            case .limited:
                return Policy.Equipment.Chair.limitedGoldPerSecond
            case .nationalTreasure:
                return Policy.Equipment.Chair.nationalTreasureGoldPerSecond
            }
        }
    }

    /// 강화 확률에 따라 업그레이드
    func upgraded() -> Bool {
        guard canUpgrade else { return false }

        let randomValue = Double.random(in: 0...1)

        if randomValue <= tier.upgradeSuccessRate {
            self.tier = EquipmentTier(rawValue: tier.rawValue + 1) ?? .nationalTreasure
            return true
        } else {
            return false
        }
    }
}

/// 장비 종류
enum EquipmentType {
    /// 키보드
    case keyboard
    /// 마우스
    case mouse
    /// 모니터
    case monitor
    /// 의자
    case chair

    /// 화면에 표시될 제목
    var displayTitle: String {
        switch self {
        case .keyboard:
            return "키보드"
        case .mouse:
            return "마우스"
        case .monitor:
            return "모니터"
        case .chair:
            return "의자"
        }
    }

    var imageName: String {
        switch self {
        case .keyboard:
            return "keyboard"
        case .mouse:
            return "mouse"
        case .monitor:
            return "monitor"
        case .chair:
            return "chair"
        }
    }
}

/// 장비 등급
enum EquipmentTier: Int {
    /// 고장난
    case broken = 0
    /// 싸구려
    case cheap = 1
    /// 빈티지
    case vintage = 2
    /// 쓸만한
    case decent = 3
    /// 고급
    case premium = 4
    /// 다이아
    case diamond = 5
    /// 한정판
    case limited = 6
    /// 국보급
    case nationalTreasure = 7

    /// 화면에 표시될 제목
    var displayTitle: String {
        switch self {
        case .broken: "고장난"
        case .cheap: "싸구려"
        case .vintage: "빈티지"
        case .decent: "쓸만한"
        case .premium: "고오급"
        case .diamond: "다이아"
        case .limited: "한정판"
        case .nationalTreasure: "국보급"
        }
    }

    /// 업그레이드 비용 (골드 + 다이아몬드)
    var cost: Cost {
        switch self {
        case .broken:
            return Cost(gold: Policy.Equipment.brokenUpgradeCost, diamond: Policy.Equipment.brokenUpgradeDiamond)
        case .cheap:
            return Cost(gold: Policy.Equipment.cheapUpgradeCost, diamond: Policy.Equipment.cheapUpgradeDiamond)
        case .vintage:
            return Cost(gold: Policy.Equipment.vintageUpgradeCost, diamond: Policy.Equipment.vintageUpgradeDiamond)
        case .decent:
            return Cost(gold: Policy.Equipment.decentUpgradeCost, diamond: Policy.Equipment.decentUpgradeDiamond)
        case .premium:
            return Cost(gold: Policy.Equipment.premiumUpgradeCost, diamond: Policy.Equipment.premiumUpgradeDiamond)
        case .diamond:
            return Cost(gold: Policy.Equipment.diamondUpgradeCost, diamond: Policy.Equipment.diamondUpgradeDiamond)
        case .limited:
            return Cost(gold: Policy.Equipment.limitedUpgradeCost, diamond: Policy.Equipment.limitedUpgradeDiamond)
        case .nationalTreasure:
            return Cost(gold: Policy.Equipment.nationalTreasureUpgradeCost, diamond: Policy.Equipment.nationalTreasureUpgradeDiamond)
        }
    }

    /// 업그레이드 성공 확률 (0.0 ~ 1.0)
    var upgradeSuccessRate: Double {
        switch self {
        case .broken:
            return Policy.Equipment.brokenSuccessRate
        case .cheap:
            return Policy.Equipment.cheapSuccessRate
        case .vintage:
            return Policy.Equipment.vintageSuccessRate
        case .decent:
            return Policy.Equipment.decentSuccessRate
        case .premium:
            return Policy.Equipment.premiumSuccessRate
        case .diamond:
            return Policy.Equipment.diamondSuccessRate
        case .limited:
            return Policy.Equipment.limitedSuccessRate
        case .nationalTreasure:
            return Policy.Equipment.nationalTreasureSuccessRate
        }
    }

    var imageName: String {
        switch self {
        case .broken:
            return "broken"
        case .cheap:
            return "cheap"
        case .vintage:
            return "vintage"
        case .decent:
            return "decent"
        case .premium:
            return "premium"
        case .diamond:
            return "diamond"
        case .limited:
            return "limited"
        case .nationalTreasure:
            return "nationalTreasure"
        }
    }
}
