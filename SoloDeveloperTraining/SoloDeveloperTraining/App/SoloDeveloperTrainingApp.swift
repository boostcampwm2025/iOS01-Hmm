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
        static let transitionDuration: Double = 0.5
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
    @State private var isPolicyLoading = true
    @State private var hasPolicyError = false
    @Environment(\.scenePhase) private var scenePhase

    private let userRepository: UserRepository = FileManagerUserRepository()

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
                MainView(user: user)
                    .transition(.opacity)
            } else {
                IntroView(
                    hasSeenIntro: $hasSeenIntro,
                    showNicknameSetup: $showNicknameSetup,
                    user: user,
                    isPolicyReady: !isPolicyLoading && !hasPolicyError,
                    hasPolicyError: hasPolicyError,
                    onRetry: { Task { await loadPolicy() } }
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

    func saveUser() {
        guard let user = user else { return }
        Task {
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

    // MARK: - Overlays

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
