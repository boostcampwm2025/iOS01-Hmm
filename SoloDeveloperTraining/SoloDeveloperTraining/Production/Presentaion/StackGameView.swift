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

    let stackGame: StackGame

    var body: some View {
        VStack(spacing: 0) {
            GameToolBar(
                closeButtonDidTapHandler: stopGame,
                coffeeButtonDidTapHandler: useCoffee,
                energyDrinkButtonDidTapHandler: useEnergyDrink,
                feverState: stackGame.feverSystem,
                coffeeCount: .constant(stackGame.user.inventory.count(.coffee) ?? 0),
                energyDrinkCount: .constant(stackGame.user.inventory.count(.energyDrink) ?? 0)
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

    func useCoffee() {
        if stackGame.user.inventory.drink(.coffee) {
            stackGame.buffSystem.useConsumableItem(type: .coffee)
        }
    }

    func useEnergyDrink() {
        if stackGame.user.inventory.drink(.energyDrink) {
            stackGame.buffSystem.useConsumableItem(type: .energyDrink)
        }
    }
}
