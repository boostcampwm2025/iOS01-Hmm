//
//  MainView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI
import SpriteKit

import DUDesignSystem

private enum Constant {
    static let characterSceneSize = CGSize(width: 100, height: 100)
    static let spriteViewSize = CGSize(width: 200, height: 200)
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase

    @Binding var hasSeenIntro: Bool

    @State private var selectedTab: AppTab = .work

    // 게임 세션 관리
    @State private var workGameSession = WorkGameSession()

    @State private var showCareerPopup: Bool = false
    @State private var careerSystem: CareerSystem?
    @State private var showQuizView: Bool = false
    @State private var showSettingsView: Bool = false

    @State private var storePopup: StorePopup? = nil
    @State private var noticePopup: NoticePopup? = nil

    // 음료 광고 팝업 관련
    @State private var showDrinkAdPopup: Bool = false
    @State private var showRewardToast: Bool = false
    @State private var rewardToastMessage: String = ""
    @State private var selectedDrinkType: ConsumableType?

    // 스킬 광고 보상 지속시 남은 시간
    @State private var skillAdRewardNow = Date()

    // 오프라인 보상 팝업 관련
    @State private var showOfflineRewardPopup: Bool = false
    @State private var offlineRewardGold: Int = 0
    @State private var offlineRewardHours: Double = 0.0
    @State private var showOfflineRewardToast: Bool = false
    @State private var offlineRewardToastMessage: String = ""
    @State private var hasCheckedOfflineReward: Bool = false
    @State private var tabbarAnchorY: CGFloat = 0
    @State private var bottomAnchorY: CGFloat = 0

    // 레벨업 이펙트 관련
    @State private var isCareerSystemInitialized: Bool = false
    @State private var showLevelUpEffect: Bool = false
    @State private var previousCareer: Career? = nil
    @State private var leveledUpCareer: Career? = nil

    // 시나리오 관련
    @State private var scenarioManager: ScenarioManager?
    @State private var showScenarioView: Bool = false
    private let scenarioRepository: ScenarioRepository = DefaultScenarioRepository()

    private var autoGainSystem: AutoGainSystem
    private let user: User
    private let scene: CharacterScene
    private let animationSystem: CharacterAnimationSystem

    init(user: User, hasSeenIntro: Binding<Bool>) {
        self._hasSeenIntro = hasSeenIntro
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
        VStack(spacing: TokenSpacing.none) {
            gameViewport
            tabBar
            contentsPanel
        }
        .ignoresSafeArea(edges: [.top, .bottom])
        .background(Color.beige200)
        .onAppear(perform: setupOnAppear)
        .task {
            await updateSkillAdRewardTimer()
        }
        .onDisappear { SoundService.shared.stopBGM() }
        .onChange(of: scenePhase, handleScenePhaseChange)
        .onChange(of: user.record.totalEarnedMoney) {
            careerSystem?.updateCareer()
        }
        .overlay { overlayView }
        .overlay {
            if showLevelUpEffect {
                LevelUpEffectView(
                    isPresented: $showLevelUpEffect,
                    previousCareerTitle: previousCareer?.rawValue ?? "",
                    currentCareerTitle: leveledUpCareer?.rawValue ?? ""
            )
            .transition(.opacity.animation(.easeIn))
            }
        }
        .onChange(of: showLevelUpEffect) { oldValue, newValue in
            if oldValue == true && newValue == false {
                Task {
                    await checkAndStartScenario()
                }
            }
        }
        .fullScreenCover(isPresented: $showQuizView) {
            QuizGameView(user: user)
        }
        .duToast(
            isShowing: $showOfflineRewardToast,
            message: offlineRewardToastMessage,
            anchorY: tabbarAnchorY
        )
        .duToast(
            isShowing: $showRewardToast,
            message: rewardToastMessage,
            anchorY: bottomAnchorY
        )
    }
}

private extension MainView {
    var gameViewport: some View {
        VStack(spacing: TokenSpacing.none) {
            // StatusBar Area
            StatusBar(
                imageName: careerSystem?.currentCareer.imageName ?? "",
                careerName: careerSystem?.currentCareer.rawValue ?? "",
                nickname: user.nickname,
                careerProgress: careerSystem?.careerProgress ?? 0,
                gold: user.wallet.gold.formatted,
                diamond: user.wallet.diamond.formatted,
                time: SkillAdRewardManager.remainingTimeText(user: user, now: skillAdRewardNow)
            )
            .background(Color.white300StatusBar)
            .onTapGesture { showCareerPopup = true }
            // SettingButton, QuizButton Area
            HStack {
                SmallButton(type: .setting) {
                    showSettingsView = true
                }
                Spacer()
                if !workGameSession.isInProgress {
                    SmallButton(type: .quiz) {
                        showQuizView = true
                    }
                }
            }
            Spacer()
            // character Area
            SpriteView(scene: scene, options: [.allowsTransparency])
                .frame(width: Constant.spriteViewSize.width, height: Constant.spriteViewSize.height)
                .background(Color.clear)
        }
        .background(housingBackgroundView)
        .clipped()
    }

    var tabBar: some View {
        Tabbar(
            selectedIndex: Binding(
                get: { AppTab.allCases.firstIndex(of: selectedTab) ?? 0 },
                set: { handleTabTap(AppTab.allCases[$0]) }
            ),
            hasCompletedMission: user.record.missionSystem.hasCompletedMission
        )
        .padding(.vertical, TokenSpacing.md)
        .padding(.horizontal, TokenGrid.paddingSide)
        .background(GeometryReader { geo in
            Color.clear.onAppear {
                tabbarAnchorY = geo.frame(in: .global).minY
            }
        })
    }

    var housingBackgroundView: some View {
        Image(user.inventory.housing.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }

    var contentsPanel: some View {
        ZStack {
            if workGameSession.isInProgress {
                workGameOverlayView
            }
            if !workGameSession.isInProgress || selectedTab != .work {
                tabContentSwitchView
            }
        }
        .background(GeometryReader { geo in
            Color.clear.onAppear {
                bottomAnchorY = geo.frame(in: .global).maxY - TokenGrid.paddingBottom
            }
        })
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
                    showExitBonusPopup: workGameSession.exitBonusPopupBinding,
                    selectedDrinkType: $selectedDrinkType,
                    resumeGameCallback: workGameSession.resumeGameBinding,
                    exitGameCallback: workGameSession.exitGameBinding
                )
            }
        case .skill:
            SkillView(
                user: user,
                careerSystem: careerSystem,
                noticePopup: $noticePopup,
                adRewardNow: skillAdRewardNow
            )
        case .shop:
            ShopView(user: user, storePopup: $storePopup, noticePopup: $noticePopup)
        case .mission:
            MissionView(user: user)
        }
    }

    @ViewBuilder
    var overlayView: some View {
        ZStack {
            popupOverlayView
                .ignoresSafeArea()
            settingsOverlayView
            drinkAdPopupOverlayView
            exitBonusPopupOverlayView
            offlineRewardPopupOverlayView
            scenarioOverlayView
            shopPopupOverlayView
        }
    }

    @ViewBuilder
    var scenarioOverlayView: some View {
        if showScenarioView, let manager = scenarioManager {
            ScenarioStoryView(
                user: user,
                manager: manager,
                repository: scenarioRepository
            ) {
                let isRebirth = manager.currentScenario?.scenarioType == .rebirth
                manager.completeScenario()

                showScenarioView = false

                if isRebirth {
                    hasSeenIntro = false
                }
            }
            .ignoresSafeArea()
            .transition(.opacity.animation(.easeIn))
        }
    }

    @ViewBuilder
    var popupOverlayView: some View {
        if let careerSystem, showCareerPopup {
            CareerPopupView(careerSystem: careerSystem, user: user) {
                showCareerPopup = false
            }
        }
    }

    @ViewBuilder
    var settingsOverlayView: some View {
        if showSettingsView {
            modalOverlay(onBackgroundTap: { showSettingsView = false }) {
                FeedbackSettingView(onClose: { showSettingsView = false })
            }
        }
    }

    func setupOnAppear() {
        SoundService.shared.playBGM()
        skillAdRewardNow = Date()
        autoGainSystem.startSystem()

        // 오프라인 보상 체크
        Task {
            await checkOfflineReward()
        }

        if careerSystem == nil {
            careerSystem = CareerSystem(user: user)
            isCareerSystemInitialized = true
            careerSystem?.onCareerChanged = { [weak scene] oldCareer, newCareer in
                scene?.updateCareerAppearance(to: newCareer)
                previousCareer = oldCareer
                leveledUpCareer = newCareer

                showLevelUpEffect = newCareer != .unemployed
            }
        }
        // 저장된 시나리오 복구 체크
        restoreScenarioIfNeeded()
        // 대기 중인 레벨업 이펙트 복구 체크
        checkPendingLevelUp()
    }

    @MainActor
    func checkPendingLevelUp() {
        // 이미 시나리오가 떠 있거나 레벨업 이펙트가 진행 중이면 리턴
        guard !showScenarioView && !showLevelUpEffect else { return }

        // 큐에 대기 중인 레벨업 커리어가 있다면 이펙트 다시 표시
        if let pendingCareer = user.record.scenarioProgress.levelupQueue.first {
            previousCareer = user.career
            leveledUpCareer = pendingCareer
            showLevelUpEffect = pendingCareer != .unemployed
        }
    }

    @MainActor
    func restoreScenarioIfNeeded() {
        guard !showScenarioView, let career = user.record.scenarioProgress.currentCareer else { return }

        if let scenario = scenarioRepository.fetchScenario(for: career) {
            let manager = ScenarioManager(record: user.record)

            manager.restoreScenario(scenario)
            self.scenarioManager = manager
            showScenarioView = true
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
    func checkAndStartScenario() async {
        guard let career = user.record.scenarioProgress.dequeueLevelUp() else { return }

        if let scenario = scenarioRepository.fetchScenario(for: career) {
            let manager = ScenarioManager(record: user.record)
            manager.startScenario(scenario)
            self.scenarioManager = manager
            showScenarioView = true
        }
    }

    @MainActor
    func updateSkillAdRewardTimer() async {
        while !Task.isCancelled {
            skillAdRewardNow = Date()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
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

    func handleTabTap(_ newTab: AppTab) {
        guard selectedTab != newTab else { return }

        if workGameSession.isInProgress && selectedTab == .work && newTab != .work {
            workGameSession.requestTabSwitch(to: newTab)
            return
        }

        selectedTab = newTab
    }

    @ViewBuilder
    var drinkAdPopupOverlayView: some View {
        if showDrinkAdPopup, let drinkType = selectedDrinkType {
            modalOverlay {
                NoticePopup(
                    type: .ad(
                        cancelText: "그냥 하기",
                        adText: "음료 받기",
                        cancelAction: handleSkipAdInMainView,
                        adAction: { Task { await handleWatchAdInMainView() } }
                    ),
                    title: drinkType == .coffee ? "커피 없음" : "박하스 없음",
                    text: "대신에 광고를 보고\n카페인을 보충할까요?"
                )
            }
        }
    }

    @ViewBuilder
    var exitBonusPopupOverlayView: some View {
        if workGameSession.showsExitBonusPopup {
            modalOverlay {
                NoticePopup(
                    type: .ad(
                        cancelText: "그냥 나가기",
                        adText: "보너스 받기",
                        cancelAction: handleExitWithoutBonus,
                        adAction: { Task { await handleExitBonusAd() } }
                    ),
                    title: "보너스",
                    text: "광고를 본다면 업무에서 얻은 재화만큼\n더 벌 수 있습니다"
                )
            }
        }
    }

    @ViewBuilder
    var shopPopupOverlayView: some View {
        if let popup = storePopup {
            modalOverlay(onBackgroundTap: { storePopup = nil }) {
                popup
            }
        }
        if let popup = noticePopup {
            modalOverlay(onBackgroundTap: { noticePopup = nil }) {
                popup
            }
        }
    }

    func modalOverlay<Content: View>(
        onBackgroundTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack {
            Color.black300PopUpDimStatusBar
                .onTapGesture {
                    onBackgroundTap?()
                }

            content()
        }
        .ignoresSafeArea()
    }

    func handleWatchAdInMainView() async {
        showDrinkAdPopup = false

        guard let drinkType = selectedDrinkType else { return }

        // 광고 시청
        let result = await AdService.shared.showAdWithResult(.interstitial)

        if result.success {
            // 보상 지급
            user.inventory.gain(consumable: drinkType)
            rewardToastMessage = "카페인 충전 완료!"
            showRewardToast = true
            selectedDrinkType = nil
            workGameSession.resumeGame?()
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

    func handleExitBonusAd() async {
        workGameSession.showsExitBonusPopup = false
        let result = await AdService.shared.showAdWithResult(.interstitial)
        if result.success {
            applyExitBonus()
        }
        exitWorkGame()
    }

    func handleExitWithoutBonus() {
        if let pendingTab = workGameSession.closeExitBonusPopupAndReturnPendingTab() {
            selectedTab = pendingTab
        }
        exitWorkGame()
    }

    func applyExitBonus() {
        let bonusGold = max(0, workGameSession.actionGoldDelta)
        if bonusGold > 0 {
            user.wallet.addGold(bonusGold)
            user.record.record(.earnMoney(bonusGold))
        }
        rewardToastMessage = bonusGold > 0 ?
                             "업무에서 얻은 보상 2배 획득!" :
                             "업무 보너스를 받을 재화가 없습니다."
        showRewardToast = true
    }

    func exitWorkGame() {
        workGameSession.exitGame?()
        workGameSession.isPauseRequested = false
        workGameSession.clearGameCallbacks()
    }

    // MARK: - Offline Reward

    @ViewBuilder
    var offlineRewardPopupOverlayView: some View {
        if showOfflineRewardPopup {
            modalOverlay {
                NoticePopup(
                    type: .ad(
                        cancelText: "안받기",
                        adText: "보상 받기",
                        cancelAction: {
                            handleOfflineRewardSkip()
                        },
                        adAction: {
                            Task { await handleOfflineRewardWatchAd() }
                        }
                    ),
                    title: "보상 획득",
                    text: "잠자는 시간 동안 '\(user.nickname)'가 일을 했습니다.\n일한 보상을 받을까요?"
                )
            }
        }
    }

    func checkOfflineReward() async {
        guard !AdService.shared.isShowing else { return }
        guard !hasCheckedOfflineReward else { return }

        hasCheckedOfflineReward = true

        let result = await OfflineRewardManager.checkAndAwardOfflineReward(user: user)

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

        let result = await AdService.shared.showAdWithResult(.interstitial)

        if result.success {
            user.wallet.addGold(offlineRewardGold)
            offlineRewardToastMessage = "잠자는 시간에 일한 보상 획득!"
            showOfflineRewardToast = true
        }
        offlineRewardGold = 0
        offlineRewardHours = 0.0
    }

    func handleOfflineRewardSkip() {
        showOfflineRewardPopup = false
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
    MainView(user: user, hasSeenIntro: .constant(true))
}
