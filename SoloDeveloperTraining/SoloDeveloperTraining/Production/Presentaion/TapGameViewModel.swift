//
//  TapGameViewModel.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/13/26.
//

import Foundation
import Observation

@Observable
final class TapGameViewModel {
    // MARK: - Use Cases
    private let startGameUseCase: StartGameUseCase
    private let stopGameUseCase: StopGameUseCase
    private let performGameActionUseCase: PerformGameActionUseCase
    private let useConsumableUseCase: UseConsumableUseCase

    // MARK: - System
    let feverState: FeverState

    // MARK: - UI State
    /// 마지막에 획득한 골드
    var lastGainedGold: Int
    /// 커피 보유 개수
    var coffeeCount: Int
    /// 에너지 드링크 보유 개수
    var energyDrinkCount: Int

    // MARK: - Initialization
    init(
        startGameUseCase: StartGameUseCase,
        stopGameUseCase: StopGameUseCase,
        performGameActionUseCase: PerformGameActionUseCase,
        useConsumableUseCase: UseConsumableUseCase,
        feverSystem: FeverState
    ) {
        self.startGameUseCase = startGameUseCase
        self.stopGameUseCase = stopGameUseCase
        self.performGameActionUseCase = performGameActionUseCase
        self.useConsumableUseCase = useConsumableUseCase
        self.feverState = feverSystem

        // 초기값 (onAppear에서 실제 데이터 로드)
        self.lastGainedGold = 0
        self.coffeeCount = 0
        self.energyDrinkCount = 0
    }

    // MARK: - Intents

    /// 게임 화면이 나타날 때 호출
    func onAppear() {
        // 게임 시작
        startGameUseCase.execute()

        // 초기 상태 로드
        Task {
            await loadConsumableItems()
        }
    }

    /// 화면 터치 시 호출
    func onTap() async {
        let gainedGold = await performGameActionUseCase.execute()
        lastGainedGold = gainedGold
    }

    /// 닫기 버튼 클릭 시 호출
    func onClose() {
        // 게임 종료
        stopGameUseCase.execute()
    }

    /// 커피 사용 버튼 클릭 시 호출
    func onUseCoffee() {
        Task {
            let success = await useConsumableUseCase.execute(type: .coffee)

            if success {
                await loadConsumableItems()
            }
        }
    }

    /// 에너지 드링크 사용 버튼 클릭 시 호출
    func onUseEnergyDrink() {
        Task {
            let success = await useConsumableUseCase.execute(type: .energyDrink)

            if success {
                await loadConsumableItems()
            }
        }
    }
}

// MARK: - Private Method
private extension TapGameViewModel {
    /// 소비 아이템 개수 로드
    private func loadConsumableItems() async {
        coffeeCount = await useConsumableUseCase.count(type: .coffee)
        energyDrinkCount = await useConsumableUseCase.count(type: .energyDrink)
    }
}
