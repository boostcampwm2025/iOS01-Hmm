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
    
    init(user: User) {
        self.user = user
        self.game = .init(
            user: user,
            calculator: .init(),
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
                if user.inventory.drinkCoffee() {
                    game.buffSystem.useCoffee()
                }
            } label: {
                Text("☕️ Coffee \(user.inventory.coffeeCount)")
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
        record: .init()
    )
    TabGameView(user: user)
}
