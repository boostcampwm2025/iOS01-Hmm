//
//  StackGameTestView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-13.
//

import SpriteKit
import SwiftUI

struct StackGameTestView: View {
    @State private var game: StackGame
    private let scene: StackGameScene

    init(user: User, calculator: Calculator) {
        let game = StackGame(user: user, calculator: calculator)
        let scene = StackGameScene(stackGame: game)

        self.scene = scene
        self._game = State(wrappedValue: game)
    }

    var body: some View {
        VStack {
            VStack {
                Text("골드: \(game.user.wallet.gold)")
                Text("다이아몬드: \(game.user.wallet.diamond)")
            }
            .frame(maxHeight: .infinity)

            ZStack(alignment: .top) {
                SpriteView(scene: scene)

                GameToolBar(
                    closeButtonDidTapHandler: stopGame,
                    coffeeButtonDidTapHandler: useCoffee,
                    energyDrinkButtonDidTapHandler: useEnergyDrink,
                    feverState: game.feverSystem,
                    coffeeCount: .constant(game.user.inventory.count(.coffee) ?? 0),
                    energyDrinkCount: .constant(game.user.inventory.count(.energyDrink) ?? 0)
                )
                .padding()
            }
            .frame(maxHeight: .infinity)
        }
    }

    private func stopGame() {}

    private func useCoffee() {
        if game.user.inventory.drink(.coffee) {
            game.buffSystem.useConsumableItem(type: .coffee)
        }
    }

    private func useEnergyDrink() {
        if game.user.inventory.drink(.energyDrink) {
            game.buffSystem.useConsumableItem(type: .energyDrink)
        }
    }
}
