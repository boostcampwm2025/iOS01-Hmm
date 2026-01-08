//
//  TapGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

final class TapGame: Game {
    var kind: GameType = .tap
    var user: User
    var calculator: Calculator
    var feverSystem: FeverSystem
    var buffSystem: BuffSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem, buffSystem: BuffSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
    }

    func startGame() {
        feverSystem.start()
    }
    func stopGame() {
        feverSystem.stop()
    }

    @discardableResult
    func didPerformAction() async -> Int {
        feverSystem.gainFever(33)
        let gainGold = calculator.calculateGoldGained(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        user.wallet.addGold(gainGold)
        return gainGold
    }
}
