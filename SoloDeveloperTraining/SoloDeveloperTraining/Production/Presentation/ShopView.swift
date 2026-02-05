//
//  ShopView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

private enum Constant {
    enum Text {
        static let itemSegment = "아이템"
        static let housingSegment = "부동산"
        
        static let enhanceSuccessTitle = "강화 성공"
        static let enhanceFailureTitle = "강화 실패"
        static let enhanceSuccessMessage = "강화에 성공했습니다!"
        static let enhanceFailureMessage = "강화에 실패했습니다.\n비용은 소모되었습니다."
        
        static let purchaseFailureTitle = "구매 실패"
        static let purchaseFailureMessage = "구매에 실패했습니다."
    }
    
    enum ID {
        static let housingScrollStart = "housingScrollStart"
    }

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
                segments: [Constant.Text.itemSegment, Constant.Text.housingSegment]
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
        ScrollViewReader { proxy in
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
                                    purchase(item: item, scrollProxy: proxy)
                                }
                            )
                            .id(item.id)
                        }
                    }
                }
                .padding(.horizontal, Constant.Padding.horizontal)
                .padding(.top, Constant.Padding.housingTop)
                .padding(.bottom, Constant.Padding.housingBottom)
                .id(Constant.ID.housingScrollStart)
            }
            .scrollIndicators(.never)
        }
    }

    /// 아이템 구매 확인 팝업 표시
    func purchase(item: DisplayItem, scrollProxy: ScrollViewProxy? = nil) {
        let (title, message, buttonTitle) = ShopPurchaseHelper.purchaseInfo(for: item)
        let fullMessage = ShopPurchaseHelper.createPurchaseMessage(item: item, baseMessage: message, shopSystem: shopSystem)

        ShopPurchaseHelper.showConfirm(
            popupContent: $popupContent,
            title: title,
            message: fullMessage,
            confirmTitle: buttonTitle
        ) {
            executePurchase(item: item, scrollProxy: scrollProxy)
        }
    }

    /// 실제 구매 실행
    func executePurchase(item: DisplayItem, scrollProxy: ScrollViewProxy? = nil) {
        do {
            let isSuccess = try shopSystem.buy(item: item)
            if isSuccess {
                // 성공 시 가로 스크롤을 맨 처음으로 이동
                if let proxy = scrollProxy, selectedCategoryIndex == 1 {
                    withAnimation {
                        proxy.scrollTo(Constant.ID.housingScrollStart, anchor: .leading)
                    }
                }
            }
            if item.category == .equipment {
                SoundService.shared.trigger(isSuccess ? .upgradeSuccess : .upgradeFailure)
                if !isSuccess {
                    HapticService.shared.trigger(.error)
                }
                let title = isSuccess ? Constant.Text.enhanceSuccessTitle : Constant.Text.enhanceFailureTitle
                let message = isSuccess ? Constant.Text.enhanceSuccessMessage : Constant.Text.enhanceFailureMessage
                ShopPurchaseHelper.showAlert(popupContent: $popupContent, title: title, message: message)
            }
        } catch let error as PurchasingError {
            HapticService.shared.trigger(.error)
            ShopPurchaseHelper.showAlert(popupContent: $popupContent, title: Constant.Text.purchaseFailureTitle, message: error.message)
        } catch {
            HapticService.shared.trigger(.error)
            ShopPurchaseHelper.showAlert(popupContent: $popupContent, title: Constant.Text.purchaseFailureTitle, message: Constant.Text.purchaseFailureMessage)
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
