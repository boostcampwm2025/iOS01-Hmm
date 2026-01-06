//
//  Equipment.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class Equipment {
    var tier: EquipmentTier
    
    init(tier: EquipmentTier) {
        self.tier = tier
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
