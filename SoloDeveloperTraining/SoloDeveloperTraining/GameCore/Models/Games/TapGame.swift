//
//  TapGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

private enum Constant {
    static let successFever: Double = 33.0
}

/// 탭 게임 클래스
final class TapGame: Game {
    typealias ActionInput = Void

    /// 게임 종류
    var kind: GameType
    /// 사용자 정보
    var user: User
    /// 피버 시스템
    var feverSystem: FeverSystem
    /// 버프 시스템
    var buffSystem: BuffSystem
    /// 캐릭터 애니메이션 시스템
    var animationSystem: CharacterAnimationSystem?
    /// 인벤토리
    let inventory: Inventory

    /// 탭 게임 초기화
    init(
        user: User,
        feverSystem: FeverSystem = FeverSystem(decreaseInterval: 0.1, decreasePercentPerTick: 3),
        buffSystem: BuffSystem,
        animationSystem: CharacterAnimationSystem? = nil
    ) {
        self.kind = .tap
        self.user = user
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
        self.animationSystem = animationSystem
        self.inventory = user.inventory
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
    func didPerformAction(_ input: Void = ()) async -> Int {
        feverSystem.gainFever(Constant.successFever)
        let gainGold = Calculator.calculateGoldPerAction(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        user.wallet.addGold(gainGold)
        /// 탭 횟수 기록
        user.record.record(.tap())
        /// 누적 재산 업데이트
        user.record.record(.earnMoney(gainGold))

        // 재화 획득 시 캐릭터 웃게 만들기
        animationSystem?.playSmile()
        return gainGold
    }
}
