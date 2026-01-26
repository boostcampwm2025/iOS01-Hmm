//
//  SoloDeveloperTrainingApp.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI

private enum Constant {
    enum Animation {
        static let duration: Double = 1.0
    }

    enum Padding {
        static let nicknamePopupHorizontal: CGFloat = 25
    }

    enum Opacity {
        static let overlay: Double = 0.5
    }
}

@main
struct SoloDeveloperTrainingApp: App {
    @State private var hasSeenIntro = false
    @State private var showNicknameSetup = false
    @State private var showTutorial = false
    @State private var user: User?
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
            .animation(.easeOut(duration: Constant.Animation.duration), value: hasSeenIntro)
            .overlay {
                nicknameSetupOverlay
            }
            .fullScreenCover(isPresented: $showTutorial) {
                TutorialView(isPresented: $showTutorial) {
                    user?.record.tutorialCompleted = true
                    hasSeenIntro = true
                    showTutorial = false
                }
                .onAppear {
                    Task {
                        try? await Task.sleep(nanoseconds: UInt64(Constant.Animation.duration * 1_000_000_000))
                        hasSeenIntro = true
                    }
                }
            }
            .onAppear {
                loadUser()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .background || newPhase == .inactive {
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
                print("Failed to load user: \(error)")
            }
        }
    }

    /// 현재 User를 저장합니다.
    func saveUser() {
        guard let user = user else { return }
        Task {
            do {
                try await userRepository.save(user)
            } catch {
                print("Failed to save user: \(error)")
            }
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
                        withAnimation(.easeOut(duration: Constant.Animation.duration)) {
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
}
#endif
