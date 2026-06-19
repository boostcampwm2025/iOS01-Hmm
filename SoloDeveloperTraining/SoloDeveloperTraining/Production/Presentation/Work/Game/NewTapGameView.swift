//
//  NewTapGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/14/26.
//

import SwiftUI

import DUDesignSystem

private enum Constant {
    /// 탭 사운드 최소 재생 간격 (초)
    static let tapSoundThrottleInterval: TimeInterval = 0.05
}

struct NewTapGameView: View {
    /// 코드짜기 게임 모델
    @State private var tapGame: TapGame
    /// 닫기 버튼으로 인한 일시정지
    @State private var closePause: Bool = false
    /// 터치 위치에 표시되는 골드 획득 효과
    @State private var effectLabels: [EffectLabelData] = []
    /// 탭 사운드 쓰로틀용 마지막 재생 시각
    @State private var lastTapSoundTime: Date = .distantPast

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
        let tapGame = TapGame(
            user: user,
            buffSystem: BuffSystem(),
            animationSystem: animationSystem
        )
        tapGame.startGame()
        _tapGame = State(initialValue: tapGame)
        _isGameStarted = isGameStarted
        _gameActionGoldDelta = gameActionGoldDelta
        _tabSwitchPause = tabSwitchPause
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                toolbarSection
                tapAreaSection(geometry: geometry)
            }
        }
    }
}

// MARK: - Sections
private extension NewTapGameView {

    var toolbarSection: some View {
        GameToolBar(
            feverStage: tapGame.feverSystem.feverStage,
            feverProgress: {
                let stageBase = Double(tapGame.feverSystem.feverStage) * 100.0
                return (tapGame.feverSystem.feverPercent - stageBase) / 100.0
            }(),
            feverMultiplier: tapGame.feverSystem.feverStage == 0 ? 0 : tapGame.feverSystem.feverMultiplier,
            coffeeCount: tapGame.inventory.count(.coffee) ?? 0,
            energyDrinkCount: tapGame.inventory.count(.energyDrink) ?? 0,
            coffeeCooldown: {
                Double(tapGame.buffSystem.coffeeDuration) / Double(ConsumableType.coffee.duration)
            }(),
            energyDrinkCooldown: {
                Double(tapGame.buffSystem.energyDrinkDuration) / Double(ConsumableType.energyDrink.duration)
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

    func tapAreaSection(geometry: GeometryProxy) -> some View {
        ZStack {
            // TODO: DUAssets에서 불러오기
            Image(.tapBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)

            ForEach(effectLabels) { data in
                EffectLabel(type: .plus, text: "\(data.value)") {
                    removeEffectLabel(id: data.id)
                }
                .position(data.position)
            }

            MultiTouchView { location in
                Task { await handleTap(at: location) }
            }
        }
        .gamePauseWrapper(
            pauseBinding: pauseBinding,
            onLeave: { },
            onPause: {
                tapGame.pauseGame()
                SoundService.shared.stopAllSFX()
                lastTapSoundTime = .distantPast
            },
            onResume: { tapGame.resumeGame() }
        )
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
private extension NewTapGameView {

    @MainActor
    func handleTap(at location: CGPoint) async {
        let now = Date()
        if !tapGame.isPaused,
           now.timeIntervalSince(lastTapSoundTime) >= Constant.tapSoundThrottleInterval {
            SoundService.shared.trigger(.tapGameTyping)
            lastTapSoundTime = now
        }
        let gainGold = await tapGame.didPerformAction()
        gameActionGoldDelta += gainGold
        showEffectLabel(at: location, value: gainGold)
    }

    func showEffectLabel(at location: CGPoint, value: Int) {
        let data = EffectLabelData(id: UUID(), position: location, value: value)
        effectLabels.append(data)
    }

    func removeEffectLabel(id: UUID) {
        effectLabels.removeAll { $0.id == id }
    }

    func handleCloseButton() {
        tapGame.stopGame()
        isGameStarted = false
    }

    func useConsumableItem(_ type: ConsumableType) {
        let count = tapGame.inventory.count(type) ?? 0
        if count > 0 {
            if tapGame.inventory.drink(type) {
                SoundService.shared.trigger(.itemConsume)
                HapticService.shared.trigger(.success)
                tapGame.buffSystem.useConsumableItem(type: type)
                tapGame.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
            }
        }
    }
}
