//
//  StackGameView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/15/26.
//

import SwiftUI
import SpriteKit

struct StackGameView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var coffeeCount: Int
    @State private var energyDrinkCount: Int

    let stackGame: StackGame

    init(user: User) {
        self.stackGame = StackGame(user: user, calculator: .init())
        coffeeCount = user.inventory.count(.coffee) ?? 0
        energyDrinkCount = user.inventory.count(.energyDrink) ?? 0
    }

    var body: some View {
        VStack(spacing: 0) {
            GameToolBar(
                closeButtonDidTapHandler: stopGame,
                coffeeButtonDidTapHandler: { useConsumableItem(.coffee) },
                energyDrinkButtonDidTapHandler: { useConsumableItem(.energyDrink) },
                feverState: stackGame.feverSystem,
                coffeeCount: $coffeeCount,
                energyDrinkCount: $energyDrinkCount
            )
            .padding(.horizontal)
            SpriteView(scene: StackGameScene(stackGame: stackGame))
        }
        .onDisappear {
            stopGame()
        }
        .background(AppTheme.backgroundColor)
        .navigationBarBackButtonHidden(true) // 임시로 숨김
    }
}

private extension StackGameView {
    func stopGame() {
        stackGame.stopGame()
        dismiss()
    }

    func useConsumableItem(_ type: ConsumableType) {
        Task {
            let isSuccess = await stackGame.user.inventory.drink(type)
            if isSuccess {
                stackGame.buffSystem.useConsumableItem(type: type)
                updateConsumableItems()
            }
        }
    }

    func updateConsumableItems() {
        coffeeCount = stackGame.user.inventory.count(.coffee) ?? 0
        energyDrinkCount = stackGame.user.inventory.count(.energyDrink) ?? 0
    }
}
