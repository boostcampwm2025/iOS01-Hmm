//
//  DodgeGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class DodgeGame: Game {
    /// 게임 종류
    var kind: GameType = .dodge
    /// 사용자 정보
    var user: User
    /// 계산기
    var calculator: Calculator
    /// 피버 시스템
    var feverSystem: FeverSystem
    /// 버프 시스템
    var buffSystem: BuffSystem
    /// 모션 시스템
    let motionSystem: MotionSystem
    /// 게임 코어 시스템
    let gameCore: DodgeGameCore
    
    var onGoldChanged: ((Int) -> Void)?
    
    private var positionSyncTimer: Timer?

    init(user: User, calculator: Calculator, feverSystem: FeverSystem, buffSystem: BuffSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
        self.motionSystem = MotionSystem()
        self.gameCore = DodgeGameCore()

        // 충돌 콜백 설정
        setupCollisionHandler()
        // 플레이어 위치 동기화 타이머 시작
        startPlayerPositionSync()
    }
    
    deinit {
        positionSyncTimer?.invalidate()
        positionSyncTimer = nil
    }

    func startGame() {
        feverSystem.start()
        gameCore.start()
    }

    func stopGame() {
        feverSystem.stop()
        gameCore.stop()
    }

    private func setupCollisionHandler() {
        gameCore.onCollision = { [weak self] itemType in
            guard let self = self else { return }
            Task {
                let goldDelta = await self.handleItemCollision(type: itemType)
                await MainActor.run {
                    self.onGoldChanged?(goldDelta)
                }
            }
        }
    }

    private func startPlayerPositionSync() {
        positionSyncTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 120.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.gameCore.playerX = self.motionSystem.characterX
        }
    }

    func didPerformAction() async -> Int {
        // 기본 액션 수행 (피버 증가)
        feverSystem.gainFever(33)
        let baseGold = calculator.calculateGoldPerAction(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        return baseGold
    }

    /// 아이템 충돌 처리
    /// - Returns: 획득/손실한 골드 (손실은 음수)
    func handleItemCollision(type: DropItem.DropItemType) async -> Int {
        switch type {
        case .smallGold:
            // 피버 증가
            feverSystem.gainFever(33)
            let baseGold = calculator.calculateGoldPerAction(
                game: kind,
                user: user,
                feverMultiplier: feverSystem.feverMultiplier,
                buffMultiplier: buffSystem.multiplier
            )
            let gainGold = Int(Double(baseGold) * 0.8)
            await user.wallet.addGold(gainGold)
            return gainGold

        case .largeGold:
            // 피버 증가
            feverSystem.gainFever(33)
            let baseGold = calculator.calculateGoldPerAction(
                game: kind,
                user: user,
                feverMultiplier: feverSystem.feverMultiplier,
                buffMultiplier: buffSystem.multiplier
            )
            let gainGold = Int(Double(baseGold) * 1.2)
            await user.wallet.addGold(gainGold)
            return gainGold

        case .bug:
            // 피버 감소
            feverSystem.gainFever(-50)
            let baseGold = calculator.calculateGoldPerAction(
                game: kind,
                user: user,
                feverMultiplier: feverSystem.feverMultiplier,
                buffMultiplier: buffSystem.multiplier
            )
            let loseGold = baseGold / 2
            await user.wallet.spendGold(loseGold)
            return -loseGold
        }
    }
}
