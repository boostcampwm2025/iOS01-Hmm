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

    // MARK: - Callbacks
    /// 골드 변화 시 호출되는 콜백 (골드 변화량 전달)
    var onGoldChanged: ((Int) -> Void)?

    // MARK: - Private Properties
    /// 플레이어 위치 동기화 타이머 (120fps)
    private var positionSyncTimer: Timer?

    // MARK: - Initialization

    /// DodgeGame 초기화
    /// - Parameters:
    ///   - user: 사용자 정보
    ///   - calculator: 골드 계산기
    ///   - feverSystem: 피버 시스템
    ///   - buffSystem: 버프 시스템
    ///
    /// 초기화 시 자동으로 수행되는 작업:
    /// - MotionSystem 및 DodgeGameCore 생성
    /// - 충돌 콜백 설정
    /// - 플레이어 위치 동기화 타이머 시작 (120fps)
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

    // MARK: - Public Methods

    /// 게임 시작
    /// - 피버 시스템 시작 (자동 감소 타이머 활성화)
    /// - 게임 코어 시작 (낙하물 생성 및 업데이트 타이머 활성화)
    func startGame() {
        feverSystem.start()
        gameCore.start()
    }

    /// 게임 중지
    /// - 피버 시스템 중지
    /// - 게임 코어 중지 (모든 타이머 정지 및 낙하물 제거)
    func stopGame() {
        feverSystem.stop()
        gameCore.stop()
    }

    /// 기본 액션 수행 (수동 탭 등)
    /// - 피버 33 증가
    /// - 스킬, 피버, 버프를 반영한 골드 계산
    /// - Returns: 획득한 기본 골드
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
    /// - Parameter type: 충돌한 아이템 타입
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

private extension DodgeGame {
    /// 충돌 콜백 핸들러 설정
    /// - gameCore의 onCollision 콜백에 아이템 충돌 처리 로직 연결
    /// - 골드 변화 시 onGoldChanged 콜백 호출
    func setupCollisionHandler() {
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

    /// 플레이어 위치 동기화 타이머 시작
    /// - MotionSystem의 characterX를 DodgeGameCore의 playerX에 동기화
    /// - 120fps 주기로 업데이트
    func startPlayerPositionSync() {
        positionSyncTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 120.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.gameCore.playerX = self.motionSystem.characterX
        }
    }
}
