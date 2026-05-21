//
//  SoloDeveloperTrainingApp.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import KakaoSDKCommon

private enum Constant {
    enum Animation {
        static let transitionDuration: Double = 0.5  // 화면 전환
        static let blinkingDuration: Double = 1.0    // 깜빡임
    }

    enum Padding {
        static let nicknamePopupHorizontal: CGFloat = 25
        static let errorPopupVertical: CGFloat = 20
    }

    enum Opacity {
        static let overlay: Double = 0.5
    }
}

@main
struct SoloDeveloperTrainingApp: App {

    // Firebase 초기화
    init() {
        FirebaseApp.configure()
        MobileAds.shared.start()
        let kakaoAppKey = Bundle.main.kakaoAppKey
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }

    @State private var hasSeenIntro = false
    @State private var showNicknameSetup = false
    @State private var showTutorial = false
    @State private var user: User?
    @State private var showErrorPopup = false
    @State private var errorMessage: String = ""
    @Environment(\.scenePhase) private var scenePhase

    private let userRepository: UserRepository = FileManagerUserRepository()

    var body: some Scene {
        WindowGroup {
#if DEV_BUILD
            // Dev 타깃용 루트뷰
            ContentView()
#else
            // 운영 타깃용 뷰
            Group {
                if hasSeenIntro, let user {
                    MainView(user: user)
                        .transition(.opacity)
                } else {
                    IntroView(
                        hasSeenIntro: $hasSeenIntro,
                        showNicknameSetup: $showNicknameSetup,
                        user: user
                    )
                }
            }
            .animation(.easeOut(duration: Constant.Animation.transitionDuration), value: hasSeenIntro)
            .onOpenURL { url in
                print("\(url) app open")
            }
            .overlay {
                nicknameSetupOverlay
            }
            .overlay {
                errorPopupOverlay
            }
            .fullScreenCover(isPresented: $showTutorial) {
                TutorialView(isPresented: $showTutorial) {
                    user?.record.tutorialCompleted = true
                    hasSeenIntro = true
                    showTutorial = false
                }
                .onAppear {
                    Task {
                        try? await Task.sleep(nanoseconds: UInt64(Constant.Animation.transitionDuration * 1_000_000_000))
                        hasSeenIntro = true
                    }
                }
            }
            .onAppear {
                guard user == nil else { return }
                loadUser()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if oldPhase == .active && (newPhase == .background || newPhase == .inactive) {
                    saveUser()
                }
            }
#endif
        }
    }
}

#if !DEV_BUILD
private extension SoloDeveloperTrainingApp {
    /// 저장된 User를 로드합니다.
    func loadUser() {
        Task {
            do {
                if let loadedUser = try await userRepository.load() {
                    await MainActor.run {
                        self.user = loadedUser
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "사용자 데이터를 불러오는데 실패했습니다.\n\(error.localizedDescription)"
                    self.showErrorPopup = true
                }
            }
        }
    }

    /// 현재 User를 저장합니다.
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
            user.record.offlineRewardState.timeSource = "server"
            user.record.offlineRewardState.lastSystemUptime = nil
        } else {
            // 서버 시간 실패 -> 기기 시간 + systemUptime 저장
            let deviceTime = Date().timeIntervalSince1970
            user.record.offlineRewardState.lastExitTime = deviceTime
            user.record.offlineRewardState.timeSource = "device"
            user.record.offlineRewardState.lastSystemUptime = ProcessInfo.processInfo.systemUptime
        }
    }

    @ViewBuilder
    var nicknameSetupOverlay: some View {
        if showNicknameSetup {
            ZStack {
                Color.black.opacity(Constant.Opacity.overlay)
                    .ignoresSafeArea()

                NicknameSetupView(
                    onStart: { nickname in
                        user = User(nickname: nickname)
                        showNicknameSetup = false
                        withAnimation(.easeOut(duration: Constant.Animation.transitionDuration)) {
                            hasSeenIntro = true
                        }
                    },
                    onTutorial: { nickname in
                        user = User(nickname: nickname)
                        showNicknameSetup = false
                        showTutorial = true
                    }
                )
                .padding(.horizontal, Constant.Padding.nicknamePopupHorizontal)
            }
        }
    }

    @ViewBuilder
    var errorPopupOverlay: some View {
        if showErrorPopup {
            ZStack {
                Color.black.opacity(Constant.Opacity.overlay)
                    .ignoresSafeArea()

                Popup(title: "오류") {
                    VStack(spacing: 0) {
                        Text(errorMessage)
                            .textStyle(.body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, Constant.Padding.errorPopupVertical)

                        HStack(spacing: 0) {
                            Spacer()
                            MediumButton(title: "확인", isFilled: true) {
                                showErrorPopup = false
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, Constant.Padding.nicknamePopupHorizontal)
            }
        }
    }
}
#endif
