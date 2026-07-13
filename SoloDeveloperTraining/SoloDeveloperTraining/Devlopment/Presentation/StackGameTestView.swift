//
//  StackGameTestView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-13.
//

import SpriteKit
import SwiftUI

import DUDesignSystem

struct StackGameTestView: View {
    @State private var game: StackGame
    private let scene: StackGameScene

    init(user: User) {
        let game = StackGame(user: user)
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
                    feverStage: game.feverSystem.feverStage,
                    feverProgress: {
                        let stageBase = Double(game.feverSystem.feverStage) * 100.0
                        return (game.feverSystem.feverPercent - stageBase) / 100.0
                    }(),
                    feverMultiplier: game.feverSystem.feverStage == 0 ? 0 : game.feverSystem.feverMultiplier,
                    coffeeCount: game.user.inventory.count(.coffee) ?? 0,
                    energyDrinkCount: game.user.inventory.count(.energyDrink) ?? 0,
                    coffeeCooldown: {
                        Double(game.buffSystem.coffeeDuration) / Double(ConsumableType.coffee.duration)
                    }(),
                    energyDrinkCooldown: {
                        Double(game.buffSystem.energyDrinkDuration) / Double(ConsumableType.energyDrink.duration)
                    }(),
                    onClose: stopGame,
                    onCoffee: useCoffee,
                    onEnergyDrink: useEnergyDrink
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
