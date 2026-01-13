//
//  PerformGameActionUseCase.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/13/26.
//

final class PerformGameActionUseCase {
    private let game: any Game

    init(game: any Game) {
        self.game = game
    }

    /// 게임 액션 수행, 획득한 골드 반환
    func execute() async -> Int {
        return await game.didPerformAction()
    }
}
