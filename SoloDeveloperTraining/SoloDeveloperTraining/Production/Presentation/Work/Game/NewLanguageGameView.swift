//
//  NewLanguageGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/21/26.
//

import SwiftUI

import DUDesignSystem

struct NewLanguageGameView: View {

    /// 언어 맞추기 게임 모델
    @State private var game: LanguageGame
    /// 닫기 버튼으로 인한 일시정지
    @State private var closePause: Bool = false

    /// 게임 시작 여부 (false로 바꾸면 선택 화면으로 복귀)
    @Binding var isGameStarted: Bool
    /// 이번 세션에서 획득한 골드 누적량
    @Binding var gameActionGoldDelta: Int
    /// 탭 전환으로 인한 일시정지
    @Binding var tabSwitchPause: Bool

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        gameActionGoldDelta: Binding<Int>,
        tabSwitchPause: Binding<Bool>,
        animationSystem: CharacterAnimationSystem?
    ) {
        let game = LanguageGame(
            user: user,
            feverSystem: .init(
                decreaseInterval: 0.1,
                decreasePercentPerTick: 5
            ),
            buffSystem: .init(),
            itemCount: 5,
            animationSystem: animationSystem
        )
        game.startGame()
        _game = State(initialValue: game)
        _isGameStarted = isGameStarted
        _gameActionGoldDelta = gameActionGoldDelta
        _tabSwitchPause = tabSwitchPause
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
private extension NewLanguageGameView {

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
private extension NewLanguageGameView {
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
