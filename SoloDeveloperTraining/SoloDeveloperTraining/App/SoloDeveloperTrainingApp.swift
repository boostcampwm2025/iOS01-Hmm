//
//  SoloDeveloperTrainingApp.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI

@main
struct SoloDeveloperTrainingApp: App {
    let user = User(
        nickname: "소피아",
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

    var body: some Scene {
        WindowGroup {
#if DEV_BUILD
            // Dev 타깃용 루트뷰
            ContentView()
#else
            // 운영 타깃용 뷰
            MainView(user: user)
#endif
        }
    }
}
