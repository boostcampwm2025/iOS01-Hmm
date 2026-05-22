//
//  MainView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI
import SpriteKit

enum AppTheme {
    static let backgroundColor: Color = AppColors.beige200
}

private enum Constant {
    static let characterSceneSize = CGSize(width: 100, height: 100)
    static let spriteViewSize = CGSize(width: 200, height: 200)
    static let topAreaHeightRatio: CGFloat = 0.5

    enum Padding {
        static let horizontalPadding: CGFloat = 25
    }

    enum Color {
        static let overlay = SwiftUI.Color.black.opacity(0.3)
    }

    enum CareerPopup {
        static let title: String = "커리어"
        static let maxHeight: CGFloat = 650
    }

    enum TopButton {
        static let top: CGFloat = 128
        static let horizontal: CGFloat = 16
    }
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: TabItem = .work
    // 게임 세션 관리
    @State private var workGameSession = WorkGameSession()

    @State private var popupContent: PopupConfiguration?
    @State private var careerSystem: CareerSystem?
    @State private var showQuizView: Bool = false
    @State private var showSettingsView: Bool = false

    // 음료 광고 팝업 관련
    @State private var showDrinkAdPopup: Bool = false
    @State private var showRewardPopup: Bool = false
    @State private var selectedDrinkType: ConsumableType?

    private var autoGainSystem: AutoGainSystem
    private let user: User
    private let scene: CharacterScene
    private let animationSystem: CharacterAnimationSystem

    init(user: User) {
        self.autoGainSystem = AutoGainSystem(user: user)
        self.user = user

        self.scene = CharacterScene(size: Constant.characterSceneSize, user: user)
        self.scene.scaleMode = .aspectFit
        self.scene.playIdle()

        // 애니메이션 시스템 생성 및 클로저 연결
        self.animationSystem = CharacterAnimationSystem()
        self.animationSystem.onSmile = { [weak scene] in
            scene?.playSmile()
        }
        self.animationSystem.onIdle = { [weak scene] in
            scene?.playIdle()
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                topAreaContent
                    .frame(height: geometry.size.height * Constant.topAreaHeightRatio)
                    .background(housingBackgroundView)
                tabBar
                tabContentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .background(AppTheme.backgroundColor)
            .onAppear(perform: setupOnAppear)
            .onDisappear { SoundService.shared.stopBGM() }
            .onChange(of: scenePhase, handleScenePhaseChange)
            .task(id: user.record.totalEarnedMoney) {
                await careerSystem?.updateCareer()
            }
            .overlay { popupOverlayView }
            .overlay { settingsOverlayView }
            .overlay { drinkAdPopupOverlayView }
            .overlay { drinkRewardPopupOverlayView }
            .overlay { exitBonusPopupOverlayView }
            .fullScreenCover(isPresented: $showQuizView) {
                QuizGameView(user: user)
            }
        }
        .darkToast(
            isShowing: workGameSession.exitBonusToastBinding,
            message: workGameSession.exitBonusToastMessage
        )
    }
}

private extension MainView {
    var topAreaContent: some View {
        ZStack(alignment: .top) {
            topAreaMainContent
            topButtonOverlay
        }
    }

    var topAreaMainContent: some View {
        VStack(spacing: 0) {
            StatusBar(
                career: careerSystem?.currentCareer ?? .unemployed,
                nickname: user.nickname,
                careerProgress: careerSystem?.careerProgress ?? 0.0,
                gold: user.wallet.gold,
                diamond: user.wallet.diamond
            )
            .onTapGesture { showCareerPopup() }
            Spacer()
            characterSceneView
        }
    }

    var tabBar: some View {
        TabBar(
            selectedTab: Binding(
                get: { selectedTab },
                set: { handleTabTap($0) }
            ),
            hasCompletedMisson: user.record
                .missionSystem.hasCompletedMission
        )
    }

    var characterSceneView: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .frame(width: Constant.spriteViewSize.width, height: Constant.spriteViewSize.height)
            .background(Color.clear)
    }

    var housingBackgroundView: some View {
        Image(user.inventory.housing.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }

    var topButtonOverlay: some View {
        VStack {
            HStack {
                SmallButton(title: "설정", image: Image(.iconSetting)) {
                    showSettingsView = true
                }
                Spacer()
                if !workGameSession.isInProgress {
                    SmallButton(title: "퀴즈", hasBadge: true) {
                        showQuizView = true
                    }
                }
            }
            .padding(.top, Constant.TopButton.top)
            .padding(.horizontal, Constant.TopButton.horizontal)
            Spacer()
        }
    }

    var tabContentView: some View {
        ZStack {
            if workGameSession.isInProgress {
                workGameOverlayView
            }
            if !workGameSession.isInProgress || selectedTab != .work {
                tabContentSwitchView
            }
        }
    }

    var workGameOverlayView: some View {
        WorkSelectedView(
            user: user,
            animationSystem: animationSystem,
            isGameStarted: workGameStartedBinding,
            gameActionGoldDelta: workGameSession.actionGoldDeltaBinding,
            tabSwitchPause: tabSwitchPauseBinding,
            careerSystem: $careerSystem,
            showDrinkAdPopup: $showDrinkAdPopup,
            showRewardPopup: $showRewardPopup,
            showExitBonusPopup: workGameSession.exitBonusPopupBinding,
            selectedDrinkType: $selectedDrinkType,
            resumeGameCallback: workGameSession.resumeGameBinding,
            exitGameCallback: workGameSession.exitGameBinding
        )
        .opacity(selectedTab == .work ? 1 : 0)
        .allowsHitTesting(selectedTab == .work)
    }

    @ViewBuilder
    var tabContentSwitchView: some View {
        switch selectedTab {
        case .work:
            if !workGameSession.isInProgress {
                WorkSelectedView(
                    user: user,
                    animationSystem: animationSystem,
                    isGameStarted: workGameStartedBinding,
                    gameActionGoldDelta: workGameSession.actionGoldDeltaBinding,
                    tabSwitchPause: tabSwitchPauseBinding,
                    careerSystem: $careerSystem,
                    showDrinkAdPopup: $showDrinkAdPopup,
                    showRewardPopup: $showRewardPopup,
                    showExitBonusPopup: workGameSession.exitBonusPopupBinding,
                    selectedDrinkType: $selectedDrinkType,
                    resumeGameCallback: workGameSession.resumeGameBinding,
                    exitGameCallback: workGameSession.exitGameBinding
                )
            }
        case .skill:
            SkillView(user: user, careerSystem: careerSystem, popupContent: $popupContent)
        case .shop:
            ShopView(user: user, popupContent: $popupContent)
        case .mission:
            MissionView(user: user)
        }
    }

    @ViewBuilder
    var popupOverlayView: some View {
        if let popupContent {
            ZStack {
                Constant.Color.overlay
                    .ignoresSafeArea()
                    .onTapGesture { self.popupContent = nil }

                Popup(title: popupContent.title, contentView: popupContent.content)
                    .frame(maxHeight: popupContent.maxHeight)
                    .padding(.horizontal, Constant.Padding.horizontalPadding)
            }
        }
    }

    @ViewBuilder
    var settingsOverlayView: some View {
        if showSettingsView {
            ZStack {
                Constant.Color.overlay
                    .ignoresSafeArea()
                    .onTapGesture { showSettingsView = false }

                FeedbackSettingView(onClose: { showSettingsView = false })
                    .padding(.horizontal, Constant.Padding.horizontalPadding)
            }
        }
    }

    func setupOnAppear() {
        AnalyticsService.shared.logScreenView(screenName: "main")
        SoundService.shared.playBGM()
        autoGainSystem.startSystem()
        Task {
            if careerSystem == nil {
                careerSystem = await CareerSystem(user: user)
                careerSystem?.onCareerChanged = { [weak scene] newCareer in
                    scene?.updateCareerAppearance(to: newCareer)
                }
            }
        }
    }

    func handleScenePhaseChange(_ oldValue: ScenePhase, _ newValue: ScenePhase) {
        if newValue == .active {
            autoGainSystem.startSystem()
        } else if newValue == .inactive || newValue == .background {
            autoGainSystem.stopSystem()
        }
    }

    var workGameStartedBinding: Binding<Bool> {
        Binding(
            get: { workGameSession.isInProgress },
            set: { isStarted in
                guard !isStarted else {
                    workGameSession.start()
                    return
                }

                if let pendingTab = workGameSession.finish() {
                    selectedTab = pendingTab
                }
            }
        )
    }

    var tabSwitchPauseBinding: Binding<Bool> {
        Binding(
            get: { workGameSession.isPauseRequested },
            set: { isPaused in
                if isPaused {
                    workGameSession.isPauseRequested = true
                } else {
                    workGameSession.cancelPauseRequest()
                }
            }
        )
    }

    func handleTabTap(_ newTab: TabItem) {
        guard selectedTab != newTab else { return }

        if workGameSession.isInProgress && selectedTab == .work && newTab != .work {
            workGameSession.requestTabSwitch(to: newTab)
            return
        }

        selectedTab = newTab
    }

    func showCareerPopup() {
        guard let careerSystem else { return }

        popupContent = PopupConfiguration(
            title: Constant.CareerPopup.title,
            maxHeight: Constant.CareerPopup.maxHeight
        ) {
            CareerPopupView(
                careerSystem: careerSystem,
                user: user,
                onClose: {
                    popupContent = nil
                }
            )
        }
    }

    @ViewBuilder
    var drinkAdPopupOverlayView: some View {
        if showDrinkAdPopup, let drinkType = selectedDrinkType {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                DrinkAdPopupView(
                    drinkType: drinkType,
                    onWatchAd: { Task { await handleWatchAdInMainView() } },
                    onSkip: handleSkipAdInMainView
                )
                .padding(.horizontal, Constant.Padding.horizontalPadding)
            }
        }
    }

    @ViewBuilder
    var drinkRewardPopupOverlayView: some View {
        if showRewardPopup, let drinkType = selectedDrinkType {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                DrinkRewardPopupView(
                    drinkType: drinkType,
                    onConfirm: handleRewardConfirmInMainView
                )
                .padding(.horizontal, Constant.Padding.horizontalPadding)
            }
        }
    }

    @ViewBuilder
    var exitBonusPopupOverlayView: some View {
        if workGameSession.showsExitBonusPopup {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                WorkExitBonusPopupView(
                    onWatchAd: { Task { await handleExitBonusAd() } },
                    onLeave: handleExitWithoutBonus
                )
                .padding(.horizontal, Constant.Padding.horizontalPadding)
            }
        }
    }

    func handleWatchAdInMainView() async {
        showDrinkAdPopup = false

        guard let drinkType = selectedDrinkType else { return }

        // 광고 시청
        let success = await AdService.shared.showAdWithResult(.interstitial)

        if success {
            // 보상 지급
            user.inventory.gain(consumable: drinkType)

            // 보상 팝업 표시
            showRewardPopup = true
        } else {
            // 광고 실패 시 초기화
            selectedDrinkType = nil
        }
    }

    func handleSkipAdInMainView() {
        showDrinkAdPopup = false
        selectedDrinkType = nil
        workGameSession.resumeGame?()
    }

    func handleRewardConfirmInMainView() {
        showRewardPopup = false
        selectedDrinkType = nil
        workGameSession.resumeGame?()
    }

    func handleExitBonusAd() async {
        workGameSession.showsExitBonusPopup = false
        let success = await AdService.shared.showAdWithResult(.interstitial)
        if success {
            applyExitBonus()
        }
        exitWorkGame(shouldReturnToWorkTab: success)
    }

    func handleExitWithoutBonus() {
        workGameSession.showsExitBonusPopup = false
        exitWorkGame()
    }

    func applyExitBonus() {
        let bonusGold = max(0, workGameSession.actionGoldDelta)
        if bonusGold > 0 {
            user.wallet.addGold(bonusGold)
            user.record.record(.earnMoney(bonusGold))
        }
        workGameSession.exitBonusToastMessage = bonusGold > 0 ? "업무 보너스 \(bonusGold.formatted) 골드를 받았습니다!" : "업무 보너스를 받을 재화가 없습니다."
        workGameSession.showsExitBonusToast = true
    }

    func exitWorkGame(shouldReturnToWorkTab: Bool = false) {
        if shouldReturnToWorkTab {
            workGameSession.pendingTab = nil
        }
        workGameSession.exitGame?()
        workGameSession.isPauseRequested = false
        workGameSession.resetCallbacks()
    }
}

#Preview {
    let user = User(
        nickname: "소피아",
        career: .unemployed,
        wallet: .init(),
        inventory: Inventory(
            equipmentItems: [
                .init(type: .chair, tier: .broken),
                .init(type: .keyboard, tier: .broken),
                .init(type: .monitor, tier: .broken),
                .init(type: .mouse, tier: .broken)
            ],
            housing: .init(tier: .street)
        ),
        record: .init(),
        skills: [
            .init(key: SkillKey(game: .tap, tier: .beginner), level: 10),
            .init(key: SkillKey(game: .language, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .dodge, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .stack, tier: .beginner), level: 1)
        ]
    )
    MainView(user: user)
}
