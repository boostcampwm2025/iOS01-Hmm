//
//  DodgeGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

private enum Constant {
    static let defaultGainFever: Double = 33
    static let bugGainFever: Double = -50
    static let smallGoldMultiplier: Double = 0.8
    static let largeGoldMultiplier: Double = 1.2
}

final class DodgeGame: Game {
    /// 게임 종류
    var kind: GameType = .dodge
    /// 사용자 정보
    var user: User
    /// 골드 계산기
    var calculator: Calculator
    /// 피버 시스템
    var feverSystem: FeverSystem
    /// 버프 시스템
    var buffSystem: BuffSystem

    // MARK: - Game Systems
    /// 모션 시스템 (기기 기울기 감지 및 캐릭터 이동)
    let motionSystem: MotionSystem
    /// 게임 코어 시스템 (낙하물 생성, 충돌 감지)
    let gameCore: DodgeGameCore

    /// 플레이어 위치 동기화 타이머 (120fps)
    private var positionSyncTimer: Timer?
    /// 골드 변화 시 호출되는 콜백 핸들러
    private var onGoldChangedHandler: (Int) -> Void

    init(
        user: User,
        calculator: Calculator,
        feverSystem: FeverSystem,
        buffSystem: BuffSystem,
        gameAreaSize: CGSize,
        onGoldChanged: @escaping (Int) -> Void
    ) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
        self.onGoldChangedHandler = onGoldChanged

        // 게임 시스템 초기화 (크기 필수 전달)
        self.motionSystem = MotionSystem(screenLimit: gameAreaSize.width / 2)
        self.gameCore = DodgeGameCore(screenWidth: gameAreaSize.width, screenHeight: gameAreaSize.height)

        // 충돌 콜백 설정
        gameCore.onCollision = { [weak self] itemType in
            guard let self = self else { return }
            Task {
                let goldDelta = await self.handleItemCollision(type: itemType)
                await MainActor.run {
                    self.onGoldChangedHandler(goldDelta)
                }
            }
        }

        // 플레이어 위치 동기화 타이머 시작 (120fps)
        positionSyncTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 120.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.gameCore.playerX = self.motionSystem.characterX
        }
    }

    deinit {
        positionSyncTimer?.invalidate()
        positionSyncTimer = nil
    }

    /// 게임 시작 (피버 시스템 및 게임 코어 타이머 활성화)
    func startGame() {
        feverSystem.start()
        gameCore.start()
    }

    /// 게임 중지 (모든 타이머 정지 및 낙하물 제거)
    func stopGame() {
        feverSystem.stop()
        gameCore.stop()
    }

    /// 게임 영역 크기 업데이트 (화면 크기 변경 시 호출)
    func configure(gameAreaSize: CGSize) {
        gameCore.screenWidth = gameAreaSize.width
        gameCore.screenHeight = gameAreaSize.height
        motionSystem.screenLimit = gameAreaSize.width / 2
    }

    /// 골드 변화 콜백 핸들러 설정
    func setGoldChangedHandler(_ handler: @escaping (Int) -> Void) {
        self.onGoldChangedHandler = handler
    }

    /// 기본 액션 수행 (수동 탭 등)
    /// - Returns: 획득한 기본 골드
    func didPerformAction() async -> Int {
        feverSystem.gainFever(Constant.defaultGainFever)
        let baseGold = calculator.calculateGoldPerAction(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        return baseGold
    }

    /// 아이템 충돌 처리
    /// - Parameter type: 충돌한 아이템 타입
    /// - Returns: 획득/손실한 골드 (손실은 음수)
    func handleItemCollision(type: DropItem.DropItemType) async -> Int {
        switch type {
        case .smallGold:
            // 피버 증가
            feverSystem.gainFever(Constant.defaultGainFever)

            // 기본 골드 계산
            let baseGold = getBaseGold()

            // 0.8배 획득
            let gainGold = Int(Double(baseGold) * Constant.smallGoldMultiplier)
            await user.wallet.addGold(gainGold)
            return gainGold

        case .largeGold:
            // 피버 증가
            feverSystem.gainFever(Constant.defaultGainFever)

            // 기본 골드 계산
            let baseGold = getBaseGold()

            // 1.2배 획득
            let gainGold = Int(Double(baseGold) * Constant.largeGoldMultiplier)
            await user.wallet.addGold(gainGold)
            return gainGold

        case .bug:
            // 피버 감소
            feverSystem.gainFever(Constant.bugGainFever)

            // 기본 골드 계산
            let baseGold = getBaseGold()

            // 절반 손실
            let loseGold = baseGold / 2
            await user.wallet.spendGold(loseGold)
            return -loseGold
        }
    }
}

private extension DodgeGame {
    func getBaseGold() -> Int {
        let baseGold = calculator.calculateGoldPerAction(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        return baseGold
    }
}
