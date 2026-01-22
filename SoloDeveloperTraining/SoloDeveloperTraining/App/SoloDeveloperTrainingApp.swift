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
                    // TODO: 여기서 레코드에 튜리얼 완료 해 주기
                    showTutorial = false
                    withAnimation(.easeOut(duration: Constant.Animation.duration)) {
                        hasSeenIntro = true
                    }
                }
            }
#endif
        }
    }
}

private extension SoloDeveloperTrainingApp {
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

