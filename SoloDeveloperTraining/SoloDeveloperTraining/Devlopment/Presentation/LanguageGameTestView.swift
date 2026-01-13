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

    @State private var coffeeCount: Int = 0
    @State private var energyDrinkCount: Int = 0

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
            buffSystem: .init()
        )
        self.game.startGame()
    }

    var body: some View {
        VStack {
            GameToolBar(
                closeButtonDidTapHandler: {},
                coffeeButtonDidTapHandler: {
                    coffeeCount -= 1
                },
                energyDrinkButtonDidTapHandler: {
                    energyDrinkCount -= 1
                },
                feverState: game.feverSystem,
                coffeeCount: $coffeeCount,
                energyDrinkCount: $energyDrinkCount,
            )
            Text("총 재화: \(user.wallet.gold)")
            Spacer()

            ScrollView(.horizontal) {
                HStack(spacing: Constant.Spacing.itemHorizontal) {
                    ForEach(game.languageItemList.indices, id: \.self) { index in
                        let item = game.languageItemList[index]
                        LanguageItem(
                            languageType: item.languageType,
                            state: item.state
                        )
                    }
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
