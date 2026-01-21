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
                                        purchase(item: item)
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                }
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

    /// 아이템 구매 처리
    fileprivate func purchase(item: DisplayItem) {
        do {
            try shopSystem.buy(item: item)

            // 구매 성공 팝업
            let successMessage = purchaseSuccessMessage(for: item)
            popupContent = (
                "구매 완료",
                AnyView(
                    VStack {
                        Text(successMessage)
                            .textStyle(.body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        MediumButton(title: "확인", isFilled: true) {
                            popupContent = nil
                        }
                    }
                )
            )
        } catch let error as UserReadableError {
            // 구매 실패 팝업
            popupContent = (
                "구매 실패",
                AnyView(
                    VStack {
                        Text(error.message)
                            .textStyle(.body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        MediumButton(title: "확인", isFilled: true) {
                            popupContent = nil
                        }
                    }
                )
            )
        } catch {
            // 예상치 못한 에러
            popupContent = (
                "구매 실패",
                AnyView(
                    VStack {
                        Text(error.localizedDescription)
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

    /// 구매 성공 메시지 생성
    fileprivate func purchaseSuccessMessage(for item: DisplayItem) -> String {
        switch item.category {
        case .consumable:
            return "\(item.displayTitle)을(를) 구매했습니다!"
        case .equipment:
            if let equipment = item.item as? Equipment, equipment.canUpgrade {
                return "강화에 성공했습니다!"
            } else {
                return "이미 최대 등급입니다."
            }
        case .housing:
            return "\(item.displayTitle)을(를) 구매했습니다!"
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
