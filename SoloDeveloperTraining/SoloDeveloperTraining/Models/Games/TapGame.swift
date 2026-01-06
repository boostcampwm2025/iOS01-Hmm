//
//  TapGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

class TapGame {
    let user: User
    let calculator: Calculator
    let feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func startGame() {}
    func endGame() {}

    private func actionDidOccur() async {
        let goldGained = calculator.calculateGoldGained()
        await user.wallet.addGold(goldGained)
    }
}
