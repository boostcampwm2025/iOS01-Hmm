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
    @State private var popupContent: PopupConfiguration?
    @State private var careerSystem: CareerSystem?
    @State private var isWorkGameInProgress: Bool = false
    @State private var showQuizView: Bool = false
    @State private var showSettingsView: Bool = false

    // 음료 광고 팝업 관련
    @State private var showDrinkAdPopup: Bool = false
    @State private var showRewardPopup: Bool = false
    @State private var selectedDrinkType: ConsumableType?
    @State private var resumeGameCallback: (() -> Void)?
    @State private var skillAdRewardNow = Date()

    // 오프라인 보상 팝업 관련
    @State private var showOfflineRewardPopup: Bool = false
    @State private var offlineRewardGold: Int = 0
    @State private var offlineRewardHours: Double = 0.0
    @State private var showOfflineRewardConfirmPopup: Bool = false
    @State private var hasCheckedOfflineReward: Bool = false

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
            .task {
                await updateSkillAdRewardTimer()
            }
            .onDisappear { SoundService.shared.stopBGM() }
            .onChange(of: scenePhase, handleScenePhaseChange)
            .task(id: user.record.totalEarnedMoney) {
                await careerSystem?.updateCareer()
            }
            .overlay { popupOverlayView }
            .overlay { settingsOverlayView }
            .overlay { drinkAdPopupOverlayView }
            .overlay { drinkRewardPopupOverlayView }
            .overlay { offlineRewardPopupOverlayView }
            .overlay { offlineRewardConfirmPopupOverlayView }
            .fullScreenCover(isPresented: $showQuizView) {
                QuizGameView(user: user)
            }
        }
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
                diamond: user.wallet.diamond,
                skillAdRewardRemainingText: SkillAdRewardManager.remainingTimeText(user: user, now: skillAdRewardNow)
            )
            .onTapGesture { showCareerPopup() }
            Spacer()
            characterSceneView
        }
    }

    var tabBar: some View {
        TabBar(
            selectedTab: $selectedTab,
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
                SmallButton(title: "퀴즈", hasBadge: true) {
                    showQuizView = true
                }
            }
            .padding(.top, Constant.TopButton.top)
            .padding(.horizontal, Constant.TopButton.horizontal)
            Spacer()
        }
    }

    var tabContentView: some View {
        ZStack {
            if isWorkGameInProgress {
                workGameOverlayView
            }
            if !isWorkGameInProgress || selectedTab != .work {
                tabContentSwitchView
            }
        }
    }

    var workGameOverlayView: some View {
        WorkSelectedView(
            user: user,
            animationSystem: animationSystem,
            isGameStarted: $isWorkGameInProgress,
            isGameViewDisappeared: Binding(
                get: { selectedTab != .work || showQuizView },
                set: { _ in }
            ),
            careerSystem: $careerSystem,
            showDrinkAdPopup: $showDrinkAdPopup,
            showRewardPopup: $showRewardPopup,
            selectedDrinkType: $selectedDrinkType,
            resumeGameCallback: $resumeGameCallback
        )
        .opacity(selectedTab == .work ? 1 : 0)
        .allowsHitTesting(selectedTab == .work)
    }

    @ViewBuilder
    var tabContentSwitchView: some View {
        switch selectedTab {
        case .work:
            if !isWorkGameInProgress {
                WorkSelectedView(
                    user: user,
                    animationSystem: animationSystem,
                    isGameStarted: $isWorkGameInProgress,
                    isGameViewDisappeared: Binding(
                        get: { selectedTab != .work || showQuizView },
                        set: { _ in }
                    ),
                    careerSystem: $careerSystem,
                    showDrinkAdPopup: $showDrinkAdPopup,
                    showRewardPopup: $showRewardPopup,
                    selectedDrinkType: $selectedDrinkType,
                    resumeGameCallback: $resumeGameCallback
                )
            }
        case .skill:
            SkillView(
                user: user,
                careerSystem: careerSystem,
                popupContent: $popupContent,
                adRewardNow: skillAdRewardNow
            )
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
        skillAdRewardNow = Date()
        autoGainSystem.startSystem()

        // 오프라인 보상 체크
        Task {
            await checkOfflineReward()
        }

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
            skillAdRewardNow = Date()
            autoGainSystem.startSystem()
            // 오프라인 보상 체크
            Task {
                await checkOfflineReward()
            }
        } else if newValue == .inactive || newValue == .background {
            skillAdRewardNow = Date()
            autoGainSystem.stopSystem()
        }
    }

    @MainActor
    func updateSkillAdRewardTimer() async {
        while !Task.isCancelled {
            skillAdRewardNow = Date()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
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
        resumeGameCallback?()
    }

    func handleRewardConfirmInMainView() {
        showRewardPopup = false
        selectedDrinkType = nil
        resumeGameCallback?()
    }

    // MARK: - Offline Reward

    @ViewBuilder
    var offlineRewardPopupOverlayView: some View {
        if showOfflineRewardPopup {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                OfflineRewardPopupView(
                    gold: offlineRewardGold,
                    hoursElapsed: offlineRewardHours,
                    onWatchAd: { Task { await handleOfflineRewardWatchAd() } },
                    onSkip: handleOfflineRewardSkip
                )
                .padding(.horizontal, Constant.Padding.horizontalPadding)
            }
        }
    }

    func checkOfflineReward() async {
        guard !hasCheckedOfflineReward else { return }

        hasCheckedOfflineReward = true

        let manager = OfflineRewardManager()
        let result = await manager.checkAndAwardOfflineReward(user: user)

        switch result {
        case .awarded(let gold, let hoursElapsed):
            // 보상 데이터 저장
            offlineRewardGold = gold
            offlineRewardHours = hoursElapsed
            // 팝업 표시
            showOfflineRewardPopup = true
        case .notEligible(_):
            // 보상을 받을 수 없는 경우, 다음 체크를 위해 플래그 리셋
            hasCheckedOfflineReward = false
        }
    }

    func handleOfflineRewardWatchAd() async {
        showOfflineRewardPopup = false

        let success = await AdService.shared.showAdWithResult(.interstitial)

        if success {
            user.wallet.addGold(offlineRewardGold)
            showOfflineRewardConfirmPopup = true
        } else {
            // 광고 실패 시 데이터 초기화
            offlineRewardGold = 0
            offlineRewardHours = 0.0
        }
    }

    func handleOfflineRewardSkip() {
        showOfflineRewardPopup = false
        // 데이터 초기화
        offlineRewardGold = 0
        offlineRewardHours = 0.0
        // 다음 체크를 위해 플래그 리셋
        hasCheckedOfflineReward = false
    }

    @ViewBuilder
    var offlineRewardConfirmPopupOverlayView: some View {
        if showOfflineRewardConfirmPopup {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                OfflineRewardConfirmPopupView(
                    gold: offlineRewardGold,
                    onConfirm: handleOfflineRewardConfirm
                )
                .padding(.horizontal, Constant.Padding.horizontalPadding)
            }
        }
    }

    func handleOfflineRewardConfirm() {
        showOfflineRewardConfirmPopup = false
        // 데이터 초기화
        offlineRewardGold = 0
        offlineRewardHours = 0.0
        // 다음 체크를 위해 플래그 리셋
        hasCheckedOfflineReward = false
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
