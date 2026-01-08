//
//  CheatManager.swift
//  SoloDeveloperTraining-Dev
//
//  Created by sunjae on 1/9/26.
//

import Foundation

enum CheatManager {
    static func performCheatingActions(game: Game, count: Int) async {
        for _ in 0..<count {
            // 핵심 로직을 반복 호출하여 데이터와 업적 시스템을 한꺼번에 업데이트
            _ = await game.didPerformAction()
        }
    }
}
