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
            ContentView() // 이 파일이 Dev 타깃에만 있다면, 반드시 #if 안에 있어야 합니다.
            #else
            MainView()    // 운영 타깃용 뷰 (두 타깃 모두에 있는 파일이어야 함)
            #endif
        }
    }
}
