//
//  ShopView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import SwiftUI

struct ShopView: View {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    var body: some View {
        VStack {
            Text("초당 획득 골드")
        }
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
    ShopView(user: user)
}
