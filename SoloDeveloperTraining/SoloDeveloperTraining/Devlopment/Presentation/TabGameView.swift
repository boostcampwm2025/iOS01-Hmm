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
            feverSystem: .init(
                decreaseInterval: 0.1,
                decreasePercentPerTick: 10
            ),
            buffSystem: .init()
        )
        self.game.startGame()
    }

    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("gold: \(user.wallet.gold)")
                Text("fever: \(game.feverSystem.feverPercent)")
                Text("feverStage: \(game.feverSystem.feverStage)")
            }
            HStack(spacing: 30) {
                Button {
                    Task {
                        let gainGold = await game.didPerformAction(())
                        print(gainGold)
                    }
                } label: {
                    Text("탭 1번 수행하기")
                }
                Button {
                    Task {
                        await CheatManager.performCheatingActions(game: game, count: 10000)
                    }
                } label: {
                    Text("탭 10,000번 수행하기")
                }
            }
            Button {
                if user.inventory.drink(.coffee) {
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
            .init(key: .init(game: .tap, tier: .beginner), level: 1000),
            .init(key: .init(game: .tap, tier: .intermediate), level: 1000),
            .init(key: .init(game: .tap, tier: .advanced), level: 1000)
        ]
    )
    TabGameView(user: user)
}
