//
//  DodgeGameView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-15.
//

import SwiftUI

import DUDesignSystem

private enum Constant {
    enum Size {
        static let ground: CGFloat = 110
    }

    enum Position {
        /// 이펙트가 캐릭터 위로 올라가는 오프셋
        static let effectOffset: CGFloat = 30
    }

    enum Threshold {
        /// 캐릭터 방향 전환을 위한 최소 이동 거리
        static let directionChange: CGFloat = 0.1
    }
}

struct DodgeGameView: View {

    /// 버그 피하기 게임 모델
    @State private var game: DodgeGame
    /// 닫기 버튼으로 인한 일시정지
    @State private var closePause: Bool = false
    /// 게임 영역 가로 너비
    @State private var gameAreaWidth: CGFloat = 0
    /// 게임 영역 세로 높이
    @State private var gameAreaHeight: CGFloat = 0
    /// 캐릭터가 왼쪽을 보고 있는지 여부
    @State private var isFacingLeft: Bool = false
    /// 게임 일시정지 상태 (애니메이션 정지용)
    @State private var isGamePaused: Bool = false
    /// 게임 초기 설정 완료 여부
    @State private var isGameInitialized: Bool = false
    /// 골드 변화를 표시하는 효과 라벨 목록
    @State private var effectLabels: [EffectLabelData] = []

    /// 게임 시작 여부 (false로 바꾸면 선택 화면으로 복귀)
    @Binding var isGameStarted: Bool
    /// 이번 세션에서 획득한 골드 누적량
    @Binding var gameActionGoldDelta: Int
    /// 탭 전환으로 인한 일시정지
    @Binding var tabSwitchPause: Bool
    /// 광고 시청 후 음료 지급 팝업 표시 여부
    @Binding var showDrinkAdPopup: Bool
    /// 나가기 보너스 팝업 표시 여부
    @Binding var showExitBonusPopup: Bool
    /// 광고 팝업에서 선택된 음료 타입
    @Binding var selectedDrinkType: ConsumableType?
    /// 팝업에서 게임 재개 시 호출되는 콜백
    @Binding var resumeGameCallback: (() -> Void)?
    /// 팝업에서 게임 종료 시 호출되는 콜백
    @Binding var exitGameCallback: (() -> Void)?

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        gameActionGoldDelta: Binding<Int>,
        tabSwitchPause: Binding<Bool>,
        animationSystem: CharacterAnimationSystem?,
        showDrinkAdPopup: Binding<Bool>,
        showExitBonusPopup: Binding<Bool>,
        selectedDrinkType: Binding<ConsumableType?>,
        resumeGameCallback: Binding<(() -> Void)?>,
        exitGameCallback: Binding<(() -> Void)?>
    ) {
        self.game = DodgeGame(
            user: user,
            gameAreaSize: .zero,
            onGoldChanged: { _ in },
            animationSystem: animationSystem
        )
        _isGameStarted = isGameStarted
        _gameActionGoldDelta = gameActionGoldDelta
        _tabSwitchPause = tabSwitchPause
        _showDrinkAdPopup = showDrinkAdPopup
        _showExitBonusPopup = showExitBonusPopup
        _selectedDrinkType = selectedDrinkType
        _resumeGameCallback = resumeGameCallback
        _exitGameCallback = exitGameCallback
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbarSection
            gameAreaSection
        }
    }
}

// MARK: - Sections
private extension DodgeGameView {

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
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                groundSection
                playerSection
                fallingItemsSection
                effectLabelsSection
            }
            .onAppear {
                guard !isGameInitialized else { return }
                setupGame(with: geometry.size)
                isGameInitialized = true

                resumeGameCallback = { [weak game] in
                    game?.resumeGame()
                    isGamePaused = false
                }
                exitGameCallback = { handleCloseButton() }
            }
            .gamePauseWrapper(
                pauseBinding: pauseBinding,
                onLeave: { showExitBonusPopup = true },
                onPause: {
                    isGamePaused = true
                    game.pauseGame()
                },
                onResume: {
                    isGamePaused = false
                    game.resumeGame()
                }
            )
        }
    }

    var groundSection: some View {
        Color.clear
            .frame(height: Constant.Size.ground)
            .overlay(
                Image.duImage("dodge_ground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .clipped()
    }

    var playerSection: some View {
        RunningCharacter(isFacingLeft: isFacingLeft, isGamePaused: isGamePaused)
            .position(
                x: gameAreaWidth / 2 + (isGamePaused ? 0 : game.motionSystem.characterX),
                y: gameAreaHeight - TokenGrid.marginBugCharacter - RunningCharacter.size / 2
            )
            .onChange(of: game.motionSystem.characterX) { oldPositionX, newPositionX in
                updateCharacterDirection(oldPositionX: oldPositionX, newPositionX: newPositionX)
            }
    }

    var fallingItemsSection: some View {
        ForEach(game.gameCore.fallingItems) { item in
            DropItem(type: mapDropItemType(item.type))
                .position(
                    x: gameAreaWidth / 2 + item.position.x,
                    y: gameAreaHeight / 2 + item.position.y
                )
        }
    }

    var effectLabelsSection: some View {
        ZStack {
            ForEach(effectLabels) { effect in
                EffectLabel(type: effect.value >= 0 ? .plus : .minus, text: "\(abs(effect.value))") {
                    removeEffectLabel(id: effect.id)
                }
                .position(effect.position)
            }
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
private extension DodgeGameView {

    func setupGame(with size: CGSize) {
        gameAreaWidth = size.width
        gameAreaHeight = size.height

        game.setGoldChangedHandler(showGoldChangeEffect)
        game.configure(gameAreaSize: CGSize(width: size.width, height: size.height))
        game.startGame()
    }

    func showGoldChangeEffect(_ goldDelta: Int) {
        gameActionGoldDelta += goldDelta

        let effect = EffectLabelData(
            id: UUID(),
            position: CGPoint(
                x: gameAreaWidth / 2 + game.motionSystem.characterX,
                y: gameAreaHeight - TokenGrid.marginBugCharacter - RunningCharacter.size / 2 - Constant.Position.effectOffset
            ),
            value: goldDelta
        )
        effectLabels.append(effect)
    }

    func removeEffectLabel(id: UUID) {
        effectLabels.removeAll { $0.id == id }
    }

    func updateCharacterDirection(oldPositionX: CGFloat, newPositionX: CGFloat) {
        guard !isGamePaused else { return }
        if abs(newPositionX - oldPositionX) > Constant.Threshold.directionChange {
            isFacingLeft = newPositionX < oldPositionX
        }
    }

    func mapDropItemType(_ type: FallingItemType) -> DropItem.DropItemType {
        switch type {
        case .smallGold: return .smallGold
        case .largeGold: return .largeGold
        case .bug:       return .bug
        }
    }

    func handleCloseButton() {
        game.stopGame()
        isGameStarted = false
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
        } else {
            selectedDrinkType = type
            showDrinkAdPopup = true
            game.pauseGame()
            isGamePaused = true
        }
    }
}
