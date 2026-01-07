//
//  TapGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

final class TapGame: Game {
    var kind: GameKind = .tap
    var user: User
    var calculator: Calculator
    var feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func startGame() {
        feverSystem.start()
    }
    func stopGame() {
        feverSystem.stop()
    }

    @discardableResult
    func didPerformAction() async -> Int {
        feverSystem.gainFever(3)
        let gainGold = calculator.calculateGoldGained(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: 1
        )
        user.wallet.addGold(gainGold)
        return gainGold
    }
}
