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
            let user = User(
                nickname: "donggle",
                wallet: .init(),
                inventory: .init(),
                record: <#T##Record#>
            )
        }
    }
}
