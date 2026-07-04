//
//  StackGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI
import SpriteKit

import DUDesignSystem

private enum Constant {
    enum EffectLabel {
        static let xRatios: [CGFloat] = [0.3, 0.4, 0.7]
        static let yPositions: [CGFloat] = [150, 200, 250]
    }
}

struct StackGameView: View {

    /// 데이터 쌓기 게임 모델
    @State private var stackGame: StackGame
    /// 닫기 버튼으로 인한 일시정지
    @State private var closePause: Bool = false
    /// 데이터 쌓기 게임 SpriteKit 씬
    @State private var scene: StackGameScene
    /// 획득한 골드를 표시하는 효과 라벨 목록
    @State private var effectLabels: [EffectLabelData] = []
    @State private var drinkAdRewardFlowID: String?

    /// 게임 시작 여부 (false로 바꾸면 선택 화면으로 복귀)
    @Binding var isGameStarted: Bool
    /// 이번 세션에서 획득한 골드 누적량
    @Binding var gameActionGoldDelta: Int
    /// 탭 전환으로 인한 일시정지
    @Binding var tabSwitchPause: Bool
    /// 팝업에서 게임 재개 시 호출되는 콜백
    @Binding var resumeGameCallback: (() -> Void)?
    /// 팝업에서 게임 종료 시 호출되는 콜백
    @Binding var exitGameCallback: (() -> Void)?
    /// 퇴장 보너스 팝업 표시 요청 콜백
    @Binding var showExitBonusPopup: Bool

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        gameActionGoldDelta: Binding<Int>,
        tabSwitchPause: Binding<Bool>,
        animationSystem: CharacterAnimationSystem?,
        showExitBonusPopup: Binding<Bool>,
        resumeGameCallback: Binding<(() -> Void)?>,
        exitGameCallback: Binding<(() -> Void)?>
    ) {
        let stackGame = StackGame(user: user, animationSystem: animationSystem)
        self.stackGame = stackGame
        self.scene = StackGameScene(
            stackGame: stackGame,
            onBlockDropped: { _ in }
        )
        _isGameStarted = isGameStarted
        _gameActionGoldDelta = gameActionGoldDelta
        _tabSwitchPause = tabSwitchPause
        _showExitBonusPopup = showExitBonusPopup
        _resumeGameCallback = resumeGameCallback
        _exitGameCallback = exitGameCallback
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbarSection
            gameAreaSection
        }
        .analyticsScreen(pauseBinding.wrappedValue ? .stackingExit : .stacking)
    }
}

// MARK: - Sections
private extension StackGameView {

    var toolbarSection: some View {
        GameToolBar(
            feverStage: stackGame.feverSystem.feverStage,
            feverProgress: {
                let stageBase = Double(stackGame.feverSystem.feverStage) * 100.0
                return (stackGame.feverSystem.feverPercent - stageBase) / 100.0
            }(),
            feverMultiplier: stackGame.feverSystem.feverStage == 0 ? 0 : stackGame.feverSystem.feverMultiplier,
            coffeeCount: stackGame.user.inventory.count(.coffee) ?? 0,
            energyDrinkCount: stackGame.user.inventory.count(.energyDrink) ?? 0,
            coffeeCooldown: {
                Double(stackGame.buffSystem.coffeeDuration) / Double(ConsumableType.coffee.duration)
            }(),
            energyDrinkCooldown: {
                Double(stackGame.buffSystem.energyDrinkDuration) / Double(ConsumableType.energyDrink.duration)
            }(),
            onClose: {
                closePause = true
                SoundService.shared.stopAllSFX()
                SoundService.shared.trigger(.click)
            },
            onCoffee: { useConsumableItem(.coffee) },
            onEnergyDrink: { useConsumableItem(.energyDrink) }
        )
        .padding(.bottom, TokenSpacing.md)
    }

    var gameAreaSection: some View {
        GeometryReader { geometry in
            ZStack {
                SpriteView(scene: scene)

                ForEach(effectLabels) { effect in
                    EffectLabel(type: effect.value >= 0 ? .plus : .minus, text: "\(abs(effect.value))") {
                        removeEffectLabel(id: effect.id)
                    }
                    .position(effect.position)
                }
            }
            .onAppear {
                setupGameCallbacks(with: geometry)
                resumeGameCallback = { [weak scene] in
                    scene?.resumeGame()
                }
                exitGameCallback = { handleCloseButton() }
            }
            .gamePauseWrapper(
                pauseBinding: pauseBinding,
                onLeave: { showExitBonusPopup = true },
                onPause: { scene.pauseGame() },
                onResume: { scene.resumeGame() }
            )
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
private extension StackGameView {

    func removeEffectLabel(id: UUID) {
        effectLabels.removeAll { $0.id == id }
    }

    func setupGameCallbacks(with geometry: GeometryProxy) {
        scene.onBlockDropped = { gold in
            gameActionGoldDelta += gold
            showEffectLabel(
                at: CGPoint(
                    x: geometry.size.width * randomEffectXRatio,
                    y: randomEffectYOffset
                ),
                value: gold
            )
        }
    }

    func showEffectLabel(at location: CGPoint, value: Int) {
        let data = EffectLabelData(id: UUID(), position: location, value: value)
        effectLabels.append(data)
    }

    var randomEffectXRatio: CGFloat {
        Constant.EffectLabel.xRatios.randomElement() ?? 0.4
    }

    var randomEffectYOffset: CGFloat {
        Constant.EffectLabel.yPositions.randomElement() ?? 200
    }

    func handleCloseButton() {
        stackGame.stopGame()
        isGameStarted = false
    }

    func useConsumableItem(_ type: ConsumableType) {
        let count = stackGame.user.inventory.count(type) ?? 0
        if count > 0 {
            if stackGame.user.inventory.drink(type) {
                SoundService.shared.trigger(.drink)
                HapticService.shared.trigger(.success)
                stackGame.buffSystem.useConsumableItem(type: type)
                stackGame.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
            }
        } else {
            scene.pauseGame()
            let flowID = AnalyticsService.shared.makeAdRewardFlowID()
            drinkAdRewardFlowID = flowID
            let rewardType: AdRewardType = type == .coffee ? .coffee : .energyDrink
            AnalyticsService.shared.logAdOfferViewed(
                adRewardFlowID: flowID,
                adPlacement: .consumable(screenID: "caffein"),
                rewardType: rewardType,
                rewardAmount: 1
            )
            PopupManager.shared.show {
                NoticePopup(
                    type: .ad(
                        cancelText: "그냥 하기",
                        adText: "음료 받기",
                        cancelAction: {
                            SoundService.shared.trigger(.click)
                            PopupManager.shared.dismiss()
                            if let flowID = drinkAdRewardFlowID {
                                AnalyticsService.shared.logAdOfferDismissed(
                                    adRewardFlowID: flowID,
                                    adPlacement: .consumable(screenID: "caffein"),
                                    rewardType: rewardType,
                                    rewardAmount: 1,
                                    dismissReason: .close
                                )
                                drinkAdRewardFlowID = nil
                            }
                            scene.resumeGame()
                        },
                        adAction: {
                            SoundService.shared.trigger(.click)
                            Task { await handleDrinkAd(type: type) }
                        }
                    ),
                    title: type == .coffee ? "커피 없음" : "박하스 없음",
                    text: "대신에 광고를 보고\n카페인을 보충할까요?"
                )
            }
        }
    }

    func handleDrinkAd(type: ConsumableType) async {
        PopupManager.shared.dismiss()

        guard let flowID = drinkAdRewardFlowID else { return }
        drinkAdRewardFlowID = nil
        let rewardType: AdRewardType = type == .coffee ? .coffee : .energyDrink

        AnalyticsService.shared.logAdWatchClicked(
            adRewardFlowID: flowID,
            adPlacement: .consumable(screenID: "caffein"),
            rewardType: rewardType,
            rewardAmount: 1
        )

        let result = await AdService.shared.showAdWithResult(.interstitial)

        if result.success {
            AnalyticsService.shared.logAdWatchCompleted(
                adRewardFlowID: flowID,
                adPlacement: .consumable(screenID: "caffein"),
                rewardType: rewardType,
                rewardAmount: 1,
                adWatchDurationSec: result.watchDurationSec
            )
            stackGame.user.inventory.gain(consumable: type)
            ToastManager.shared.show("카페인 충전 완료!")
            AnalyticsService.shared.logAdRewardClaimed(
                adRewardFlowID: flowID,
                adPlacement: .consumable(screenID: "caffein"),
                rewardType: rewardType,
                rewardAmount: 1
            )
        }
        scene.resumeGame()
    }
}
