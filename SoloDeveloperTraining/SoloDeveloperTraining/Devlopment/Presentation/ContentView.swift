//
//  ContentView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    @State var user: User
    let calculator: Calculator
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
                housing: .street
            ),
            record: .init(),
            skills: [
                .init(game: .tap, tier: .beginner, level: 1000),
                .init(game: .tap, tier: .intermediate, level: 1000),
                .init(game: .tap, tier: .advanced, level: 1000),
                .init(game: .dodge, tier: .beginner, level: 500),
                .init(game: .dodge, tier: .intermediate, level: 500),
                .init(game: .dodge, tier: .advanced, level: 500),
                .init(game: .stack, tier: .beginner, level: 1)
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
            TabGameView(user: user, calculator: calculator)
                .tag(1)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("탭 게임")
                }
            LanguageGameTestView(user: user, calculator: calculator)
                .tag(2)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("언어 맞추기")
                }
            ShopView(user: user, calculator: calculator)
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
            DodgeGameTestView(user: user, calculator: calculator)
                .tag(4)
                .tabItem {
                    Image(systemName: "exclamationmark.triangle")
                    Text("버그피하기")
                }
            StackGameTestView(user: user, calculator: calculator)
                .tag(5)
                .tabItem {
                    Image(systemName: "square.stack.3d.up")
                    Text("스택 게임")
                }
        }
    }
}

#Preview {
    ContentView()
}
