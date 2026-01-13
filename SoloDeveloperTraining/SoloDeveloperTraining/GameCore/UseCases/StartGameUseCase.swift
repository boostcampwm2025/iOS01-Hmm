//
//  StartGameUseCase.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/13/26.
//

final class StartGameUseCase {
    private let game: any Game

    init(game: any Game) {
        self.game = game
    }

    /// 게임 시작
    func execute() {
        game.startGame()
    }
}
