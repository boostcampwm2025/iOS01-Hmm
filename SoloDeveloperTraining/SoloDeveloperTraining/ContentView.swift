//
//  ContentView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    let user = User(
        nickname: "user",
        wallet: .init(diamond: 100),
        inventory: .init(),
        record: .init(),
        skills: [
            .init(game: .tap, tier: .beginner, level: 1000),
            .init(game: .tap, tier: .intermediate, level: 1000),
            .init(game: .tap, tier: .advanced, level: 1000),
        ]
    )
    
    var body: some View {
        TabView {
            TabGameView(user: user).tag(1)
            ShopView(user: user).tag(2)
        }
    }
}

#Preview {
    ContentView()
}
