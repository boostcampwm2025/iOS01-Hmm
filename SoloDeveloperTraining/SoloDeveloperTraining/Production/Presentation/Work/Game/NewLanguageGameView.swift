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
    /// 진행 중인 언어 버튼 탭 Task
    @State private var currentActionTask: Task<Void, Never>?
    /// 획득한 골드를 표시하는 효과 라벨 목록
    @State private var effectLabels: [EffectLabelData] = []

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
        VStack(spacing: 0) {
            languageItemsSection
            languageButtonsSection
        }
        .gamePauseWrapper(
            pauseBinding: pauseBinding,
            onLeave: { },
            onPause: { game.pauseGame() },
            onResume: { game.resumeGame() }
        )
    }

    var languageItemsSection: some View {
        HStack(spacing: TokenSpacing.lg) {
            ForEach(Array(game.itemList.enumerated()), id: \.offset) { _, item in
                if item.languageType == .empty {
                    Color.clear.frame(
                        width: TokenIconSize.size38.rawValue,
                        height: TokenIconSize.size38.rawValue
                    )
                } else {
                    LanguageItem(
                        language: mapLanguageType(item.languageType),
                        state: mapLanguageItemState(item.state)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            ZStack {
                ForEach(effectLabels) { data in
                    EffectLabel(type: data.value >= 0 ? .plus : .minus, text: "\(abs(data.value))") {
                        removeEffectLabel(id: data.id)
                    }
                }
            }
            .offset(y: -34)
        }
    }

    var languageButtonsSection: some View {
        HStack(spacing: TokenSpacing.lg) {
            LanguageItemButton(language: .swift) { handleLanguageButtonTap(.swift) }
            LanguageItemButton(language: .kotlin) { handleLanguageButtonTap(.kotlin) }
            LanguageItemButton(language: .dart) { handleLanguageButtonTap(.dart) }
            LanguageItemButton(language: .python) { handleLanguageButtonTap(.python) }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, TokenSpacing.md)
        .padding(.bottom, TokenGrid.paddingBottom)
        .frame(height: 130)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.pastelBlueGray)
                .frame(height: 1)
        }
    }

    var pauseBinding: Binding<Bool> {
        Binding(
            get: { tabSwitchPause || closePause },
            set: {
                tabSwitchPause = $0
                closePause = $0
            }
        )
    }
}

// MARK: - Helper
private extension NewLanguageGameView {

    func mapLanguageType(_ type: LanguageType) -> LanguageItem.LanguageType {
        switch type {
        case .swift:  return .swift
        case .kotlin: return .kotlin
        case .dart:   return .dart
        case .python: return .python
        case .empty:  return .swift // .empty는 뷰에서 Color.clear로 처리
        }
    }

    func mapLanguageItemState(_ state: LanguageItemState) -> LanguageItem.LanguageItemState {
        switch state {
        case .completed: return .completed
        case .active:    return .active
        case .upcoming:  return .upcoming
        case .empty:     return .upcoming // .empty는 뷰에서 Color.clear로 처리
        }
    }

    func mapToAppLanguageType(_ type: LanguageItem.LanguageType) -> LanguageType {
        switch type {
        case .swift:  return .swift
        case .kotlin: return .kotlin
        case .dart:   return .dart
        case .python: return .python
        }
    }

    func handleLanguageButtonTap(_ type: LanguageItem.LanguageType) {
        currentActionTask?.cancel()

        currentActionTask = Task {
            let gainedGold = await game.didPerformAction(mapToAppLanguageType(type))

            guard !Task.isCancelled else { return }

            SoundService.shared.trigger(gainedGold > 0 ? .languageCorrect : .languageWrong)
            if gainedGold <= 0 {
                HapticService.shared.trigger(.error)
            }
            gameActionGoldDelta += gainedGold
            showEffectLabel(value: gainedGold)
        }
    }

    func showEffectLabel(value: Int) {
        let data = EffectLabelData(id: UUID(), position: .zero, value: value)
        effectLabels.append(data)
    }

    func removeEffectLabel(id: UUID) {
        effectLabels.removeAll { $0.id == id }
    }

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
