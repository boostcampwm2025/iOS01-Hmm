//
//  LanguageGameView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/13/26.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let vertical: CGFloat = 67
        static let itemHorizontal: CGFloat = 25
        static let buttonHorizontal: CGFloat = 17
    }
}

struct LanguageGameTestView: View {
    let user: User
    let game: LanguageGame
    let languageTypeList: [LanguageType] = [
        .swift,
        .kotlin,
        .dart,
        .python
    ]

    @State private var coffeeCount: Int
    @State private var energyDrinkCount: Int

    init(user: User, calculator: Calculator) {
        self.user = user
        coffeeCount = user.inventory.count(.coffee) ?? 0
        energyDrinkCount = user.inventory.count(.energyDrink) ?? 0

        self.game = .init(
            user: user,
            calculator: calculator,
            feverSystem: .init(
                decreaseInterval: 0.1,
                decreasePercentPerTick: 10
            ),
            buffSystem: .init(),
            itemCount: 5 // 임시로 설정
        )
        self.game.startGame()
    }

    var body: some View {
        VStack(alignment: .center) {
            GameToolBar(
                closeButtonDidTapHandler: {},
                coffeeButtonDidTapHandler: {
                    useConsumableItem(.coffee)
                },
                energyDrinkButtonDidTapHandler: {
                    useConsumableItem(.energyDrink)
                },
                feverState: game.feverSystem,
                coffeeCount: $coffeeCount,
                energyDrinkCount: $energyDrinkCount,
            )

            Text("총 재화: \(user.wallet.gold)")
            Spacer()

            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: Constant.Spacing.itemHorizontal) {
                    Spacer(minLength: 0)
                    ForEach(game.itemList.indices, id: \.self) { index in
                        let item = game.itemList[index]
                        LanguageItem(
                            languageType: item.languageType,
                            state: item.state
                        )
                    }
                    Spacer(minLength: 0)
                }
            }.scrollIndicators(.never)

            Spacer()

            HStack(spacing: Constant.Spacing.buttonHorizontal) {
                ForEach(languageTypeList, id: \.self) { type in
                    LanguageButton(languageType: type, action: {
                        Task {
                            let resultGold = await game.didPerformAction(type)
                            print("재화 변화량: \(resultGold)")
                        }
                    })
                }
            }
        }.padding()
    }
}

private extension LanguageGameTestView {
    func useConsumableItem(_ type: ConsumableType) {
        Task {
            let isSuccess = await user.inventory.drink(.coffee)
            if isSuccess {
                self.updateConsumableItems()
            }
        }
    }

    func updateConsumableItems() {
        coffeeCount = user.inventory.count(.coffee) ?? 0
        energyDrinkCount = user.inventory.count(.energyDrink) ?? 0
    }
}
