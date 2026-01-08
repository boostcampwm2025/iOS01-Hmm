//
//  Equipment.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class Equipment {
    var type: EquipmentType
    var tier: EquipmentTier
    
    var displayTitle: String {
        return tier.displayTitle + " " + type.displayTitle
    }
    
    /// 업그레이드 가능 여부
    var canUpgrade: Bool {
        return tier != .nationalTreasure
    }
    
    /// 업그레이드 비용
    var upgradeCost: Cost {
        switch tier {
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
        switch tier {
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

    init(type: EquipmentType, tier: EquipmentTier) {
        self.type = type
        self.tier = tier
    }
    
    /// 강화 확률에 따라 업그레이드
    func upgraded() {
        guard canUpgrade else { return }
        
        let randomValue = Double.random(in: 0...1)
        
        if randomValue <= upgradeSuccessRate {
            self.tier = EquipmentTier(rawValue: tier.rawValue + 1) ?? .nationalTreasure
        }
    }
}

enum EquipmentType {
    case keyboard
    case mouse
    case monitor
    case chair
    
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
}

enum EquipmentTier: Int {
    case broken = 0
    case cheap = 1
    case vintage = 2
    case decent = 3
    case premium = 4
    case diamond = 5
    case limited = 6
    case nationalTreasure = 7
    
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
}
