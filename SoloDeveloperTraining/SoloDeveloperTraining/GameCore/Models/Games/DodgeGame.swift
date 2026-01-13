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

    init(user: User, calculator: Calculator, feverSystem: FeverSystem, buffSystem: BuffSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
    }
    
    func startGame() {
        feverSystem.start()
    }
    
    func stopGame() {
        feverSystem.stop()
    }
    
    func didPerformAction() async -> Int {
        return 1
    }
}
