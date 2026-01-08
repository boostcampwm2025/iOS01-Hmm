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
}

enum ConsumableType {
    case coffee
    case energyDrink
    
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
}
