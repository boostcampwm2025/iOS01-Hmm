//
//  Equipment.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class Equipment {
    var tier: EquipmentTier
    
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
    
    init(tier: EquipmentTier) {
        self.tier = tier
    }

    
    /// 해당 장비의 티어를 업그레이드 합니다.
    /// - Returns: 해당 장비의 다음 단계 장비( 최고 단계인 경우 최고단계로 고정)
    func upgraded() -> Equipment {
        guard let nextTier = EquipmentTier(rawValue: tier.rawValue + 1) else {
            return self
        }
        return Equipment(tier: nextTier)
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
