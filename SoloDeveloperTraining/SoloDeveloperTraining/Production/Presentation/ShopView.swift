//
//  ShopView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI
import DUDesignSystem

private enum Constant {
    enum UserDefaultsKey {
        static let equipmentAdBonus = "equipmentAdBonusTypes"
    }

    enum Text {
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
}

struct ShopView: View {
    private let user: User
    private let shopSystem: ShopSystem

    @State private var selectedCategoryIndex: Int = 0
    @State private var selectedHousingTier: HousingTier?
    @State private var showAdBonusToast: Bool = false
    @State private var adBonusAppliedTypes: Set<String> = {
        let saved = UserDefaults.standard.stringArray(forKey: Constant.UserDefaultsKey.equipmentAdBonus) ?? []
        return Set(saved)
    }()
    @State private var enhanceAdRewardFlowID: String?

    @Binding var storePopup: StorePopup?
    @Binding var noticePopup: NoticePopup?

    init(user: User, storePopup: Binding<StorePopup?>, noticePopup: Binding<NoticePopup?>) {
        self.user = user
        self.shopSystem = ShopSystem(user: user)
        self._storePopup = storePopup
        self._noticePopup = noticePopup
    }

    var body: some View {
        VStack(spacing: TokenSpacing.md) {
            SegmentControl(leading: "아이템", trailing: "부동산", selectedIndex: $selectedCategoryIndex)
                .padding(.horizontal, TokenGrid.paddingSide)

            if selectedCategoryIndex == 0 {
                itemView
            } else {
                housingView
            }
        }
        .darkToast(isShowing: $showAdBonusToast, message: "강화 확률이 높아졌습니다!")
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
            LazyVStack(spacing: TokenSpacing.md) {
                ForEach(displayItems) { item in
                    ItemRow(
                        imageName: item.imageName,
                        title: item.displayTitle,
                        description: item.description,
                        buttonType: item.cost.itemButtonType,
                        buttonState: ItemState(item: item).itemButtonState
                    ) {
                        purchase(item: item)
                    }
                }
            }
            .padding(.horizontal, TokenGrid.paddingSide)
            .padding(.bottom, TokenGrid.paddingBottom)
        }
        .scrollIndicators(.never)
    }

    var housingView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: TokenSpacing.mm) {
                    ForEach(displayItems) { item in
                        if let housing = item.item as? Housing {
                            HousingCard(
                                title: housing.displayTitle,
                                price: ShopPurchaseHelper.createPriceText(for: item, shopSystem: shopSystem),
                                rewardPerSecond: "\(housing.goldPerSecond.formatted) 골드",
                                imageName: housing.imageName,
                                state: ItemState(item: item).housingCardState(isSelected: selectedHousingTier == housing.tier),
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
                .padding(.horizontal, TokenGrid.paddingSide)
                .id(Constant.ID.housingScrollStart)
            }
            .scrollClipDisabled()
            .padding(.bottom, TokenGrid.paddingBottom)
            .scrollIndicators(.never)
        }
    }

    /// 아이템 구매 확인 팝업 표시
    func purchase(item: DisplayItem, scrollProxy: ScrollViewProxy? = nil) {
        if item.category == .equipment, let equipment = item.item as? Equipment {
            showEquipmentEnhancePopup(item: item, equipment: equipment, scrollProxy: scrollProxy)
        } else {
            let (title, _, buttonTitle) = ShopPurchaseHelper.purchaseInfo(for: item)
            let priceText = ShopPurchaseHelper.createPriceText(for: item, shopSystem: shopSystem)
            storePopup = StorePopup(
                type: .default(
                    cancelText: "취소",
                    confirmText: buttonTitle,
                    cancelAction: { storePopup = nil },
                    confirmAction: {
                        storePopup = nil
                        executePurchase(item: item, scrollProxy: scrollProxy)
                    }
                ),
                title: title,
                itemName: item.displayTitle,
                price: priceText
            )
        }
    }

    /// 장비 강화 팝업 표시
    func showEquipmentEnhancePopup(item: DisplayItem, equipment: Equipment, scrollProxy: ScrollViewProxy?) {
        let typeKey = String(describing: equipment.type)
        let hasBonus = adBonusAppliedTypes.contains(typeKey)
        let baseRate = Int(equipment.tier.upgradeSuccessRate * 100)
        let displayRate = hasBonus ? min(baseRate + 10, 100) : baseRate
        let priceText = ShopPurchaseHelper.createPriceText(for: item, shopSystem: shopSystem)

        trackEnhanceAdOfferIfNeeded(hasBonus: hasBonus)

        storePopup = StorePopup(
            type: .ad(
                successRate: displayRate,
                adState: hasBonus ? .disabled : .default,
                cancelText: "취소",
                adText: "확률 UP",
                confirmText: "강화",
                cancelAction: {
                    storePopup = nil
                    trackEnhanceAdDismissIfNeeded(hasBonus: hasBonus)
                },
                adAction: {
                    storePopup = nil
                    Task {
                        await handleEnhanceAdWatch(item: item, equipment: equipment, scrollProxy: scrollProxy, typeKey: typeKey)
                    }
                },
                confirmAction: {
                    storePopup = nil
                    executePurchase(item: item, bonusRate: hasBonus ? 0.1 : 0.0, scrollProxy: scrollProxy)
                }
            ),
            title: "장비 강화",
            itemName: item.displayTitle,
            price: priceText,
            rateHighlighted: hasBonus
        )
    }

    func trackEnhanceAdOfferIfNeeded(hasBonus: Bool) {
        guard !hasBonus, enhanceAdRewardFlowID == nil else { return }

        let flowID = AnalyticsService.shared.makeAdRewardFlowID()
        enhanceAdRewardFlowID = flowID
        AnalyticsService.shared.logAdOfferViewed(
            adRewardFlowID: flowID,
            adPlacement: .equipmentEnhance,
            rewardType: .enhanceRateBoost,
            rewardAmount: 0
        )
    }

    func trackEnhanceAdDismissIfNeeded(hasBonus: Bool) {
        guard !hasBonus, let flowID = enhanceAdRewardFlowID else { return }

        AnalyticsService.shared.logAdOfferDismissed(
            adRewardFlowID: flowID,
            adPlacement: .equipmentEnhance,
            rewardType: .enhanceRateBoost,
            rewardAmount: 0,
            dismissReason: .close
        )
        enhanceAdRewardFlowID = nil
    }

    func handleEnhanceAdWatch(item: DisplayItem, equipment: Equipment, scrollProxy: ScrollViewProxy?, typeKey: String) async {
        guard let flowID = enhanceAdRewardFlowID else { return }

        AnalyticsService.shared.logAdWatchClicked(
            adRewardFlowID: flowID,
            adPlacement: .equipmentEnhance,
            rewardType: .enhanceRateBoost,
            rewardAmount: 0
        )

        let result = await AdService.shared.showAdWithResult(.interstitial)
        enhanceAdRewardFlowID = nil
        guard result.success else { return }

        AnalyticsService.shared.logAdWatchCompleted(
            adRewardFlowID: flowID,
            adPlacement: .equipmentEnhance,
            rewardType: .enhanceRateBoost,
            rewardAmount: 0,
            adWatchDurationSec: result.watchDurationSec
        )
        adBonusAppliedTypes.insert(typeKey)
        UserDefaults.standard.set(Array(adBonusAppliedTypes), forKey: Constant.UserDefaultsKey.equipmentAdBonus)
        showAdBonusToast = true
        AnalyticsService.shared.logAdRewardClaimed(
            adRewardFlowID: flowID,
            adPlacement: .equipmentEnhance,
            rewardType: .enhanceRateBoost,
            rewardAmount: 0
        )
        showEquipmentEnhancePopup(item: item, equipment: equipment, scrollProxy: scrollProxy)
    }

    /// 실제 구매 실행
    func executePurchase(item: DisplayItem, bonusRate: Double = 0.0, scrollProxy: ScrollViewProxy? = nil) {
        do {
            let isSuccess = try shopSystem.buy(item: item, bonusRate: bonusRate)

            if item.category == .equipment {
                // 강화 시도 후 보너스 상태 초기화
                if let equipment = item.item as? Equipment {
                    let typeKey = String(describing: equipment.type)
                    adBonusAppliedTypes.remove(typeKey)
                    UserDefaults.standard.set(Array(adBonusAppliedTypes), forKey: Constant.UserDefaultsKey.equipmentAdBonus)
                }
            }

            if isSuccess {
                // 성공 시 가로 스크롤을 맨 처음으로 이동
                if let proxy = scrollProxy, selectedCategoryIndex == 1 {
                    withAnimation {
                        proxy.scrollTo(Constant.ID.housingScrollStart, anchor: .leading)
                    }
                }
            }
            if item.category == .equipment {
                SoundService.shared.trigger(isSuccess ? .success : .failure)
                if !isSuccess {
                    HapticService.shared.trigger(.error)
                }
                let title = isSuccess ? Constant.Text.enhanceSuccessTitle : Constant.Text.enhanceFailureTitle
                let message = isSuccess ? Constant.Text.enhanceSuccessMessage : Constant.Text.enhanceFailureMessage
                noticePopup = NoticePopup(
                    type: .default(buttonText: "확인", action: { noticePopup = nil }),
                    title: title,
                    text: message
                )
            }
        } catch let error as PurchasingError {
            HapticService.shared.trigger(.error)
            noticePopup = NoticePopup(
                type: .default(buttonText: "확인", action: { noticePopup = nil }),
                title: Constant.Text.purchaseFailureTitle,
                text: error.message
            )
        } catch {
            HapticService.shared.trigger(.error)
            noticePopup = NoticePopup(
                type: .default(buttonText: "확인", action: { noticePopup = nil }),
                title: Constant.Text.purchaseFailureTitle,
                text: Constant.Text.purchaseFailureMessage
            )
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
    ShopView(user: user, storePopup: .constant(nil), noticePopup: .constant(nil))
}
