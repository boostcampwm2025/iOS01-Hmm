//
//  SoloDeveloperTrainingApp.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI

@main
struct SoloDeveloperTrainingApp: App {
    var body: some Scene {
        WindowGroup {
            #if DEV_BUILD
            // Dev 타깃용 루트뷰
            ContentView()
            #else
            // 운영 타깃용 뷰
            MainView()
            #endif
        }
    }
}
