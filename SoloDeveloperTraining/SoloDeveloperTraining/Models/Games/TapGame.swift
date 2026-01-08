//
//  TapGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

/// 탭 게임 클래스
final class TapGame: Game {
    /// 게임 종류
    var kind: GameType = .tap
    /// 사용자 정보
    var user: User
    /// 계산기
    var calculator: Calculator
    /// 피버 시스템
    var feverSystem: FeverSystem
    /// 버프 시스템
    var buffSystem: BuffSystem

    /// 탭 게임 초기화
    init(user: User, calculator: Calculator, feverSystem: FeverSystem, buffSystem: BuffSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
    }

    /// 게임 시작
    func startGame() {
        feverSystem.start()
    }

    /// 게임 종료
    func stopGame() {
        feverSystem.stop()
    }

    /// 탭 액션 수행 및 골드 획득
    @discardableResult
    func didPerformAction() async -> Int {
        feverSystem.gainFever(33)
        let gainGold = calculator.calculateGoldGained(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        user.wallet.addGold(gainGold)
        return gainGold
    }
}
