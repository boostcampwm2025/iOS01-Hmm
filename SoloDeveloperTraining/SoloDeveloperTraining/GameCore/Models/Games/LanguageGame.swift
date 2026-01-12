//
//  LanguageGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

class LanguageGame {
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

    func actionDidOccur() {}
}
