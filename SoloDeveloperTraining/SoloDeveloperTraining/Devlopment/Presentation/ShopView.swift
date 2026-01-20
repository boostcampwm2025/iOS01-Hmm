//
//  ShopView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import SwiftUI

struct ShopView: View {
    let user: User
    let shopSystem: ShopSystem
    let calculator: Calculator

    init(user: User, calculator: Calculator) {
        self.user = user
        self.shopSystem = .init(user: user)
        self.calculator = calculator
    }
    var body: some View {
        VStack {
            Text("보유 골드: \(user.wallet.gold)")
            Text("보유 다이아: \(user.wallet.diamond)")
            Text("초당 획득 골드: \(calculator.calculateGoldPerSecond(user: user))")
            Text("부동산: \(user.inventory.housing.displayTitle)")

            List(shopSystem.itemList() + shopSystem.housingList()) { item in
                itemRowView(item: item)
            }
        }
    }

    func itemRowView(item: Item) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                Text(item.description)
            }
            Spacer()
            Button {
                do {
                    try shopSystem.buy(item: item)
                } catch {

                }

            } label: {
                VStack(alignment: .trailing) {
                    Text("💰 \(item.cost.gold)")
                    Text("💎 \(item.cost.diamond)")
                }
                .border(.black)
            }
        }
    }
}

#Preview {
    let user = User(
        nickname: "user",
        wallet: .init(gold: 1000000000, diamond: 100),
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
    ShopView(user: user, calculator: .init())
}
