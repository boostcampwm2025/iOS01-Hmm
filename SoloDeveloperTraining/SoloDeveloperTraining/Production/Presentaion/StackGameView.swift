//
//  StackGameView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/15/26.
//

import SwiftUI
import SpriteKit

private enum Constants {
    static let gameAreaTopSpacing: CGFloat = 14
}

struct StackGameView: View {
    @State private var game: StackGame
    private let scene: StackGameScene

    init(user: User, calculator: Calculator) {
        let game = StackGame(user: user, calculator: calculator)
        let scene = StackGameScene(stackGame: game)

        self.scene = scene
        self._game = State(wrappedValue: game)
        print("물건 쌓기 게임을 시작합니다.")
    }

    var body: some View {
        VStack(spacing: Constants.gameAreaTopSpacing) {
            GameToolBar(
                closeButtonDidTapHandler: stopGame,
                coffeeButtonDidTapHandler: useCoffee,
                energyDrinkButtonDidTapHandler: useEnergyDrink,
                feverState: game.feverSystem,
                coffeeCount: .constant(game.user.inventory.count(.coffee) ?? 0),
                energyDrinkCount: .constant(game.user.inventory.count(.energyDrink) ?? 0)
            )
            .padding(.horizontal)
            SpriteView(scene: scene).background(.beige200)
        }.background(.beige200)
        .navigationBarBackButtonHidden(true)
    }
}

private extension StackGameView {
    func stopGame() {
        print("게임을 종료합니다.")
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
