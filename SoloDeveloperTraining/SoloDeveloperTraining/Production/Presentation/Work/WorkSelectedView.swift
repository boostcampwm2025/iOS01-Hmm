//
//  WorkSelectedView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

import DUDesignSystem

private enum Constant {
    enum Description {
        static let tapGame = "모니터를 최대한 많이 누르세요."
        static let languageGame = "올바른 버튼을 누르세요."
        static let dodgeGame = "기기를 기울여 버그를 피하고 골드를 획득하세요."
        static let stackGame = "최대한 높은 데이터를 쌓으세요."
    }
}

struct WorkSelectedView: View {

    let user: User
    let animationSystem: CharacterAnimationSystem?
    @State var selectedIndex: Int = 0
    @State var workItems: [WorkSegmentControl.Item] = []
    @State private var requiredCareers: [Career?] = []
    @Binding var isGameStarted: Bool
    @Binding var gameActionGoldDelta: Int
    @Binding var tabSwitchPause: Bool
    @Binding var careerSystem: CareerSystem?

    @Binding var resumeGameCallback: (() -> Void)?
    @Binding var exitGameCallback: (() -> Void)?
    @Binding var showExitBonusPopup: Bool

    init(
        user: User,
        animationSystem: CharacterAnimationSystem?,
        isGameStarted: Binding<Bool>,
        gameActionGoldDelta: Binding<Int>,
        tabSwitchPause: Binding<Bool>,
        careerSystem: Binding<CareerSystem?>,
        showExitBonusPopup: Binding<Bool>,
        resumeGameCallback: Binding<(() -> Void)?>,
        exitGameCallback: Binding<(() -> Void)?>
    ) {
        self.user = user
        self.animationSystem = animationSystem
        self._isGameStarted = isGameStarted
        self._gameActionGoldDelta = gameActionGoldDelta
        self._tabSwitchPause = tabSwitchPause
        self._careerSystem = careerSystem
        self._showExitBonusPopup = showExitBonusPopup
        self._resumeGameCallback = resumeGameCallback
        self._exitGameCallback = exitGameCallback
    }

    var body: some View {
        Group {
            if isGameStarted {
                gameView(for: selectedIndex)
            } else {
                selectionView
            }
        }
        .onAppear {
            (workItems, requiredCareers) = makeWorkItems(career: careerSystem?.currentCareer)
            loadLastSelectedIndex()
        }
        .onChange(of: selectedIndex) { _, newValue in
            saveLastSelectedIndex(newValue)
        }
        .onChange(of: careerSystem?.currentCareer) { _, newValue in
            (workItems, requiredCareers) = makeWorkItems(career: newValue)
        }
    }
}

// MARK: - Subviews
private extension WorkSelectedView {

    var selectionView: some View {
        VStack(spacing: TokenSpacing.lg) {
            WorkSegmentControl(
                items: workItems,
                selectedIndex: Binding(
                    get: { selectedIndex },
                    set: { newValue in
                        SoundService.shared.trigger(.click)
                        selectedIndex = newValue
                    }
                ),
                onLockedTap: { index in
                    guard index < requiredCareers.count, let career = requiredCareers[index] else { return }
                    SoundService.shared.trigger(.click)
                    ToastManager.shared.show("\(career.rawValue)부터 플레이할 수 있습니다.")
                }
            )
            ItemLabel(text: actionDescription(for: selectedIndex), font: .body2, color: .black300)
            TextButton(text: "시작하기", type: .primary, size: .large) {
                SoundService.shared.trigger(.click)
                isGameStarted = true
            }
            .padding(.bottom, TokenGrid.paddingBottom)
        }
        .padding(.horizontal, TokenGrid.paddingSide)
    }
}

// MARK: - Helper
private extension WorkSelectedView {

    func makeWorkItems(career: Career?) -> ([WorkSegmentControl.Item], [Career?]) {
        let currentWealth = (career ?? .unemployed).requiredWealth

        let configs: [(String, GameType, Int)] = [
            ("코드짜기", .tap, Policy.Game.GameUnlock.tap),
            ("언어 맞추기", .language, Policy.Game.GameUnlock.language),
            ("버그 피하기", .dodge, Policy.Game.GameUnlock.dodge),
            ("데이터 쌓기", .stack, Policy.Game.GameUnlock.stack),
        ]

        let items = configs.map { title, gameType, unlock in
            WorkSegmentControl.Item(title: title, imageName: gameType.imageName, isLocked: currentWealth < unlock)
        }
        let careers = configs.map { _, _, unlock in
            findCareer(for: unlock)
        }
        return (items, careers)
    }

    func findCareer(for requiredWealth: Int) -> Career? {
        return Career.allCases.first { $0.requiredWealth == requiredWealth }
    }

    @ViewBuilder
    func gameView(for index: Int) -> some View {
        switch index {
        case 0:
            TapGameView(
                user: user,
                isGameStarted: $isGameStarted,
                gameActionGoldDelta: $gameActionGoldDelta,
                tabSwitchPause: $tabSwitchPause,
                animationSystem: animationSystem,
                showExitBonusPopup: $showExitBonusPopup,
                resumeGameCallback: $resumeGameCallback,
                exitGameCallback: $exitGameCallback
            )
        case 1:
            LanguageGameView(
                user: user,
                isGameStarted: $isGameStarted,
                gameActionGoldDelta: $gameActionGoldDelta,
                tabSwitchPause: $tabSwitchPause,
                animationSystem: animationSystem,
                showExitBonusPopup: $showExitBonusPopup,
                resumeGameCallback: $resumeGameCallback,
                exitGameCallback: $exitGameCallback
            )
        case 2:
            DodgeGameView(
                user: user,
                isGameStarted: $isGameStarted,
                gameActionGoldDelta: $gameActionGoldDelta,
                tabSwitchPause: $tabSwitchPause,
                animationSystem: animationSystem,
                showExitBonusPopup: $showExitBonusPopup,
                resumeGameCallback: $resumeGameCallback,
                exitGameCallback: $exitGameCallback
            )
        case 3:
            StackGameView(
                user: user,
                isGameStarted: $isGameStarted,
                gameActionGoldDelta: $gameActionGoldDelta,
                tabSwitchPause: $tabSwitchPause,
                animationSystem: animationSystem,
                showExitBonusPopup: $showExitBonusPopup,
                resumeGameCallback: $resumeGameCallback,
                exitGameCallback: $exitGameCallback
            )
        default:
            EmptyView()
        }
    }

    func actionDescription(for index: Int) -> String {
        switch index {
        case 0:
            return Constant.Description.tapGame
        case 1:
            return Constant.Description.languageGame
        case 2:
            return Constant.Description.dodgeGame
        case 3:
            return Constant.Description.stackGame
        default:
            return ""
        }
    }

    func loadLastSelectedIndex() {
        let savedIndex = AppPreferences.shared.lastSelectedWorkIndex
        if savedIndex >= 0 && savedIndex < workItems.count {
            selectedIndex = savedIndex
        } else {
            selectedIndex = 0
        }
    }

    func saveLastSelectedIndex(_ index: Int) {
        AppPreferences.shared.lastSelectedWorkIndex = index
    }
}

#Preview {
    @Previewable @State var isGameStarted = false
    @Previewable @State var gameActionGoldDelta = 0
    @Previewable @State var tabSwitchPause = false
    @Previewable @State var careerSystem: CareerSystem?
    @Previewable @State var showExitBonusPopup = false
    @Previewable @State var resumeGameCallback: (() -> Void)?
    @Previewable @State var exitGameCallback: (() -> Void)?

    let user = User(
        nickname: "Test",
        wallet: .init(),
        inventory: .init(),
        record: .init()
    )

    WorkSelectedView(
        user: user,
        animationSystem: nil,
        isGameStarted: $isGameStarted,
        gameActionGoldDelta: $gameActionGoldDelta,
        tabSwitchPause: $tabSwitchPause,
        careerSystem: $careerSystem,
        showExitBonusPopup: $showExitBonusPopup,
        resumeGameCallback: $resumeGameCallback,
        exitGameCallback: $exitGameCallback
    )
}
