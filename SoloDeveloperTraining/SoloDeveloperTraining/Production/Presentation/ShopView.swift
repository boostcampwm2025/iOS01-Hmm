//
//  ShopView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let itemCard: CGFloat = 12
        static let popupContent: CGFloat = 11
        static let popupButton: CGFloat = 15
    }

    enum Padding {
        static let horizontal: CGFloat = 16
        static let popupTop: CGFloat = 11
        static let housingTop: CGFloat = 15
        static let housingBottom: CGFloat = 23
    }
}

struct ShopView: View {
    private let user: User
    private let shopSystem: ShopSystem

    @State private var selectedCategoryIndex: Int = 0
    @State private var selectedHousingTier: HousingTier?
    @Binding var popupContent: (String, AnyView)?

    init(user: User, popupContent: Binding<(String, AnyView)?>) {
        self.user = user
        self.shopSystem = ShopSystem(user: user)
        self._popupContent = popupContent
    }

    var body: some View {
        VStack {
            DefaultSegmentControl(
                selection: $selectedCategoryIndex,
                segments: ["아이템", "부동산"]
            )
            .padding(.horizontal, Constant.Padding.horizontal)

            if selectedCategoryIndex == 0 {
                itemView
            } else {
                housingView
            }
        }
    }
}

private extension ShopView {
    var displayItems: [DisplayItem] {
        if selectedCategoryIndex == 0 {
            return shopSystem.itemList(itemTypes: [.consumable, .equipment])
        } else {
            return shopSystem.itemList(itemTypes: [.housing])
        }
    }

    var itemView: some View {
        ScrollView {
            LazyVStack(spacing: Constant.Spacing.itemCard) {
                ForEach(displayItems) { item in
                    ItemRow(
                        title: item.displayTitle,
                        description: item.description,
                        imageName: item.imageName,
                        cost: item.cost,
                        state: itemState(for: item)
                    ) {
                        purchase(item: item)
                    }
                }
            }
            .padding(.bottom)
        }
        .scrollIndicators(.hidden)
    }

    var housingView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: Constant.Spacing.itemCard) {
                ForEach(displayItems) { item in
                    if let housing = item.item as? Housing {
                        HousingCard(
                            housing: housing,
                            isEquipped: item.isEquipped,
                            isPurchasable: item.isPurchasable,
                            isSelected: selectedHousingTier == housing.tier,
                            onTap: {
                                selectedHousingTier = housing.tier
                            },
                            onButtonTap: {
                                selectedHousingTier = housing.tier
                                purchase(item: item)
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, Constant.Padding.horizontal)
            .padding(.top, Constant.Padding.housingTop)
            .padding(.bottom, Constant.Padding.housingBottom)
        }
        .scrollIndicators(.hidden)
    }

    /// 아이템 상태 결정
    func itemState(for item: DisplayItem) -> ItemState {
        if item.isEquipped && item.category == .housing {
            return .locked
        }
        return item.isPurchasable ? .available : .insufficient
    }

    /// 아이템 구매 확인 팝업 표시
    func purchase(item: DisplayItem) {
        let (title, message, buttonTitle) = purchaseInfo(for: item)
        let fullMessage = createPurchaseMessage(item: item, baseMessage: message)

        showConfirmPopup(
            title: title,
            message: fullMessage,
            confirmTitle: buttonTitle
        ) {
            executePurchase(item: item)
        }
    }

    /// 구매 정보 생성
    func purchaseInfo(for item: DisplayItem) -> (title: String, message: String, buttonTitle: String) {
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
    func createPurchaseMessage(item: DisplayItem, baseMessage: String) -> String {
        let priceText = createPriceText(for: item)
        let prefix = item.category == .housing && shopSystem.calculateHousingNetCost(for: item) < 0 ? "를 환불받고" : "를 사용하여"
        return "\(priceText)\(prefix)\n\(baseMessage)"
    }

    /// 가격 텍스트 생성
    func createPriceText(for item: DisplayItem) -> String {
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

    /// 실제 구매 실행
    func executePurchase(item: DisplayItem) {
        do {
            let isSuccess = try shopSystem.buy(item: item)
            if item.category == .equipment {
                let title = isSuccess ? "강화 성공" : "강화 실패"
                let message = isSuccess ? "강화에 성공했습니다!" : "강화에 실패했습니다.\n비용은 소모되었습니다."
                showAlertPopup(title: title, message: message)
            }
        } catch let error as PurchasingError {
            showAlertPopup(title: "구매 실패", message: error.message)
        } catch {
            showAlertPopup(title: "구매 실패", message: "구매에 실패했습니다.")
        }
    }

    /// 확인 팝업 표시 (취소/확인 버튼)
    func showConfirmPopup(title: String, message: String, confirmTitle: String, onConfirm: @escaping () -> Void) {
        popupContent = (
            title,
            AnyView(
                VStack(spacing: Constant.Spacing.popupContent) {
                    Text(message)
                        .textStyle(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    HStack(spacing: Constant.Spacing.popupButton) {
                        MediumButton(title: "취소", isFilled: true, isCancelButton: true) {
                            popupContent = nil
                        }
                        MediumButton(title: confirmTitle, isFilled: true) {
                            popupContent = nil
                            onConfirm()
                        }
                    }
                }
                .padding(.top, Constant.Padding.popupTop)
            )
        )
    }

    /// 알림 팝업 표시 (확인 버튼만)
    func showAlertPopup(title: String, message: String) {
        popupContent = (
            title,
            AnyView(
                VStack(spacing: Constant.Spacing.popupContent) {
                    Text(message)
                        .textStyle(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    MediumButton(title: "확인", isFilled: true) {
                        popupContent = nil
                    }
                }
                .padding(.top, Constant.Padding.popupTop)
            )
        )
    }
}

#Preview {
    let user = User(
        nickname: "테스트",
        wallet: .init(gold: 1_000_000, diamond: 100),
        inventory: .init(),
        record: .init(),
        skills: [
            .init(key: SkillKey(game: .tap, tier: .beginner), level: 1)
        ]
    )
    Spacer()
        .frame(height: 500)
    ShopView(user: user, popupContent: .constant(nil))
}
