//
//  CheatManager.swift
//  SoloDeveloperTraining-Dev
//
//  Created by sunjae on 1/9/26.
//

import Foundation

enum CheatManager {
    static func performCheatingActions(game: TapGame, count: Int) async {
        /// 백그라운드에서 수행합니다.
        await Task.detached(priority: .userInitiated) {
            for _ in 0..<count {
                /// 비즈니스 로직을 수행합니다.
                _ = await game.didPerformAction(())
            }
        }.value
    }
}
