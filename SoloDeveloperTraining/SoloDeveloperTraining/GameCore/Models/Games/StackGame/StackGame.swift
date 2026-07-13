//
//  StackGame.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 1/14/26.
//

import Foundation

private enum Constant {
    enum Position {
        static let initialBlockYPosition: CGFloat = 20
    }
}

@Observable
final class StackGame: Game {
    typealias ActionInput = BlockType

    var kind: GameType = .stack
    var user: User
    var feverSystem: FeverSystem = .init(
        decreaseInterval: Policy.Fever.decreaseInterval,
        decreasePercentPerTick: Policy.Fever.Stack.decreasePercent
    )
    var buffSystem: BuffSystem = .init()
    var animationSystem: CharacterAnimationSystem?
    var screenSize: CGSize = .init(width: 0, height: 0)

    private(set) var score: Int = 0
    private(set) var currentBlock: StackBlock?
    private(set) var previousBlock: StackBlock?

    init(user: User, animationSystem: CharacterAnimationSystem? = nil) {
        self.user = user
        self.animationSystem = animationSystem
    }

    func startGame() {
        feverSystem.start()
        score = 0
        currentBlock = nil
        previousBlock = nil
    }

    func stopGame() {
        feverSystem.stop()
        buffSystem.stop()
    }

    /// 게임 일시정지 (피버, 버프 시스템 보존)
    func pauseGame() {
        feverSystem.pause()
        buffSystem.pause()
    }

    /// 게임 재개
    func resumeGame() {
        feverSystem.resume()
        buffSystem.resume()
    }

    /// 액션 수행 (Game 프로토콜 요구사항)
    @discardableResult
    func didPerformAction(_ input: BlockType) async -> Int { 0 }

    /// 초기 블록을 추가합니다
    /// 화면 크기를 기반으로 화면 중앙 하단에 배치합니다
    func addInitialBlock() {
        let blockType = BlockType.blue
        let initialBlock = StackBlock(
            type: blockType,
            positionX: screenSize.width / 2,
            positionY: Constant.Position.initialBlockYPosition
        )
        previousBlock = initialBlock
    }

    /// 떨어뜨릴 블록을 생성합니다
    func spawnBlock(type: BlockType) {
        currentBlock = StackBlock(
            type: type,
            positionX: 0,
            positionY: 0
        )
    }

    /// 블록 정렬 여부를 확인합니다
    func checkAlignment() -> Bool {
        guard
            let currentBlock = currentBlock,
            let previousBlock = previousBlock
        else { return false }

        let previousLeft = previousBlock.positionX - previousBlock.width / 2
        let previousRight = previousBlock.positionX + previousBlock.width / 2
        let previousRange = previousLeft...previousRight

        return previousRange.contains(currentBlock.positionX)
    }

    /// 현재 블록의 위치를 업데이트합니다
    func updateCurrentBlockPosition(positionX: CGFloat, positionY: CGFloat) {
        currentBlock?.positionX = positionX
        currentBlock?.positionY = positionY
    }

    /// 블록이 성공적으로 배치되었을 때 처리
    func placeBlockSuccess() -> Int {
        guard let block = currentBlock else { return 0 }

        previousBlock = block
        currentBlock = nil

        score += 1
        return applyReward()
    }

    /// 블록 배치에 실패했을 때 처리
    func placeBlockFail() -> Int {
        currentBlock = nil
        return applyPenalty()
    }

    /// 폭탄 블록이 성공적으로 배치되었을 때 처리 (패널티)
    func placeBombSuccess() -> Int {
        currentBlock = nil
        return applyPenalty()
    }

    /// 폭탄 블록 배치에 실패했을 때 처리 (보상)
    func placeBombFail() -> Int {
        currentBlock = nil
        return applyReward()
    }
}

private extension StackGame {
    /// 보상을 적용합니다 (골드 획득, 피버 증가)
    func applyReward() -> Int {
        let goldEarned = calculateGold()
        user.wallet.addGold(goldEarned)
        /// 성공 수 기록
        user.record.record(.stackingSuccess)
        /// 누적 재산 업데이트
        user.record.record(.earnMoney(goldEarned))
        feverSystem.gainFever(Policy.Fever.Stack.gainPerSuccess)

        // 재화 획득 시 캐릭터 웃게 만들기
        animationSystem?.playSmile()

        return goldEarned
        #if DEV_BUILD
            print("💰 골드 획득: \(goldEarned), 총액: \(user.wallet.gold)")
        #endif
    }

    /// 패널티를 적용합니다 (골드 손실, 피버 감소)
    func applyPenalty() -> Int {
        let goldLost = calculateGold()
        let didSpendGold = user.wallet.spendGold(goldLost)
        /// 실패 수 기록
        user.record.record(.stackingFail)
        feverSystem.gainFever(Policy.Fever.Stack.lossPerFailure)
        return didSpendGold ? -goldLost : 0
        #if DEV_BUILD
            print("💸 골드 손실: \(goldLost), 총액: \(user.wallet.gold)")
        #endif
    }

    /// 현재 상태에 따른 골드 획득량을 계산합니다
    func calculateGold() -> Int {
        return Calculator.calculateGoldPerAction(
            game: .stack,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
    }
}
