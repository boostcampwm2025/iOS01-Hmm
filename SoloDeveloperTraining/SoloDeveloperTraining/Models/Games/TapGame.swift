//
//  TapGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

class TapGame: Game {
    var kind: GameKind
    var user: User
    var calculator: Calculator
    var feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func start() {}
    func end() {}

    func didPerformAction() async {
        let goldGained = calculator.calculateGoldGained()
//        await user.wallet.addGold(goldGained)
    }
}
