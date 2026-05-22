//
//  WorkSelectedView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    enum Padding {
        static let horizontal: CGFloat = 16
        static let selectionViewBottom: CGFloat = 30
    }

    enum UserDefaults {
        static let lastSelectedWorkIndexKey = "lastSelectedWorkIndex"
    }

    enum Description {
        static let tapGame = "모니터를 최대한 많이 누르세요."
        static let languageGame = "올바른 버튼을 누르세요."
        static let dodgeGame = "기기를 기울여 버그를 피하고 골드를 획득하세요."
        static let stackGame = "최대한 높은 데이터를 쌓으세요."
    }

    static let contentSpacing: CGFloat = 17
    static let descriptionSpacing: CGFloat = 10
}

struct WorkSelectedView: View {

    let user: User
    let animationSystem: CharacterAnimationSystem?
    @State var selectedIndex: Int = 0
    @State var workItems: [WorkItem] = []
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @Binding var isGameStarted: Bool
    @Binding var gameActionGoldDelta: Int
    @Binding var tabSwitchPause: Bool
    @Binding var careerSystem: CareerSystem?

    // 광고 팝업 관련
    @Binding var showDrinkAdPopup: Bool
    @Binding var showRewardPopup: Bool
    @Binding var showExitBonusPopup: Bool
    @Binding var selectedDrinkType: ConsumableType?
    @Binding var resumeGameCallback: (() -> Void)?
    @Binding var exitGameCallback: (() -> Void)?

    private let localStorage: KeyValueLocalStorage = UserDefaultsStorage()

    init(
        user: User,
        animationSystem: CharacterAnimationSystem?,
        isGameStarted: Binding<Bool>,
        gameActionGoldDelta: Binding<Int>,
        tabSwitchPause: Binding<Bool>,
        careerSystem: Binding<CareerSystem?>,
        showDrinkAdPopup: Binding<Bool>,
        showRewardPopup: Binding<Bool>,
        showExitBonusPopup: Binding<Bool>,
        selectedDrinkType: Binding<ConsumableType?>,
        resumeGameCallback: Binding<(() -> Void)?>,
        exitGameCallback: Binding<(() -> Void)?>
    ) {
        self.user = user
        self.animationSystem = animationSystem
        self._isGameStarted = isGameStarted
        self._gameActionGoldDelta = gameActionGoldDelta
        self._tabSwitchPause = tabSwitchPause
        self._careerSystem = careerSystem
        self._showDrinkAdPopup = showDrinkAdPopup
        self._showRewardPopup = showRewardPopup
        self._showExitBonusPopup = showExitBonusPopup
        self._selectedDrinkType = selectedDrinkType
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
            workItems = createWorkItems(career: careerSystem?.currentCareer)
            loadLastSelectedIndex()
        }
        .onChange(of: selectedIndex) { _, newValue in
            saveLastSelectedIndex(newValue)
        }
        .onChange(of: careerSystem?.currentCareer) { _, newValue in
            workItems = createWorkItems(career: newValue)
        }
    }
}

// MARK: - Subviews
private extension WorkSelectedView {

    var selectionView: some View {
        VStack(spacing: Constant.contentSpacing) {
            workSegmentControl
            descriptionStack
            Spacer()
            startButton
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .toast(isShowing: $showToast, message: toastMessage)
    }

    var workSegmentControl: some View {
        WorkSegmentControl(
            items: workItems,
            onLockedTap: { requiredCareer in
                toastMessage = "\(requiredCareer.rawValue)부터 플레이할 수 있습니다."
                showToast = true
            }
            , selectedIndex: $selectedIndex
        )
    }

    var descriptionStack: some View {
        VStack(alignment: .leading, spacing: Constant.descriptionSpacing) {
            Text(actionDescription(for: selectedIndex))
                .foregroundStyle(.gray300)
                .textStyle(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var startButton: some View {
        LargeButton(title: "시작하기") {
            isGameStarted = true
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .padding(.bottom, Constant.Padding.selectionViewBottom)
    }
}

// MARK: - Helper
private extension WorkSelectedView {

    func createWorkItems(career: Career?) -> [WorkItem] {
        let currentCareer = career ?? .unemployed
        let currentWealth = currentCareer.requiredWealth

        let tapUnlocked = currentWealth >= Policy.Game.GameUnlock.tap
        let languageUnlocked = currentWealth >= Policy.Game.GameUnlock.language
        let dodgeUnlocked = currentWealth >= Policy.Game.GameUnlock.dodge
        let stackUnlocked = currentWealth >= Policy.Game.GameUnlock.stack

        return [
            .init(
                title: "코드짜기",
                imageName: GameType.tap.imageName,
                isDisabled: !tapUnlocked,
                requiredCareer: findCareer(for: Policy.Game.GameUnlock.tap)
            ),
            .init(
                title: "언어 맞추기",
                imageName: GameType.language.imageName,
                isDisabled: !languageUnlocked,
                requiredCareer: findCareer(for: Policy.Game.GameUnlock.language)
            ),
            .init(
                title: "버그 피하기",
                imageName: GameType.dodge.imageName,
                isDisabled: !dodgeUnlocked,
                requiredCareer: findCareer(for: Policy.Game.GameUnlock.dodge)
            ),
            .init(
                title: "데이터 쌓기",
                imageName: GameType.stack.imageName,
                isDisabled: !stackUnlocked,
                requiredCareer: findCareer(for: Policy.Game.GameUnlock.stack)
            )
        ]
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
                showDrinkAdPopup: $showDrinkAdPopup,
                showRewardPopup: $showRewardPopup,
                showExitBonusPopup: $showExitBonusPopup,
                selectedDrinkType: $selectedDrinkType,
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
                showDrinkAdPopup: $showDrinkAdPopup,
                showRewardPopup: $showRewardPopup,
                showExitBonusPopup: $showExitBonusPopup,
                selectedDrinkType: $selectedDrinkType,
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
                showDrinkAdPopup: $showDrinkAdPopup,
                showRewardPopup: $showRewardPopup,
                showExitBonusPopup: $showExitBonusPopup,
                selectedDrinkType: $selectedDrinkType,
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
                showDrinkAdPopup: $showDrinkAdPopup,
                showRewardPopup: $showRewardPopup,
                showExitBonusPopup: $showExitBonusPopup,
                selectedDrinkType: $selectedDrinkType,
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
        let savedIndex = localStorage.integer(key: Constant.UserDefaults.lastSelectedWorkIndexKey)
        if savedIndex >= 0 && savedIndex < workItems.count {
            selectedIndex = savedIndex
        } else {
            selectedIndex = 0
        }
    }

    func saveLastSelectedIndex(_ index: Int) {
        localStorage.set(index, forKey: Constant.UserDefaults.lastSelectedWorkIndexKey)
    }
}

#Preview {
    @Previewable @State var isGameStarted = false
    @Previewable @State var gameActionGoldDelta = 0
    @Previewable @State var tabSwitchPause = false
    @Previewable @State var careerSystem: CareerSystem?
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
        record: .init()
    )

    WorkSelectedView(
        user: user,
        animationSystem: nil,
        isGameStarted: $isGameStarted,
        gameActionGoldDelta: $gameActionGoldDelta,
        tabSwitchPause: $tabSwitchPause,
        careerSystem: $careerSystem,
        showDrinkAdPopup: $showDrinkAdPopup,
        showRewardPopup: $showRewardPopup,
        showExitBonusPopup: $showExitBonusPopup,
        selectedDrinkType: $selectedDrinkType,
        resumeGameCallback: $resumeGameCallback,
        exitGameCallback: $exitGameCallback
    )
}
