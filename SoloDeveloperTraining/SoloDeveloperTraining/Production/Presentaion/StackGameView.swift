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
    @State private var game: StackGame
    private let scene: StackGameScene

    init(user: User, calculator: Calculator) {
        let game = StackGame(user: user, calculator: calculator)
        let scene = StackGameScene(stackGame: game)

        self.scene = scene
        self._game = State(wrappedValue: game)
    }

    var body: some View {
        VStack(spacing: 0) {
            GameToolBar(
                closeButtonDidTapHandler: stopGame,
                coffeeButtonDidTapHandler: useCoffee,
                energyDrinkButtonDidTapHandler: useEnergyDrink,
                feverState: game.feverSystem,
                coffeeCount: .constant(game.user.inventory.count(.coffee) ?? 0),
                energyDrinkCount: .constant(game.user.inventory.count(.energyDrink) ?? 0)
            )
            .padding(.horizontal)
            SpriteView(scene: scene)
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
        game.stopGame()
        dismiss()
    }

    func useCoffee() {
        if game.user.inventory.drink(.coffee) {
            game.buffSystem.useConsumableItem(type: .coffee)
        }
    }

    func useEnergyDrink() {
        if game.user.inventory.drink(.energyDrink) {
            game.buffSystem.useConsumableItem(type: .energyDrink)
        }
    }
}
