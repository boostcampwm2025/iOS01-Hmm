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
            housing: .rooftop
        ),
        record: .init(),
        skills: [
            .init(game: .tap, tier: .beginner, level: 100),
            .init(game: .language, tier: .beginner, level: 100),
            .init(game: .dodge, tier: .beginner, level: 100),
            .init(game: .stack, tier: .beginner, level: 100)
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
