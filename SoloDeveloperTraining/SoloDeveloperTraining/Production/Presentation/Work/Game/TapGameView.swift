//
//  TapGameView.swift
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

struct TapGameView: View {

    /// 코드짜기 게임 모델
    @State private var tapGame: TapGame
    /// 닫기 버튼으로 인한 일시정지
    @State private var closePause: Bool = false
    /// 터치 위치에 표시되는 골드 획득 효과
    @State private var effectLabels: [EffectLabelData] = []
    /// 탭 사운드 쓰로틀용 마지막 재생 시각
    @State private var lastTapSoundTime: Date = .distantPast
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
        _showExitBonusPopup = showExitBonusPopup
        _resumeGameCallback = resumeGameCallback
        _exitGameCallback = exitGameCallback
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbarSection
            gameAreaSection
        }
        .analyticsScreen(pauseBinding.wrappedValue ? .codingExit : .coding)
    }
}

// MARK: - Sections
private extension TapGameView {

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
                SoundService.shared.trigger(.click)
            },
            onCoffee: { useConsumableItem(.coffee) },
            onEnergyDrink: { useConsumableItem(.energyDrink) }
        )
        .padding(.bottom, TokenSpacing.md)
    }

    var gameAreaSection: some View {
        ZStack {
            Color.clear
                .overlay(
                    Image.duImage("tapBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .clipped()

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
        .onAppear {
            resumeGameCallback = { [weak tapGame] in
                tapGame?.resumeGame()
            }
            exitGameCallback = { handleCloseButton() }
        }
        .gamePauseWrapper(
            pauseBinding: pauseBinding,
            onLeave: { showExitBonusPopup = true },
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
private extension TapGameView {

    @MainActor
    func handleTap(at location: CGPoint) async {
        let now = Date()
        if !tapGame.isPaused,
           now.timeIntervalSince(lastTapSoundTime) >= Constant.tapSoundThrottleInterval {
            SoundService.shared.trigger(.typing)
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
                SoundService.shared.trigger(.drink)
                HapticService.shared.trigger(.success)
                tapGame.buffSystem.useConsumableItem(type: type)
                tapGame.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
            }
        } else {
            tapGame.pauseGame()
            let flowID = AnalyticsService.shared.makeAdRewardFlowID()
            drinkAdRewardFlowID = flowID
            let rewardType: AdRewardType = type == .coffee ? .coffee : .energyDrink
            AnalyticsService.shared.logAdOfferViewed(
                adRewardFlowID: flowID,
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
                                    rewardType: rewardType,
                                    rewardAmount: 1,
                                    dismissReason: .close
                                )
                                drinkAdRewardFlowID = nil
                            }
                            tapGame.resumeGame()
                        },
                        adAction: {
                            SoundService.shared.trigger(.click)
                            Task { await handleDrinkAd(type: type) }
                        }
                    ),
                    title: type == .coffee ? "커피 없음" : "박하스 없음",
                    text: "대신에 광고를 보고\n카페인을 보충할까요?"
                )
                .analyticsScreen(.caffein)
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
            rewardType: rewardType,
            rewardAmount: 1
        )

        let result = await AdService.shared.showAdWithResult(.interstitial)

        if result.success {
            AnalyticsService.shared.logAdWatchCompleted(
                adRewardFlowID: flowID,
                rewardType: rewardType,
                rewardAmount: 1,
                adWatchDurationSec: result.watchDurationSec
            )
            tapGame.inventory.gain(consumable: type)
            ToastManager.shared.show("카페인 충전 완료!")
            AnalyticsService.shared.logAdRewardClaimed(
                adRewardFlowID: flowID,
                rewardType: rewardType,
                rewardAmount: 1
            )
        }
        tapGame.resumeGame()
    }
}
