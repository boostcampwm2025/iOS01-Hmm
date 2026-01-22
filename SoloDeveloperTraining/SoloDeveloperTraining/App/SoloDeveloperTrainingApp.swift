//
//  SoloDeveloperTrainingApp.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI

@main
struct SoloDeveloperTrainingApp: App {
    @State private var hasSeenIntro = false
    @State private var user: User?
    @State private var showNicknameSetup = false
    @State private var showTutorial = false

    var body: some Scene {
        WindowGroup {
#if DEV_BUILD
            // Dev 타깃용 루트뷰
            ContentView()
#else
            // 운영 타깃용 뷰
            ZStack {
                IntroView(
                    hasSeenIntro: $hasSeenIntro,
                    showNicknameSetup: $showNicknameSetup,
                    user: user
                )
                .opacity(hasSeenIntro ? 0 : 1)

                // MainView가 위에서 페이드 인
                if hasSeenIntro {
                    if let user {
                        MainView(user: user)
                            .transition(.opacity)
                    }
                }
            }
            .animation(.easeOut(duration: 1), value: hasSeenIntro)
            .overlay {
                if showNicknameSetup {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()

                        NicknameSetupView(
                            onStart: { nickname in
                                user = createUser(nickname: nickname.isEmpty ? "개발자" : nickname)
                                showNicknameSetup = false
                                withAnimation(.easeOut(duration: 1)) {
                                    hasSeenIntro = true
                                }
                            },
                            onTutorial: { nickname in
                                user = createUser(nickname: nickname.isEmpty ? "개발자" : nickname)
                                showNicknameSetup = false
                                showTutorial = true
                            }
                        )
                        .padding(.horizontal, 25)
                    }
                }
            }
            .fullScreenCover(isPresented: $showTutorial) {
                TutorialView(isPresented: $showTutorial) {
                    showTutorial = false
                    withAnimation(.easeOut(duration: 1)) {
                        hasSeenIntro = true
                    }
                }
            }
#endif
        }
    }
}

func createUser(nickname: String) -> User {
    User(
        nickname: nickname,
        wallet: .init(),
        inventory: Inventory(
            equipmentItems: [
                .init(type: .chair, tier: .broken),
                .init(type: .keyboard, tier: .broken),
                .init(type: .monitor, tier: .broken),
                .init(type: .mouse, tier: .broken)
            ],
            housing: .init(tier: .rooftop)
        ),
        record: .init(),
        skills: [
            // 코드짜기
            .init(key: SkillKey(game: .tap, tier: .beginner)),
            .init(key: SkillKey(game: .tap, tier: .intermediate)),
            .init(key: SkillKey(game: .tap, tier: .advanced)),
            // 언어 맞추기
            .init(key: SkillKey(game: .language, tier: .beginner)),
            .init(key: SkillKey(game: .language, tier: .intermediate)),
            .init(key: SkillKey(game: .language, tier: .advanced)),
            // 버그 피하기
            .init(key: SkillKey(game: .dodge, tier: .beginner)),
            .init(key: SkillKey(game: .dodge, tier: .intermediate)),
            .init(key: SkillKey(game: .dodge, tier: .advanced)),
            // 물건 쌓기
            .init(key: SkillKey(game: .stack, tier: .beginner)),
            .init(key: SkillKey(game: .stack, tier: .intermediate)),
            .init(key: SkillKey(game: .stack, tier: .advanced))
        ]
    )
}
