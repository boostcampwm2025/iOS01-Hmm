//
//  ContentView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    @State var user: User
    let autoGainSystem: AutoGainSystem

    init() {
        let user = User(
            nickname: "user",
            wallet: .init(gold: 1000000, diamond: 100),
            inventory: .init(
                equipmentItems: [
                    .init(type: .keyboard, tier: .broken),
                    .init(type: .mouse, tier: .broken),
                    .init(type: .monitor, tier: .broken),
                    .init(type: .chair, tier: .broken)
                ],
                consumableItems: [
                    .init(type: .coffee, count: 5),
                    .init(type: .energyDrink, count: 5)
                ],
                housing: .init(tier: .street)
            ),
            record: .init(),
            skills: [
                .init(key: .init(game: .tap, tier: .beginner), level: 1000),
                .init(
                    key: .init(game: .tap, tier: .intermediate),
                    level: 1000
                ),
                .init(
                    key: .init(game: .tap, tier: .advanced),
                    level: 1000
                ),
                .init(
                    key: .init(game: .dodge, tier: .advanced),
                    level: 500
                ),
                .init(
                    key: .init(game: .dodge, tier: .intermediate),
                    level: 500
                ),
                .init(
                    key: .init(game: .dodge, tier: .advanced),
                    level: 500
                ),
                .init(key: .init(game: .stack, tier: .beginner), level: 1)
            ]
        )
        self.user = user
        self.autoGainSystem = .init(user: user)
        autoGainSystem.startSystem()
    }

    var body: some View {
        TabView {
            TabGameView(user: user)
                .tag(1)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("탭 게임")
                }
            LanguageGameTestView(user: user)
                .tag(2)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("언어 맞추기")
                }
            ShopTestView(user: user)
                .tag(3)
                .tabItem {
                    Image(systemName: "cart")
                    Text("상점")
                }
            MissionTestView()
                .tag(4)
                .tabItem {
                    Image(systemName: "note")
                    Text("미션")
                }
            DodgeGameTestView(user: user)
                .tag(5)
                .tabItem {
                    Image(systemName: "exclamationmark.triangle")
                    Text("버그피하기")
                }
            StackGameTestView(user: user)
                .tag(6)
                .tabItem {
                    Image(systemName: "square.stack.3d.up")
                    Text("스택 게임")
                }
            SkillTestView(user: user)
                .tag(7)
                .tabItem {
                    Image(systemName: "plus")
                    Text("스킬 강화")
                }
        }
    }
}

#Preview {
    ContentView()
}
