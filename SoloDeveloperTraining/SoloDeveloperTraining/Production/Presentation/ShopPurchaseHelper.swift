//
//  ShopPurchaseHelper.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import Foundation

enum ShopPurchaseHelper {
    /// 구매 정보 생성
    static func purchaseInfo(for item: DisplayItem) -> (title: String, message: String, buttonTitle: String) {
        switch item.category {
        case .equipment:
            let successRate = (item.item as? Equipment).map { Int($0.tier.upgradeSuccessRate * 100) }
            let message = successRate.map { "강화하시겠습니까?\n(성공 확률: \($0)%)" } ?? "강화하시겠습니까?"
            return ("장비 강화", message, "강화")
        case .housing:
            return ("부동산 구매", "구매하시겠습니까?", "구매")
        case .consumable:
            return ("아이템 구매", "구매하시겠습니까?", "구매")
        }
    }

    /// 가격 텍스트 생성
    static func createPriceText(for item: DisplayItem, shopSystem: ShopSystem) -> String {
        var components: [String] = []

        if item.category == .housing {
            // 부동산은 원래 금액 전액 표시 (업그레이드만 가능)
            if item.cost.gold > 0 { components.append("\(item.cost.gold.formatted) 골드") }
            if item.cost.diamond > 0 { components.append("\(item.cost.diamond.formatted) 다이아") }
            if components.isEmpty { components.append("0 골드") }
        } else {
            if item.cost.gold > 0 { components.append("\(item.cost.gold.formatted) 골드") }
            if item.cost.diamond > 0 { components.append("\(item.cost.diamond.formatted) 다이아") }
        }

        return "[\(components.joined(separator: ", "))]"
    }
}
