//
//  LanguageGameView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    enum Padding {
        static let horizontal: CGFloat = 16
        static let toolBarBottom: CGFloat = 10
    }

    enum Spacing {
        static let itemHorizontal: CGFloat = 25
        static let buttonHorizontal: CGFloat = 17
    }

    enum Game {
        static let itemCount: Int = 5
        static let feverDecreaseInterval: Double = 0.1
        static let feverDecreasePercentPerTick: Double = 5
    }

    enum EffectLabel {
        static let offsetY: CGFloat = -34
    }
}

struct LanguageGameView: View {
    // MARK: Properties
    let user: User

    /// 게임에 사용되는 언어 타입 목록
    private let languageTypeList: [LanguageType] = [
        .swift,
        .kotlin,
        .dart,
        .python
    ]

    // MARK: State Properties
    /// 게임 시작 상태 (부모 뷰와 바인딩)
    @Binding var isGameStarted: Bool
    @Binding var tabSwitchPause: Bool

    /// 상태를 유지
    @State private var game: LanguageGame
    @State private var closePause: Bool = false

    /// 획득한 골드를 표시하기 위한 효과 라벨 배열
    @State private var effectValues: [(id: UUID, value: Int)] = []

    /// 현재 진행 중인 언어 버튼 탭 Task
    @State private var currentActionTask: Task<Void, Never>?

    // 광고 팝업 관련
    @Binding var showDrinkAdPopup: Bool
    @Binding var showRewardPopup: Bool
    @Binding var showExitBonusPopup: Bool
    @Binding var selectedDrinkType: ConsumableType?
    @Binding var resumeGameCallback: (() -> Void)?
    @Binding var exitGameCallback: (() -> Void)?

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        tabSwitchPause: Binding<Bool>,
        animationSystem: CharacterAnimationSystem? = nil,
        showDrinkAdPopup: Binding<Bool>,
        showRewardPopup: Binding<Bool>,
        showExitBonusPopup: Binding<Bool>,
        selectedDrinkType: Binding<ConsumableType?>,
        resumeGameCallback: Binding<(() -> Void)?>,
        exitGameCallback: Binding<(() -> Void)?>
    ) {
        self._isGameStarted = isGameStarted
        self._tabSwitchPause = tabSwitchPause
        self.user = user
        self._showDrinkAdPopup = showDrinkAdPopup
        self._showRewardPopup = showRewardPopup
        self._showExitBonusPopup = showExitBonusPopup
        self._selectedDrinkType = selectedDrinkType
        self._resumeGameCallback = resumeGameCallback
        self._exitGameCallback = exitGameCallback

        // 게임 초기화
        let game = LanguageGame(
            user: user,
            feverSystem: .init(
                decreaseInterval: Constant.Game.feverDecreaseInterval,
                decreasePercentPerTick: Constant.Game.feverDecreasePercentPerTick
            ),
            buffSystem: .init(),
            itemCount: Constant.Game.itemCount,
            animationSystem: animationSystem
        )
        self._game = State(initialValue: game)
        self.game.startGame()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                // 상단 툴바 (닫기, 아이템 버튼, 피버 게이지)
                toolbarSection
                Spacer()
                // 중앙 언어 아이템 영역 (획득 골드 효과 포함)
                languageItemsSection
                Spacer()
                // 하단 언어 선택 버튼 영역
                languageButtonsSection
                Spacer()
            }
            .onAppear {
                AnalyticsService.shared.logGameStart(gameType: .language)
                // 게임 재개 콜백 설정
                resumeGameCallback = { [weak game] in
                    game?.resumeGame()
                }
                exitGameCallback = { handleCloseButton() }
            }
            .pauseGameStyle(
                pauseBinding: pauseBinding,
                height: geometry.size.height,
                onLeave: { showExitBonusPopup = true },
                onPause: { game.pauseGame() },
                onResume: { game.resumeGame() }
            )
        }
    }
}

// MARK: - View Components
private extension LanguageGameView {
    /// 상단 툴바
    var toolbarSection: some View {
        GameToolBar(
            closeButtonDidTapHandler: { closePause = true },
            coffeeButtonDidTapHandler: { useConsumableItem(.coffee) },
            energyDrinkButtonDidTapHandler: { useConsumableItem(.energyDrink) },
            feverState: game.feverSystem,
            buffSystem: game.buffSystem,
            coffeeCount: .constant(game.user.inventory.count(.coffee) ?? 0),
            energyDrinkCount: .constant(game.user.inventory.count(.energyDrink) ?? 0)
        )
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.bottom, Constant.Padding.toolBarBottom)
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

    /// 중앙 언어 아이템 영역
    var languageItemsSection: some View {
        HStack(alignment: .bottom, spacing: Constant.Spacing.itemHorizontal) {
            ForEach(Array(game.itemList.enumerated()), id: \.offset) { _, item in
                LanguageItem(
                    languageType: item.languageType,
                    state: item.state
                )
            }
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            // 획득한 골드를 표시하는 효과 라벨
            ZStack {
                ForEach(effectValues, id: \.id) { effect in
                    EffectLabel(value: effect.value) {
                        removeEffectLabel(id: effect.id)
                    }
                }
            }
            .offset(y: Constant.EffectLabel.offsetY)
        }
    }

    /// 하단 언어 선택 버튼 영역
    var languageButtonsSection: some View {
        HStack(spacing: Constant.Spacing.buttonHorizontal) {
            ForEach(languageTypeList, id: \.self) { type in
                LanguageButton(languageType: type) {
                    handleLanguageButtonTap(type)
                }
            }
        }
    }
}

// MARK: - Actions
private extension LanguageGameView {
    /// 닫기 버튼 클릭 처리
    func handleCloseButton() {
        // 진행 중인 액션 Task 취소
        currentActionTask?.cancel()
        currentActionTask = nil

        game.stopGame()
        isGameStarted = false
    }

    /// 언어 버튼 클릭 처리
    func handleLanguageButtonTap(_ type: LanguageType) {
        // 이전 액션이 진행 중이면 취소
        currentActionTask?.cancel()

        currentActionTask = Task {
            let gainedGold = await game.didPerformAction(type)

            // Task가 취소되었으면 UI 업데이트 생략
            guard !Task.isCancelled else { return }

            SoundService.shared.trigger(gainedGold > 0 ? .languageCorrect : .languageWrong)
            if gainedGold <= 0 {
                HapticService.shared.trigger(.error)
            }
            showEffectLabel(gainedGold: gainedGold)
        }
    }

    /// 소비 아이템 사용 처리
    func useConsumableItem(_ type: ConsumableType) {
        let count = game.user.inventory.count(type) ?? 0

        if count > 0 {
            // 음료 사용
            if game.user.inventory.drink(type) {
                SoundService.shared.trigger(.itemConsume)
                HapticService.shared.trigger(.success)
                game.buffSystem.useConsumableItem(type: type)
                game.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
            }
        } else {
            // 광고 팝업 표시
            selectedDrinkType = type
            showDrinkAdPopup = true
            game.pauseGame()
        }
    }
}

// MARK: - Helper Methods
private extension LanguageGameView {
    /// 획득한 골드를 표시하는 효과 라벨 추가
    /// - Parameter gainedGold: 획득한 골드 (음수일 경우 손실)
    func showEffectLabel(gainedGold: Int) {
        let effectId = UUID()
        effectValues.append((id: effectId, value: gainedGold))
    }

    /// 효과 라벨 제거 (애니메이션 완료 시 콜백으로 호출)
    /// - Parameter id: 제거할 효과 라벨의 ID
    func removeEffectLabel(id: UUID) {
        effectValues.removeAll { $0.id == id }
    }
}

#Preview {
    @Previewable @State var isGameStarted = true
    @Previewable @State var tabSwitchPause = true
    @Previewable @State var showDrinkAdPopup = false
    @Previewable @State var showRewardPopup = false
    @Previewable @State var showExitBonusPopup = false
    @Previewable @State var selectedDrinkType: ConsumableType?
    @Previewable @State var resumeGameCallback: (() -> Void)?
    @Previewable @State var exitGameCallback: (() -> Void)?

    let user = User(
        nickname: "Test",
        wallet: .init(),
        inventory: .init(),
        record: .init(),
        skills: [
            .init(key: SkillKey(game: .language, tier: .beginner), level: 1000)
        ]
    )

    LanguageGameView(
        user: user,
        isGameStarted: $isGameStarted,
        tabSwitchPause: $tabSwitchPause,
        animationSystem: nil,
        showDrinkAdPopup: $showDrinkAdPopup,
        showRewardPopup: $showRewardPopup,
        showExitBonusPopup: $showExitBonusPopup,
        selectedDrinkType: $selectedDrinkType,
        resumeGameCallback: $resumeGameCallback,
        exitGameCallback: $exitGameCallback
    )
}
