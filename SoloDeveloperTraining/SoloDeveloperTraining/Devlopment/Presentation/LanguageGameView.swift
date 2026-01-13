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
struct LanguageGameView: View {
    let user: User
    let game: LanguageGame

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
        VStack(spacing: Constant.Spacing.vertical) {
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

            HStack(spacing: Constant.Spacing.buttonHorizontal) {
                LanguageButton(languageType: .swift, action: {})
                LanguageButton(languageType: .kotlin, action: {})
                LanguageButton(languageType: .dart, action: {})
                LanguageButton(languageType: .python, action: {})
            }
        }.padding()
    }
}
