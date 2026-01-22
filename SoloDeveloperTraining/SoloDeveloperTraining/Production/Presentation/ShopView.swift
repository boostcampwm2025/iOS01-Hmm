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
    }

    enum Padding {
        static let horizontal: CGFloat = 16
        static let housingTop: CGFloat = 15
        static let housingBottom: CGFloat = 23
    }
}

struct ShopView: View {
    private let user: User
    private let shopSystem: ShopSystem

    @State private var selectedCategoryIndex: Int = 0
    @State private var selectedHousingTier: HousingTier?
    @Binding var popupContent: PopupConfiguration?

    init(user: User, popupContent: Binding<PopupConfiguration?>) {
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
                        state: ItemState(item: item)
                    ) {
                        purchase(item: item)
                    }
                }
            }
            .padding(.bottom)
        }
        .scrollIndicators(.never)
    }

    var housingView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: Constant.Spacing.itemCard) {
                ForEach(displayItems) { item in
                    if let housing = item.item as? Housing {
                        HousingCard(
                            housing: housing,
                            state: ItemState(item: item),
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
        .scrollIndicators(.never)
    }

    /// 아이템 구매 확인 팝업 표시
    func purchase(item: DisplayItem) {
        let (title, message, buttonTitle) = ShopPurchaseHelper.purchaseInfo(for: item)
        let fullMessage = ShopPurchaseHelper.createPurchaseMessage(item: item, baseMessage: message, shopSystem: shopSystem)

        ShopPurchaseHelper.showConfirm(
            popupContent: $popupContent,
            title: title,
            message: fullMessage,
            confirmTitle: buttonTitle
        ) {
            executePurchase(item: item)
        }
    }

    /// 실제 구매 실행
    func executePurchase(item: DisplayItem) {
        do {
            let isSuccess = try shopSystem.buy(item: item)
            if item.category == .equipment {
                let title = isSuccess ? "강화 성공" : "강화 실패"
                let message = isSuccess ? "강화에 성공했습니다!" : "강화에 실패했습니다.\n비용은 소모되었습니다."
                ShopPurchaseHelper.showAlert(popupContent: $popupContent, title: title, message: message)
            }
        } catch let error as PurchasingError {
            ShopPurchaseHelper.showAlert(popupContent: $popupContent, title: "구매 실패", message: error.message)
        } catch {
            ShopPurchaseHelper.showAlert(popupContent: $popupContent, title: "구매 실패", message: "구매에 실패했습니다.")
        }
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
