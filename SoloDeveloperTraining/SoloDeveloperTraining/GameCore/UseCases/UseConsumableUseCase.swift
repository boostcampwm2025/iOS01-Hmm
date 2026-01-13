//
//  UseConsumableUseCase.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/13/26.
//

final class UseConsumableUseCase {
    private let game: any Game

    init(game: any Game) {
        self.game = game
    }

    /// 소비 아이템 사용
    /// - Parameter type: 사용할 소비 아이템 타입
    /// - Returns: 사용 성공 여부
    func execute(type: ConsumableType) async -> Bool {
        let success = await game.user.inventory.drink(type)

        if success {
            game.buffSystem.useConsumableItem(type: type)
        }

        return success
    }

    /// 소비 아이템 개수 조회
    /// - Parameter type: 조회할 소비 아이템 타입
    /// - Returns: 보유 개수
    func count(type: ConsumableType) async -> Int {
        return await game.user.inventory.count(type) ?? 0
    }
}
