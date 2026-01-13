//
//  StopGameUseCase.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/13/26.
//

final class StopGameUseCase {
    private let game: any Game

    init(game: any Game) {
        self.game = game
    }

    /// 게임 종료
    func execute() {
        game.stopGame()
    }
}
