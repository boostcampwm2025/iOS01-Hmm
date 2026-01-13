//
//  StackGameTestView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-13.
//

import SpriteKit
import SwiftUI

@Observable
final class StackGameTestViewModel {
    let game: StackGame

    var feverSystem: FeverSystem { game.feverSystem }
    var gold: Int { game.user.wallet.gold }
    var diamond: Int { game.user.wallet.diamond }

    var coffeeCount: Int {
        game.user.inventory.count(.coffee) ?? 0
    }

    var energyDrinkCount: Int {
        game.user.inventory.count(.energyDrink) ?? 0
    }

    init(game: StackGame) {
        self.game = game
    }

    func stopGame() {}

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

struct StackGameTestView: View {
    @State var viewModel: StackGameTestViewModel

    private let scene: StackGameScene

    init(user: User, calculator: Calculator) {
        let game = StackGame(user: user, calculator: calculator)
        let scene = StackGameScene(stackGame: game)

        self.scene = scene
        self._viewModel = State(wrappedValue: .init(game: game))
    }

    var body: some View {
        VStack {
            VStack {
                Text("골드: \(viewModel.gold)")
                Text("다이아몬드: \(viewModel.diamond)")
            }
            .frame(maxHeight: .infinity)

            ZStack(alignment: .top) {
                SpriteView(scene: scene)

                GameToolBar(
                    closeButtonDidTapHandler: viewModel.stopGame,
                    coffeeButtonDidTapHandler: viewModel.useCoffee,
                    energyDrinkButtonDidTapHandler: viewModel.useEnergyDrink,
                    feverState: viewModel.feverSystem,
                    coffeeCount: .constant(viewModel.coffeeCount),
                    energyDrinkCount: .constant(viewModel.energyDrinkCount)
                )
                .padding()
            }
            .frame(maxHeight: .infinity)
        }
    }
}
