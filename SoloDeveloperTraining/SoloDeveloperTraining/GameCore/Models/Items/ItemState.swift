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
    case reachedMax     // 최고 레벨

    init(item: DisplayItem) {
        // 장비 최고 레벨 체크
        if let equipment = item.item as? Equipment, !equipment.canUpgrade {
            self = .reachedMax
            return
        }

        // 주거 아이템이 이미 장착되어 있으면 잠김
        if item.isEquipped && item.category == .housing {
            self = .locked
            return
        }

        // 구매 가능 여부
        if item.isPurchasable {
            self = .available
        } else {
            self = .insufficient
        }
    }

    init(canUpgrade: Bool, canUnlock: Bool, canAfford: Bool) {
        switch (canUpgrade, canUnlock, canAfford) {
        case (false, _, _):
            self = .reachedMax
        case (true, false, _):
            self = .locked
        case (true, true, false):
            self = .insufficient
        case (true, true, true):
            self = .available
        }
    }
}
