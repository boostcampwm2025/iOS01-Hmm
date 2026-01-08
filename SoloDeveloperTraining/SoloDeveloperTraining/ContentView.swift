//
//  ContentView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    let user: User
    let calculator: Calculator
    let autoGainSystem: AutoGainSystem
    
    init() {
        let user = User(
            nickname: "user",
            wallet: .init(gold: 1000000, diamond: 100),
            inventory: .init(),
            record: .init(),
            skills: [
                .init(game: .tap, tier: .beginner, level: 1000),
                .init(game: .tap, tier: .intermediate, level: 1000),
                .init(game: .tap, tier: .advanced, level: 1000),
            ]
        )
        let calculator: Calculator = Calculator()
        self.user = user
        self.calculator = calculator
        self.autoGainSystem = .init(user: user, calculator: calculator)
        autoGainSystem.startSystem()
    }
    
    var body: some View {
        TabView {
            TabGameView(user: user, calculator: .init()).tag(1)
            ShopView(user: user, calculator: .init()).tag(2)
        }
    }
}

#Preview {
    ContentView()
}
