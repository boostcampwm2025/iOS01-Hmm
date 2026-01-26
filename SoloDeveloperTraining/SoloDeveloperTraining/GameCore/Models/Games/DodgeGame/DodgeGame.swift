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
    static let bugDodgeGainFever: Double = 10
    static let smallGoldMultiplier: Double = 1.5
    static let largeGoldMultiplier: Double = 2
    static let bugDodgeMultiplier: Double = 0.5
}

final class DodgeGame: Game {
    typealias ActionInput = DropItem.DropItemType

    /// 게임 종류
    var kind: GameType = .dodge
    /// 사용자 정보
    var user: User
    /// 피버 시스템
    var feverSystem: FeverSystem = FeverSystem(decreaseInterval: 1.0, decreasePercentPerTick: 30)
    /// 버프 시스템
    var buffSystem: BuffSystem = BuffSystem()
    /// 캐릭터 애니메이션 시스템
    var animationSystem: CharacterAnimationSystem?

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
        gameAreaSize: CGSize,
        onGoldChanged: @escaping (Int) -> Void,
        animationSystem: CharacterAnimationSystem? = nil
    ) {
        self.user = user
        self.onGoldChangedHandler = onGoldChanged
        self.animationSystem = animationSystem

        // 게임 시스템 초기화 (크기 필수 전달)
        self.motionSystem = MotionSystem(screenLimit: gameAreaSize.width / 2)
        self.gameCore = DodgeGameCore(screenWidth: gameAreaSize.width, screenHeight: gameAreaSize.height)

        // 충돌 콜백 설정
        gameCore.onCollision = { [weak self] itemType in
            guard let self = self else { return }
            Task {
                let goldDelta = await self.didPerformAction(itemType)
                await MainActor.run {
                    self.onGoldChangedHandler(goldDelta)
                }
            }
        }

        // 버그가 땅에 닿았을 때 콜백 설정
        gameCore.onBugReachedGround = { [weak self] in
            guard let self = self else { return }
            Task {
                let goldDelta = await self.didDodgeBug()
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
        buffSystem.stop()
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

    /// 버그 회피 성공 처리
    /// - Returns: 획득한 골드
    func didDodgeBug() async -> Int {
        // 피버 증가
        feverSystem.gainFever(Constant.bugDodgeGainFever)

        // 기본 골드 계산
        let baseGold = getBaseGold()

        // 1.0배 획득
        let gainGold = Int(Double(baseGold) * Constant.bugDodgeMultiplier)
        user.wallet.addGold(gainGold)
        /// 버그 회피 수 기록
        user.record.record(.dodgeGoldHit)
        /// 누적 재산 업데이트
        user.record.record(.earnMoney(gainGold))

        // 재화 획득 시 캐릭터 웃게 만들기
        animationSystem?.playSmile()
        return gainGold
    }

    /// 아이템 충돌 처리
    /// - Parameter type: 충돌한 아이템 타입
    /// - Returns: 획득/손실한 골드 (손실은 음수)
    func didPerformAction(_ input: DropItem.DropItemType) async -> Int {
        switch input {
        case .smallGold:
            // 피버 증가
            feverSystem.gainFever(Constant.defaultGainFever)

            // 기본 골드 계산
            let baseGold = getBaseGold()

            // 0.8배 획득
            let gainGold = Int(Double(baseGold) * Constant.smallGoldMultiplier)
            user.wallet.addGold(gainGold)
            /// 골드 획득 수 기록
            user.record.record(.dodgeGoldHit)
            /// 누적 재산 업데이트
            user.record.record(.earnMoney(gainGold))

            // 재화 획득 시 캐릭터 웃게 만들기
            animationSystem?.playSmile()
            return gainGold

        case .largeGold:
            // 피버 증가
            feverSystem.gainFever(Constant.defaultGainFever)

            // 기본 골드 계산
            let baseGold = getBaseGold()

            // 1.2배 획득
            let gainGold = Int(Double(baseGold) * Constant.largeGoldMultiplier)
            user.wallet.addGold(gainGold)
            /// 골드 획득 수 기록
            user.record.record(.dodgeGoldHit)
            /// 누적 재산 업데이트
            user.record.record(.earnMoney(gainGold))

            // 재화 획득 시 캐릭터 웃게 만들기
            animationSystem?.playSmile()
            return gainGold

        case .bug:
            // 피버 감소
            feverSystem.gainFever(Constant.bugGainFever)

            // 기본 골드 계산
            let baseGold = getBaseGold()

            // 절반 손실
            let loseGold = baseGold / 2
            user.wallet.spendGold(loseGold)
            /// 골드 손실 수 기록
            user.record.record(.dodgeFail)
            return -loseGold
        }
    }
}

private extension DodgeGame {
    func getBaseGold() -> Int {
        let baseGold = Calculator.calculateGoldPerAction(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        return baseGold
    }
}
