//
//  StackGameScene.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/15/26.
//

import SwiftUI
import SpriteKit

private enum Constant {
    enum Physics {
        static let gravity = CGVector(dx: 0, dy: -9.8)
    }

    enum Offset {
        // 최상단에서 블록을 살짝 안쪽으로 내려서 생성하기 위한 여백
        static let spawnYOffset: CGFloat = 24
    }

    enum Time {
        // 폭탄 블록 제거 딜레이 (초)
        static let bombRemovalDelay: TimeInterval = 0.8
        // 카메라 이동 애니메이션 시간 (초)
        static let cameraMoveAnimationDuration: TimeInterval = 0.3
        // 다음 블록 생성 딜레이 (초)
        static let nextBlockSpawnDelay: TimeInterval = 0.3
        // 실패한 블록 제거 딜레이 (초)
        static let failedBlockRemovalDelay: TimeInterval = 1.0
    }
}

final class StackGameScene: SKScene {
    private let stackGame: StackGame

    private var currentBlockView: BlockItem?
    /// 현재 고정된 블록 스택
    private var blockViews: [BlockItem] = []
    /// 첫 블록의 바닥 기준 높이
    private var currentHeight: CGFloat = 0
    /// 블록을 떨어트릴 수 있는지 (사용자 인터랙션 차단)
    private var isInteractionLocked = false
    /// 떨어지는 블록을 확인하고 있는지 (update 메서드 제어용)
    private var isCheckingFall = false
    /// 자체 게임 상태 관리 변수
    private var isGamePaused = false

    var onBlockDropped: ((Int) -> Void)

    init(stackGame: StackGame, onBlockDropped: @escaping ((Int) -> Void)) {
        self.stackGame = stackGame
        self.onBlockDropped = onBlockDropped
        super.init(size: .zero)
        self.scaleMode = .resizeFill
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func didMove(to view: SKView) {
        // 화면 크기를 게임 코어에 전달
        stackGame.screenSize = size
        setupScene()
        startGame()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentBlockView != nil, !isInteractionLocked, !isGamePaused else {
            return
        }
        dropBlock()
    }

    /// 매 프레임마다 실행되며, 물리 계산이 끝난 이후 블록의 위치를 판단합니다.
    override func didSimulatePhysics() {
        guard isCheckingFall, !isGamePaused else { return }

        guard let block = currentBlockView,
              let previousBlock = stackGame.previousBlock else { return }

        // 목표 지점 Y 높이 계산
        let targetY = previousBlock.positionY + previousBlock.height

        // 3. 목표 높이 도달 체크
        if block.position.y <= targetY {
            // 다음 로직을 타기 전에 플래그로 막아, 다음 update 함수의 실행을 차단합니다.
            isCheckingFall = false

            // 정렬 및 배치 처리 실행
            checkAlignmentAndHandle(targetY: targetY)
        }
    }

    /// 게임을 시작하고 초기 상태로 설정합니다.
    /// - 블록 배열 초기화
    /// - 게임 코어 시작 처리
    /// - 카메라 위치 리셋
    /// - 초기 블록 배치 및 첫 번째 블록 생성
    func startGame() {
        blockViews = []
        currentHeight = 0
        isInteractionLocked = false

        stackGame.startGame()
        camera?.position = CGPoint(x: size.width / 2, y: size.height / 2)

        putInitialBlock()
        spawnBlock()
    }

    /// 게임을 중지하고 모든 진행중인 동작을 멈춥니다.
    /// - 게임 코어 중지 처리
    /// - 현재 블록의 모든 액션 제거
    /// - 물리 엔진 정지
    func stopGame() {
        stackGame.stopGame()
        isInteractionLocked = true
        physicsWorld.speed = 0

        // 1. 현재 조작 중인 블록 정리
        currentBlockView?.removeAllActions()
        currentBlockView?.removeFromParent()
        currentBlockView = nil

        // 2. 쌓여있는 모든 블록들 정리
        blockViews.forEach { block in
            block.removeAllActions() // 액션 제거
            block.physicsBody = nil // 물리 엔진 연결 끊기
            block.removeFromParent() // 부모와의 연결 제거
        }

        blockViews.removeAll()

        // 4. 카메라 액션 제거
        camera?.removeAllActions()
        camera?.removeFromParent()
    }

    /// 게임 Scene 일시정지
    func pauseGame() {
        stackGame.pauseGame()
        isGamePaused = true
        physicsWorld.speed = 0
        currentBlockView?.removeAllActions()
        currentBlockView?.removeFromParent()
        currentBlockView = nil
        isCheckingFall = false
    }

    /// 게임 Scene 재개
    func resumeGame() {
        stackGame.resumeGame()
        isGamePaused = false
        physicsWorld.speed = 1
        if currentBlockView == nil {
            spawnBlock()
        }
    }
}

// MARK: - 씬, 카메라 초기화 함수
private extension StackGameScene {
    /// 씬의 초기 설정을 수행합니다.
    /// - 배경색을 앱 테마 배경색으로 설정
    /// - 물리 엔진의 중력 설정
    /// - 카메라 초기화
    private func setupScene() {
        backgroundColor = UIColor(AppTheme.backgroundColor)
        physicsWorld.gravity = Constant.Physics.gravity

        setupCamera()
    }

    /// 카메라 노드를 생성하고 초기 위치를 설정합니다.
    private func setupCamera() {
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cameraNode)
        camera = cameraNode
    }

}

// MARK: - 블록 처리 관련 함수
private extension StackGameScene {
    /// 게임 시작 시 가장 아래에 배치되는 초기 블록을 생성합니다.
    /// - 고정된 물리 바디를 가진 파란색 블록 생성
    /// - 게임 코어에 초기 블록 등록
    func putInitialBlock() {
        let firstBlockView = BlockItem(type: .blue)
        firstBlockView.setupPhysicsBody()
        firstBlockView.position = CGPoint(x: size.width / 2, y: currentHeight)

        // 게임 코어에 초기 블록 등록
        stackGame.addInitialBlock()

        addChild(firstBlockView)
        blockViews.append(firstBlockView)
    }

    /// 새로운 블록을 화면 상단에 생성하고 좌우로 움직이게 합니다.
    /// - 랜덤한 타입의 블록 생성
    /// - 카메라 기준 상단 위치에서 생성
    /// - 좌우 이동 애니메이션 시작
    func spawnBlock() {
        // 일시정지 상태에서는 동작을 막음
        guard !isGamePaused else { return }

        isInteractionLocked = false

        let blockType = BlockType.allCases.randomElement() ?? .blue
        let blockView = BlockItem(type: blockType)

        // 게임 코어에 블록 생성 알림
        stackGame.spawnBlock(type: blockType)

        let spawnY = (camera?.position.y ?? size.height / 2) + size.height / 2 - (
            Constant.Offset.spawnYOffset + blockView.size.height / 2)
        let leftEdge = blockView.size.width / 2
        let rightEdge = size.width - blockView.size.width / 2

        blockView.position = CGPoint(x: leftEdge, y: spawnY)
        blockView.startMoving(distance: rightEdge - leftEdge)

        currentBlockView = blockView
        addChild(blockView)
    }

    /// 현재 블록의 이동을 멈추고 중력을 적용하여 떨어뜨립니다.
    /// - 블록의 좌우 이동 중지
    /// - 중력 활성화
    /// - 블록 평가 시작
    func dropBlock() {
        guard let block = currentBlockView else { return }

        isInteractionLocked = true
        block.stopMoving()
        block.enableGravity()

        // 블록 위치 추적 시작
        isCheckingFall = true
    }

    /// 정렬을 체크하고 결과에 따라 물리 처리를 다르게 적용합니다.
    /// - 성공: 블록 고정 후 배치
    /// - 실패: 물리를 유지하여 자연스럽게 떨어지도록
    func checkAlignmentAndHandle(targetY: CGFloat) {
        guard let block = currentBlockView else { return }

        // 현재 블록 위치를 게임 모델에 업데이트
        stackGame.updateCurrentBlockPosition(positionX: block.position.x, positionY: targetY)

        let isAligned = stackGame.checkAlignment()

        if isAligned {
            // 정렬 성공: 블록 고정
            block.physicsBody?.velocity = .zero
            block.physicsBody?.angularVelocity = 0
            block.fixPosition()
            block.position = CGPoint(x: block.position.x, y: targetY)
            isInteractionLocked = false

            placeBlockSuccess()
        } else {
            // 정렬 실패: 물리를 유지하여 계속 떨어지도록
            isInteractionLocked = false
            placeBlockFail()
        }
    }

    /// 블록이 성공적으로 배치되었을 때의 처리를 수행합니다.
    /// - 폭탄 블록: 패널티 적용 후 블록 제거
    /// - 일반 블록: 스택에 추가, 점수 증가, 보상 적용, 카메라 이동
    func placeBlockSuccess() {
        guard
            let block = currentBlockView,
            let currentBlock = stackGame.currentBlock,
            let previousView = blockViews.last
        else { return }

        // 이전 블록의 정확한 위치를 기준으로 배치
        let targetY = previousView.position.y + previousView.size.height
        block.position = CGPoint(x: block.position.x, y: targetY)

        // currentHeight 업데이트
        currentHeight = targetY + block.size.height

        // 폭탄 블록 체크
        if currentBlock.type.isBomb {
            onBlockDropped(stackGame.placeBombSuccess())
            SoundService.shared.trigger(.bombStack)
            HapticService.shared.trigger(.error)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constant.Time.bombRemovalDelay) { [weak self] in
                block.removeFromParent()
                self?.spawnBlock()
            }
        } else {
            blockViews.append(block)
            // 코어에 블록 배치 성공 알림 (위치는 이미 업데이트됨)
            onBlockDropped(stackGame.placeBlockSuccess())
            SoundService.shared.trigger(.blockStack)
            // 카메라 이동
            if let camera = camera {
                let newCameraY = camera.position.y + block.size.height
                let moveCamera = SKAction.moveTo(y: newCameraY, duration: Constant.Time.cameraMoveAnimationDuration)
                moveCamera.timingMode = .easeInEaseOut
                camera.run(moveCamera)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + Constant.Time.nextBlockSpawnDelay) { [weak self] in

                self?.spawnBlock()
            }
        }
        currentBlockView = nil
    }

    /// 블록 배치에 실패했을 때의 처리를 수행합니다.
    /// - 폭탄 블록: 실패시 오히려 보상 적용
    /// - 일반 블록: 패널티 적용
    /// - 물리 효과로 떨어지고 화면 밖으로 나가면 제거
    func placeBlockFail() {
        guard
            let block = currentBlockView,
            let currentBlock = stackGame.currentBlock
        else { return }

        // 폭탄 블록 실패 = 보상, 일반 블록 실패 = 패널티
        if currentBlock.type.isBomb {
            onBlockDropped(stackGame.placeBombFail())
            SoundService.shared.trigger(.blockDrop)
        } else {
            onBlockDropped(stackGame.placeBlockFail())
            SoundService.shared.trigger(.blockDrop)
            HapticService.shared.trigger(.error)
        }

        // 일정 시간 후 블록 제거 및 다음 블록 생성
        DispatchQueue.main.asyncAfter(deadline: .now() + Constant.Time.failedBlockRemovalDelay) { [weak self] in
            block.removeFromParent()
            self?.spawnBlock()
        }

        currentBlockView = nil
    }
}
