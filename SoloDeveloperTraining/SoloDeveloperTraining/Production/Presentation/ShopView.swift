//
//  ShopView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

private enum Constant {
    static let horizontalPadding: CGFloat = 16
    static let itemCardSpacing: CGFloat = 12

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

    private var categoryTitles: [String] {
        ["아이템", "부동산"]
    }

    private var displayItems: [DisplayItem] {
        if selectedCategoryIndex == 0 {
            // 아이템 탭: 소비품 + 장비
            return shopSystem.itemList(itemTypes: [.consumable, .equipment])
        } else {
            // 부동산 탭
            return shopSystem.itemList(itemTypes: [.housing])
        }
    }

    var body: some View {
        VStack {
            // 카테고리 세그먼트 컨트롤
            DefaultSegmentControl(
                selection: $selectedCategoryIndex,
                segments: categoryTitles
            )
            .padding(.horizontal, Constant.horizontalPadding)

            // 아이템/부동산 목록
            if selectedCategoryIndex == 0 {
                // 아이템 탭: ItemRow 사용
                ScrollView {
                    LazyVStack(spacing: Constant.itemCardSpacing) {
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
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: Constant.itemCardSpacing) {
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
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

extension ShopView {
    /// 아이템 상태 결정
    fileprivate func itemState(for item: DisplayItem) -> ItemState {
        if item.isEquipped && item.category == .housing {
            return .locked
        }
        return item.isPurchasable ? .available : .insufficient
    }

    /// 아이템 구매 확인 팝업 표시
    fileprivate func purchase(item: DisplayItem) {
        // 팝업 타이틀 및 메시지 생성
        let title: String
        let message: String
        let buttonTitle: String

        switch item.category {
        case .equipment:
            title = "장비 강화"
            // 강화 확률 계산
            if let equipment = item.item as? Equipment {
                let successRate = Int(equipment.tier.upgradeSuccessRate * 100)
                message = "강화하시겠습니까?\n(성공 확률: \(successRate)%)"
            } else {
                message = "강화하시겠습니까?"
            }
            buttonTitle = "강화"
        case .housing:
            title = "부동산 구매"
            message = "구매하시겠습니까?"
            buttonTitle = "구매"
        case .consumable:
            title = "아이템 구매"
            message = "구매하시겠습니까?"
            buttonTitle = "구매"
        }

        // 가격 텍스트 생성
        var priceComponents: [String] = []

        // 부동산의 경우 실제 지불/환불 금액 계산
        if item.category == .housing, let newHousing = item.item as? Housing {
            let currentHousing = user.inventory.housing
            let refundAmount = currentHousing.cost.gold / 2
            let netCost = item.cost.gold - refundAmount

            if netCost < 0 {
                // 다운그레이드: 환불
                priceComponents.append("\(abs(netCost).formatted) 골드")
            } else {
                // 업그레이드: 실제 지불 금액
                priceComponents.append("\(netCost.formatted) 골드")
            }
        } else {
            // 장비, 소비품
            if item.cost.gold > 0 {
                priceComponents.append("\(item.cost.gold.formatted) 골드")
            }
            if item.cost.diamond > 0 {
                priceComponents.append("\(item.cost.diamond.formatted) 다이아")
            }
        }

        let priceText = "[\(priceComponents.joined(separator: ", "))]"

        // 메시지 생성 (부동산 환불일 때 다른 표현 사용)
        let fullMessage: String
        if item.category == .housing,
            let newHousing = item.item as? Housing {
            let currentHousing = user.inventory.housing
            let refundAmount = currentHousing.cost.gold / 2
            let netCost = item.cost.gold - refundAmount

            if netCost < 0 {
                // 다운그레이드: 환불
                fullMessage = "\(priceText)를 환불받고\n\(message)"
            } else {
                // 업그레이드 또는 일반
                fullMessage = "\(priceText)를 사용하여\n\(message)"
            }
        } else {
            fullMessage = "\(priceText)를 사용하여\n\(message)"
        }

        // 구매 확인 팝업
        popupContent = (
            title,
            AnyView(
                VStack(spacing: 16) {
                    Text(fullMessage)
                        .textStyle(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 12) {
                        // 취소 버튼
                        MediumButton(title: "취소", isFilled: false) {
                            popupContent = nil
                        }

                        // 구매/강화 버튼
                        MediumButton(title: buttonTitle, isFilled: true) {
                            popupContent = nil
                            executePurchase(item: item)
                        }
                    }
                }
            )
        )
    }

    /// 실제 구매 실행
    fileprivate func executePurchase(item: DisplayItem) {
        do {
            let isSuccess = try shopSystem.buy(item: item)

            // 장비 강화의 경우 결과 팝업 표시
            if item.category == .equipment {
                showEnhanceResult(isSuccess: isSuccess)
            }
        } catch {
            // 구매 실패 시 에러 처리 (필요시 추가)
        }
    }

    /// 강화 결과 팝업 표시
    fileprivate func showEnhanceResult(isSuccess: Bool) {
        let title = isSuccess ? "강화 성공" : "강화 실패"
        let message = isSuccess ? "강화에 성공했습니다!" : "강화에 실패했습니다.\n비용은 소모되었습니다."

        popupContent = (
            title,
            AnyView(
                VStack {
                    Text(message)
                        .textStyle(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    MediumButton(title: "확인", isFilled: true) {
                        popupContent = nil
                    }
                }
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
