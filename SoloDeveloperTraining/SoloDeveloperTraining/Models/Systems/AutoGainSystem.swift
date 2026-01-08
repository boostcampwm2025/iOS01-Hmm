//
//  AutoGainSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/8/26.
//

import Foundation

final class AutoGainSystem {
    let user: User
    let calculator: Calculator
    
    var timer: Timer?
    
    init(user: User, calculator: Calculator) {
        self.user = user
        self.calculator = calculator
    }
    
    func startSystem() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.gainGold()
        }
    }
    
    func gainGold() {
        let goldPerSecond = calculator.calculateGoldPerSecond(user: user)
        user.wallet.addGold(goldPerSecond)
    }
}
