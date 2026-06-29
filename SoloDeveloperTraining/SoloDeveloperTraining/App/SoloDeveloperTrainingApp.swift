//
//  SoloDeveloperTrainingApp.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

#if canImport(AppsFlyerLib)
import AppsFlyerLib
#endif
import SwiftUI
import FirebaseCore
import GoogleMobileAds
import KakaoSDKCommon

import DUDesignSystem

@main
struct SoloDeveloperTrainingApp: App {

    init() {
        FirebaseApp.configure()

        MobileAds.shared.start()

        let kakaoAppKey = Bundle.main.kakaoAppKey
        KakaoSDK.initSDK(appKey: kakaoAppKey)

#if canImport(AppsFlyerLib)
        AppsFlyerLib.shared().initialize(
            devKey: Bundle.main.appsFlyerDevKey,
            appId: "6758282441"
        )
        AppsFlyerLib.shared().delegate = AppsFlyerDelegate.shared
        AppsFlyerLib.shared().start()
#endif
    }

    @State private var user: User?
    @State private var legacyUserType: RewardUserType? = nil

    @State private var hasSeenIntro = false
    @State private var showNicknameSetup = false
    @State private var showErrorPopup = false
    @State private var errorMessage: String = ""
    @State private var isPolicyLoading = true
    @State private var hasPolicyError = false
    @State private var updateType: AppUpdateType = .none
    @Environment(\.scenePhase) private var scenePhase

    private let userRepository: UserRepository = FileManagerUserRepository()
    private let scenarioRepository: ScenarioRepository = DefaultScenarioRepository()

    var body: some Scene {
        WindowGroup {
#if DEV_BUILD
            ContentView()
                .task { try? await policyStore.initialize() }
#else
            gameContent
                .task { await loadPolicy() }
#endif
        }
    }
}

#if !DEV_BUILD
private extension SoloDeveloperTrainingApp {

    // MARK: - 게임 콘텐츠

    @ViewBuilder
    var gameContent: some View {
        Group {
            if hasSeenIntro, let user {
                MainView(
                    user: user,
                    userType: legacyUserType ?? .newUser,
                    hasSeenIntro: $hasSeenIntro,
                    scenarioRepository: scenarioRepository
                )
                .fadeInSlow(isVisible: hasSeenIntro)
            } else if hasSeenIntro, user == nil, showNicknameSetup {
                NicknameSetupView { nickname in
                    let newUser = User(nickname: nickname)
                    user = newUser
                    checkFirstOpen(user: newUser)
                    user?.record.tutorialCompleted = true
                    hasSeenIntro = true
                    showNicknameSetup = false
                }
            } else {
                IntroView(
                    hasSeenIntro: $hasSeenIntro,
                    showNicknameSetup: $showNicknameSetup,
                    user: user,
                    scenarioRepository: scenarioRepository,
                    isPolicyReady: !isPolicyLoading && !hasPolicyError,
                    hasPolicyError: hasPolicyError,
                    onRetry: { Task { await loadPolicy() } }
                )
            }
        }
        .onOpenURL { url in
            guard let deeplinkInfo = parseOpenURL(url) else { return }

            AnalyticsService.shared
                .logAppOpenedFromDeeplink(
                    entrySource: deeplinkInfo.entrySource,
                    referrerShareID: deeplinkInfo.referrerShareID,
                    isDeferredDeeplink: false,
                    resultID: deeplinkInfo.resultID
                )
        }
        .duPopup(isPresented: showErrorPopup) {
            errorPopupOverlay
        }
        .duPopup(isPresented: updateType != .none) {
            updateOverlay
        }
        .task {
            let type = await AppUpdateChecker.checkUpdate()
            if type == .force {
                updateType = .force
            } else if type == .optional && !AppUpdateChecker.isOptionalUpdateSnoozed() {
                updateType = .optional
            }
        }
        .onAppear {
            guard user == nil else { return }
            loadUser()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                saveUser()
            }
        }
    }

    // MARK: - Async

    func loadPolicy() async {
        isPolicyLoading = true
        hasPolicyError = false
        do {
            try await policyStore.initialize()
            isPolicyLoading = false
        } catch {
            isPolicyLoading = false
            hasPolicyError = true
        }
    }

    func loadUser() {
        Task {
            do {
                switch try await userRepository.load() {
                case .current(let user):
                    await MainActor.run {
                        self.user = user
                        checkFirstOpen(user: user)
                    }
                case .legacy(let career):
                    await MainActor.run {
                        legacyUserType = .originUser(career ?? .unemployed)
                    }
                case .empty:
                    break
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "사용자 데이터를 불러오는데 실패했습니다.\n\(error.localizedDescription)"
                    self.showErrorPopup = true
                }
            }
        }
    }

    func saveUser() {
        guard let user = user else { return }
        Task {
            // 앱 종료 시 시간 기록
            await recordExitTime(for: user)

            do {
                try await userRepository.save(user)
            } catch {
                await MainActor.run {
                    self.errorMessage = "사용자 데이터를 저장하는데 실패했습니다.\n\(error.localizedDescription)"
                    self.showErrorPopup = true
                }
            }
        }
    }

    /// 앱 종료 시 시간 기록
    @MainActor
    func recordExitTime(for user: User) async {
        // 서버 시간 조회 시도
        if let serverTime = try? await TimeService.fetchCurrentTime() {
            // 서버 시간 저장 성공
            user.record.offlineRewardState.lastExitTime = serverTime
            user.record.offlineRewardState.timeSource = .server
            user.record.offlineRewardState.lastSystemUptime = nil
        } else {
            // 서버 시간 실패 -> 기기 시간 + systemUptime 저장
            let deviceTime = Date().timeIntervalSince1970
            user.record.offlineRewardState.lastExitTime = deviceTime
            user.record.offlineRewardState.timeSource = .device
            user.record.offlineRewardState.lastSystemUptime = ProcessInfo.processInfo.systemUptime
        }
    }

    // MARK: - Overlays

    @ViewBuilder
    var updateOverlay: some View {
        if updateType == .force {
            NoticePopup(
                type: .default(
                    buttonText: "업데이트",
                    action: { AppUpdateChecker.openAppStore() }
                ),
                title: "업데이트 안내",
                text: "원활한 앱 사용을 위해서 업데이트가 필요합니다.\n지금 바로 업데이트를 진행해주세요."
            )
        } else if updateType == .optional {
            NoticePopup(
                type: .confirm(
                    cancelText: "다음에",
                    confirmText: "업데이트",
                    cancelAction: {
                        AppUpdateChecker.snoozeOptionalUpdate()
                        updateType = .none
                    },
                    confirmAction: { AppUpdateChecker.openAppStore() }
                ),
                title: "업데이트 안내",
                text: "원활한 앱 사용을 위해서 업데이트가 필요합니다.\n지금 바로 업데이트를 진행해주세요."
            )
        }
    }

    var errorPopupOverlay: some View {
        NoticePopup(
            type: .default(buttonText: "확인", action: { showErrorPopup = false }),
            title: "오류",
            text: errorMessage
        )
    }
}
#endif

// MARK: - Helper

private extension SoloDeveloperTrainingApp {

    // MARK: - Analytics

    func checkFirstOpen(user: User) {
        guard AnalyticsKeychain.isNewInstall() else { return }
        AnalyticsKeychain.getOrCreateDeviceID()
        AnalyticsService.shared.logFirstOpen(level: user.career.level)
    }

    struct DeeplinkInfo {
        let entrySource: String
        let referrerShareID: String
        let resultID: String
    }

    func parseOpenURL(_ url: URL) -> DeeplinkInfo? {
        guard let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) else {
            return nil
        }

        let queryItems = components.queryItems ?? []

        guard
            let shareID = queryItems.first(where: { $0.name == "share_id" })?.value,
            let resultID = queryItems.first(where: { $0.name == "result_id" })?.value
        else {
            return nil
        }

        let entrySource = queryItems
            .first(where: { $0.name == "entry_source" })?
            .value ?? "unknown"

        return DeeplinkInfo(
            entrySource: entrySource,
            referrerShareID: shareID,
            resultID: resultID
        )
    }

}
