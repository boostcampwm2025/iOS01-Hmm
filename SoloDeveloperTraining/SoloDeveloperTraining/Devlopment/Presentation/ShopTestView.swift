//
//  ShopTestView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import SwiftUI

struct ShopTestView: View {
    let user: User
    let shopSystem: ShopSystem

    init(user: User) {
        self.user = user
        self.shopSystem = .init(user: user)
    }
    var body: some View {
        VStack {
            Text("보유 골드: \(user.wallet.gold)")
            Text("보유 다이아: \(user.wallet.diamond)")
            Text("초당 획득 골드: \(Calculator.calculateGoldPerSecond(user: user))")
            Text("부동산: \(user.inventory.housing.displayTitle)")

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(shopSystem.itemList(itemTypes: [.consumable, .equipment, .housing])) { item in
                        ItemRow(
                            title: item.displayTitle + "\(item.isEquipped ? "-착용중" : "")",
                            description: item.description,
                            imageName: item.imageName,
                            cost: item.cost,
                            state: item.isPurchasable ? .available : .insufficient
                        ) {
                            do {
                                try shopSystem.buy(item: item)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    let user = User(
        nickname: "user",
        wallet: .init(gold: 1000000, diamond: 100),
        inventory: .init(),
        record: .init(),
        skills: [
            .init(key: .init(game: .tap, tier: .beginner), level: 1000),
            .init(
                key: .init(game: .tap, tier: .intermediate),
                level: 1000
            ),
            .init(key: .init(game: .tap, tier: .advanced), level: 1000)
        ]
    )
    ShopTestView(user: user)
}
