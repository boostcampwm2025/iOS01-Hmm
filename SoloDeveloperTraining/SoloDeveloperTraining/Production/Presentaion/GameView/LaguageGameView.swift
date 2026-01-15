//
//  LaguageGameView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let vertical: CGFloat = 67
        static let itemHorizontal: CGFloat = 25
        static let buttonHorizontal: CGFloat = 17
    }
}

struct LaguageGameView: View {
    let user: User
    let game: LanguageGame
    let languageTypeList: [LanguageType] = [
        .swift,
        .kotlin,
        .dart,
        .python
    ]

    @Binding var isGameStarted: Bool
    @State private var coffeeCount: Int
    @State private var energyDrinkCount: Int
    @State private var effectValues: [(id: UUID, value: Int)] = []

    init(user: User, isGameStarted: Binding<Bool>) {
        self._isGameStarted = isGameStarted
        self.user = user
        coffeeCount = user.inventory.count(.coffee) ?? 0
        energyDrinkCount = user.inventory.count(.energyDrink) ?? 0

        self.game = .init(
            user: user,
            calculator: .init(),
            feverSystem: .init(
                decreaseInterval: 0.1,
                decreasePercentPerTick: 10
            ),
            buffSystem: .init(),
            itemCount: 5 // 임시로 설정
        )
        self.game.startGame()
    }

    var body: some View {
        GeometryReader { mainGeometry in
            VStack(alignment: .center, spacing: 0) {
                GameToolBar(
                    closeButtonDidTapHandler: {
                        game.stopGame()
                        isGameStarted = false
                    },
                    coffeeButtonDidTapHandler: {
                        useConsumableItem(.coffee)
                    },
                    energyDrinkButtonDidTapHandler: {
                        useConsumableItem(.energyDrink)
                    },
                    feverState: game.feverSystem,
                    coffeeCount: $coffeeCount,
                    energyDrinkCount: $energyDrinkCount,
                )

                Spacer()

                HStack(alignment: .bottom, spacing: Constant.Spacing.itemHorizontal) {
                    ForEach(Array(game.itemList.enumerated()), id: \.offset) { index, item in
                        LanguageItem(
                            languageType: item.languageType,
                            state: item.state
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .overlay(alignment: .top) {
                    ZStack {
                        ForEach(effectValues, id: \.id) { effect in
                            EffectLabel(value: effect.value)
                        }
                    }
                    .offset(y: -34)
                }

                Spacer()

                HStack(spacing: Constant.Spacing.buttonHorizontal) {
                    ForEach(languageTypeList, id: \.self) { type in
                        LanguageButton(languageType: type, action: {
                            Task {
                                let gainedGold = await game.didPerformAction(type)
                                showEffectLabel(gainedGold: gainedGold)
                            }
                        })
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

private extension LaguageGameView {
    func useConsumableItem(_ type: ConsumableType) {
        Task {
            let isSuccess = await user.inventory.drink(type)
            if isSuccess {
                self.game.buffSystem.useConsumableItem(type: type)
                self.updateConsumableItems()
            }
        }
    }

    func updateConsumableItems() {
        coffeeCount = user.inventory.count(.coffee) ?? 0
        energyDrinkCount = user.inventory.count(.energyDrink) ?? 0
    }

    func showEffectLabel(gainedGold: Int) {
        let effectId = UUID()
        effectValues.append((id: effectId, value: gainedGold))

        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            effectValues.removeAll { $0.id == effectId }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isGameStarted = true
        let user = User(
            nickname: "Test",
            wallet: .init(),
            inventory: .init(),
            record: .init(),
            skills: [
                .init(game: .language, tier: .beginner, level: 1000)
            ]
        )

        var body: some View {
            LaguageGameView(user: user, isGameStarted: $isGameStarted)
        }
    }

    return PreviewWrapper()
}
