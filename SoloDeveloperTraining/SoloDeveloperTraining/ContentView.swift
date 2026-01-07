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
        wallet: .init(),
        inventory: .init(),
        record: .init()
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
