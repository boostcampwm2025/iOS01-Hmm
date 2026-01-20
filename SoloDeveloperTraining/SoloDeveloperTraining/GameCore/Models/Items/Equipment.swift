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
        let goldDifference = nextEquipment.goldPerSecond - goldPerSecond
        return "초 당 획득 골드 +\(goldDifference)"
    }
    var cost: Cost {
        return tier.cost
    }
    var imageName: String {
        return "item_\(type.imageName)_\(tier.imageName)"
    }

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
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
            }
        case .mouse:
            switch tier {
            case .broken:
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
            }
        case .monitor:
            switch tier {
            case .broken:
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
            }
        case .chair:
            switch tier {
            case .broken:
                return 100
            case .cheap:
                return 150
            case .vintage:
                return 200
            case .decent:
                return 300
            case .premium:
                return 500
            case .diamond:
                return 1000
            case .limited:
                return 2000
            case .nationalTreasure:
                return 5000
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

    /// 업그레이드 비용
    var cost: Cost {
        switch self {
        case .broken:
            return Cost(gold: 50_000)
        case .cheap:
            return Cost(gold: 100_000)
        case .vintage:
            return Cost(gold: 200_000)
        case .decent:
            return Cost(gold: 500_000)
        case .premium:
            return Cost(gold: 1_000_000)
        case .diamond:
            return Cost(gold: 2_000_000)
        case .limited:
            return Cost(gold: 5_000_000)
        case .nationalTreasure:
            return Cost(gold: 999_999_999_999)
        }
    }

    /// 업그레이드 성공 확률 (0.0 ~ 1.0)
    var upgradeSuccessRate: Double {
        switch self {
        case .broken:
            return 1.0
        case .cheap:
            return 0.8
        case .vintage:
            return 0.6
        case .decent:
            return 0.4
        case .premium:
            return 0.3
        case .diamond:
            return 0.2
        case .limited:
            return 0.1
        case .nationalTreasure:
            return 0.0
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
