//
//  TabGameView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI

struct TabGameView: View {
    let user: User
    let game: TapGame
    
    init(user: User, calculator: Calculator) {
        self.user = user
        self.game = .init(
            user: user,
            calculator: calculator,
            feverSystem: .init(
                decreaseInterval: 0.1,
                decreasePercentPerTick: 10
            ),
            buffSystem: .init()
        )
        self.game.startGame()
    }
    
    var body: some View {
        VStack {
            Text("gold: \(user.wallet.gold)")
            Text("fever: \(game.feverSystem.feverPercent)")
            Text("feverStage: \(game.feverSystem.feverStage)")
            Button {
                Task {
                    let gainGold = await game.didPerformAction()
                    print(gainGold)
                }
            } label: {
                Rectangle()
            }
            
            Button {
                if user.inventory.drink(.coffee)  {
                    game.buffSystem.useConsumableItem(type: .coffee)
                }
            } label: {
                Text("☕️ Coffee \(user.inventory.count(.coffee) ?? 0)")
            }
        }
        .padding()
    }
}

#Preview {
    let user = User(
        nickname: "user",
        wallet: .init(),
        inventory: .init(),
        record: .init(),
        skills: [
            .init(game: .tap, tier: .beginner, level: 1000),
            .init(game: .tap, tier: .intermediate, level: 1000),
            .init(game: .tap, tier: .advanced, level: 1000),
        ]
    )
    TabGameView(user: user, calculator: .init())
}
