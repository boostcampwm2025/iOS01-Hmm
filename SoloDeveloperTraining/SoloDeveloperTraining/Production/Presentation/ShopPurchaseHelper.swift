//
//  ShopPurchaseHelper.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import Foundation
import SwiftUI

private enum Constant {
    enum Spacing {
        static let popupContent: CGFloat = 11
        static let popupButton: CGFloat = 15
    }

    enum Padding {
        static let popupTop: CGFloat = 11
        static let popupHorizontal: CGFloat = 25
    }
}

enum ShopPurchaseHelper {
    /// 확인 팝업 표시 (취소/확인 버튼)
    static func showConfirm(
        popupContent: Binding<PopupConfiguration?>,
        title: String,
        message: String,
        confirmTitle: String,
        onConfirm: @escaping () -> Void
    ) {
        popupContent.wrappedValue = PopupConfiguration(
            title: title,
            maxHeight: nil
        ) {
            VStack(spacing: Constant.Spacing.popupContent) {
                Text(message)
                    .textStyle(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                HStack(spacing: Constant.Spacing.popupButton) {
                    MediumButton(title: "취소", isFilled: true, isCancelButton: true) {
                        popupContent.wrappedValue = nil
                    }
                    MediumButton(title: confirmTitle, isFilled: true) {
                        popupContent.wrappedValue = nil
                        onConfirm()
                    }
                }
            }
            .padding(.top, Constant.Padding.popupTop)
        }
    }

    /// 알림 팝업 표시 (확인 버튼만)
    static func showAlert(
        popupContent: Binding<PopupConfiguration?>,
        title: String,
        message: String
    ) {
        popupContent.wrappedValue = PopupConfiguration(
            title: title,
            maxHeight: nil
        ) {
            VStack(spacing: Constant.Spacing.popupContent) {
                Text(message)
                    .textStyle(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                MediumButton(title: "확인", isFilled: true) {
                    popupContent.wrappedValue = nil
                }
            }
            .padding(.top, Constant.Padding.popupTop)
        }
    }

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

    /// 구매 메시지 생성
    static func createPurchaseMessage(item: DisplayItem, baseMessage: String, shopSystem: ShopSystem) -> String {
        let priceText = createPriceText(for: item, shopSystem: shopSystem)
        let prefix = item.category == .housing && shopSystem.calculateHousingNetCost(for: item) < 0 ? "를 환불받고" : "를 사용하여"
        return "\(priceText)\(prefix)\n\(baseMessage)"
    }

    /// 가격 텍스트 생성
    static func createPriceText(for item: DisplayItem, shopSystem: ShopSystem) -> String {
        var components: [String] = []

        if item.category == .housing {
            let netCost = shopSystem.calculateHousingNetCost(for: item)
            components.append("\(abs(netCost).formatted) 골드")
        } else {
            if item.cost.gold > 0 { components.append("\(item.cost.gold.formatted) 골드") }
            if item.cost.diamond > 0 { components.append("\(item.cost.diamond.formatted) 다이아") }
        }

        return "[\(components.joined(separator: ", "))]"
    }
}
