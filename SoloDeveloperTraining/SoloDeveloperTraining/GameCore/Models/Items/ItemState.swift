//
//  ItemState.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-20.
//

import Foundation

enum ItemState {
    case available      // 구매 가능
    case locked         // 잠김
    case insufficient   // 비용 부족

    init(item: DisplayItem) {
        if item.isEquipped && item.category == .housing {
            self = .locked
        } else if item.isPurchasable {
            self = .available
        } else {
            self = .insufficient
        }
    }

    init(canUnlock: Bool, canAfford: Bool) {
        if !canUnlock {
            self = .locked
        } else if !canAfford {
            self = .insufficient
        } else {
            self = .available
        }
    }
}
