//
//  EnhanceView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-20.
//

import SwiftUI

private enum Constant {
    static let horizontalPadding: CGFloat = 16
    static let itemCardSpacing: CGFloat = 12
    static let popupContentSpacing: CGFloat = 20
}

struct EnhanceView: View {
    let user: User

    @Binding var popupContent: (String, AnyView)?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Constant.itemCardSpacing) {
                ForEach(user.skills) { skill in
                    ItemRow(
                        title: skill.title,
                        description: skill.description,
                        imageName: skill.imageName,
                        cost: skill.upgradeCost,
                        isDisabled: false
                    ) {
                        showEnhancePopup(for: skill)
                    }
                }
            }
        }
        .padding(.bottom)
        .scrollIndicators(.hidden)
    }
}

private extension EnhanceView {
    func showEnhancePopup(for skill: Skill) {
        let cost = skill.upgradeCost
        var costText = ""

        if cost.gold > 0 && cost.diamond > 0 {
            costText = "[\(cost.gold.formatted())골드, \(cost.diamond.formatted())다이아]"
        } else if cost.gold > 0 {
            costText = "[\(cost.gold.formatted())골드]"
        } else if cost.diamond > 0 {
            costText = "[\(cost.diamond.formatted())다이아]"
        }

        let message = "\(costText)를 사용하여 구매하시겠습니까?"

        let contentView = VStack(spacing: Constant.popupContentSpacing) {
            Text(message)
                .textStyle(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            HStack {
                Spacer()
                MediumButton(title: "취소", isFilled: true, isCancelButton: true) {
                    popupContent = nil
                }

                MediumButton(title: "구매", isFilled: true) {
                    // TODO: 구매 로직 적용
                    popupContent = nil
                }
                Spacer()
            }
        }

        popupContent = ("강화", AnyView(contentView))
    }
}

#Preview {
    @Previewable @State var popupContent: (String, AnyView)?

    let user = User(
        nickname: "테스트",
        wallet: .init(gold: 1_000_000, diamond: 100),
        inventory: .init(),
        record: .init(),
        skills: [
            // 코드짜기
            .init(game: .tap, tier: .beginner, level: 1),
            .init(game: .tap, tier: .intermediate, level: 1),
            .init(game: .tap, tier: .advanced, level: 1),
            // 언어 맞추기
            .init(game: .language, tier: .beginner, level: 1),
            .init(game: .language, tier: .intermediate, level: 1),
            .init(game: .language, tier: .advanced, level: 1),
            // 버그 피하기
            .init(game: .dodge, tier: .beginner, level: 1),
            .init(game: .dodge, tier: .intermediate, level: 1),
            .init(game: .dodge, tier: .advanced, level: 1),
            // 물건 쌓기
            .init(game: .stack, tier: .beginner, level: 1),
            .init(game: .stack, tier: .intermediate, level: 1),
            .init(game: .stack, tier: .advanced, level: 1)
        ]
    )

    EnhanceView(user: user, popupContent: $popupContent)
        .overlay {
            if let popupContent {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    Popup(title: popupContent.0, contentView: popupContent.1)
                        .padding(.horizontal, 25)
                }
            }
        }
}
