//
//  ContentView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI

struct ContentView: View {
    let user: User
    let game: TapGame
    
    init() {
        let user = User(
            nickname: "test",
            wallet: .init(),
            inventory: .init(),
            record: .init()
        )
        self.user = user
        self.game = .init(
            user: user,
            calculator: .init(),
            feverSystem: .init(
                decreaseInterval: 0.1,
                decreasePercentPerTick: 1
            )
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
                    await game.didPerformAction()
                }
            } label: {
                Rectangle()
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
