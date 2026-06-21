//
//  NewDodgeGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI

import DUDesignSystem

struct NewDodgeGameView: View {

    /// 버그 피하기 게임 모델
    @State private var game: DodgeGame
    /// 닫기 버튼으로 인한 일시정지
    @State private var closePause: Bool = false

    init(
        user: User,
        animationSystem: CharacterAnimationSystem?
    ) {
        self.game = DodgeGame(
            user: user,
            gameAreaSize: .zero,
            onGoldChanged: { _ in },
            animationSystem: animationSystem
        )
    }

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                toolbarSection
                gameAreaSection
            }
        }
    }
}

// MARK: - Sections
private extension NewDodgeGameView {

    var toolbarSection: some View {
        GameToolBar(
            feverStage: game.feverSystem.feverStage,
            feverProgress: {
                let stageBase = Double(game.feverSystem.feverStage) * 100.0
                return (game.feverSystem.feverPercent - stageBase) / 100.0
            }(),
            feverMultiplier: game.feverSystem.feverStage == 0 ? 0 : game.feverSystem.feverMultiplier,
            coffeeCount: game.user.inventory.count(.coffee) ?? 0,
            energyDrinkCount: game.user.inventory.count(.energyDrink) ?? 0,
            coffeeCooldown: {
                Double(game.buffSystem.coffeeDuration) / Double(ConsumableType.coffee.duration)
            }(),
            energyDrinkCooldown: {
                Double(game.buffSystem.energyDrinkDuration) / Double(ConsumableType.energyDrink.duration)
            }(),
            onClose: {
                closePause = true
                SoundService.shared.stopAllSFX()
                SoundService.shared.trigger(.buttonTap)
            },
            onCoffee: { useConsumableItem(.coffee) },
            onEnergyDrink: { useConsumableItem(.energyDrink) }
        )
        .padding(.bottom, TokenSpacing.md)
    }

    var gameAreaSection: some View {
        EmptyView()
    }
}

// MARK: - Helper
private extension NewDodgeGameView {

    func useConsumableItem(_ type: ConsumableType) {
        let count = game.user.inventory.count(type) ?? 0
        if count > 0 {
            if game.user.inventory.drink(type) {
                SoundService.shared.trigger(.itemConsume)
                HapticService.shared.trigger(.success)
                game.buffSystem.useConsumableItem(type: type)
                game.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
            }
        }
    }
}
