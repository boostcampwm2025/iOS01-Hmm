//
//  Consumable.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/8/26.
//

import Foundation

final class Consumable {
    let type: ConsumableType
    var count: Int
    
    init(type: ConsumableType, count: Int) {
        self.type = type
        self.count = count
    }
    
    var displayTitle: String {
        return type.displayTitle + " (보유:\(count)개)"
    }
}

enum ConsumableType {
    case coffee
    case energyDrink
    
    var displayTitle: String {
        switch self {
        case .coffee:
            return "커피"
        case .energyDrink:
            return "박하스"
        }
    }
    
    /// 버프 가중치
    var buffMultiplier: Double {
        switch self {
        case .coffee:
            return 1.5
        case .energyDrink:
            return 2.0
        }
    }
    
    /// 지속시간
    var duration: Int {
        switch self {
        case .coffee:
            return 30
        case .energyDrink:
            return 15
        }
    }
    
    /// 비용
    var cost: Cost {
        switch self {
        case .coffee:
            return .init(diamond: 5)
        case .energyDrink:
            return .init(diamond: 10)
        }
    }
}
