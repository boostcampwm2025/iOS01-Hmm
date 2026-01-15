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
        static let spawnYOffset: CGFloat = 20
    }

    enum Time {
        // 블록 평가 체크 간격 (초)
        static let evaluationCheckInterval: TimeInterval = 0.05
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
    private var blockViews: [BlockItem] = []
    /// 첫 블록의 바닥 기준 높이
    private var currentHeight: CGFloat = 0
    /// 블록 배치 처리 중 여부 (UI 인터랙션 차단용)
    private var isProcessing = false

    init(stackGame: StackGame) {
        self.stackGame = stackGame
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
        guard currentBlockView != nil, !isProcessing else { return }
        dropBlock()
    }

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

    /// 게임을 시작하고 초기 상태로 설정합니다.
    /// - 블록 배열 초기화
    /// - 게임 코어 시작 처리
    /// - 카메라 위치 리셋
    /// - 초기 블록 배치 및 첫 번째 블록 생성
    func startGame() {
        blockViews = []
        currentHeight = 0
        isProcessing = false

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
        isProcessing = true
        currentBlockView?.removeAllActions()
        physicsWorld.speed = 0
    }

    /// 게임 시작 시 가장 아래에 배치되는 초기 블록을 생성합니다.
    /// - 고정된 물리 바디를 가진 파란색 블록 생성
    /// - 게임 코어에 초기 블록 등록
    private func putInitialBlock() {
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
    private func spawnBlock() {
        isProcessing = false

        let blockType = BlockType.allCases.randomElement() ?? .blue
        let blockView = BlockItem(type: blockType)

        // 게임 코어에 블록 생성 알림
        stackGame.spawnBlock(type: blockType)

        let spawnY = (camera?.position.y ?? size.height / 2) + size.height / 2 - Constant.Offset.spawnYOffset
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
    private func dropBlock() {
        guard let block = currentBlockView else { return }

        isProcessing = true
        block.stopMoving()
        block.enableGravity()

        // 블록 평가 시작
        evaluateBlock()
    }

    /// 떨어지는 블록이 목표 위치에 도달했는지 재귀적으로 확인합니다.
    /// - 목표 높이에 도달하면 정렬 체크 수행
    /// - 아직 도달하지 않았으면 일정 시간 후 재확인
    private func evaluateBlock() {
        guard
            let block = currentBlockView,
            let previousBlock = stackGame.previousBlock
        else { return }

        // StackGame의 previousBlock 정보를 사용해 목표 Y 계산
        let targetY = previousBlock.positionY + previousBlock.height

        if block.position.y <= targetY + block.size.height {
            // 목표 위치에 도달했으므로 정렬 체크
            // 정렬 성공/실패에 따라 물리 처리를 다르게 적용
            checkAlignmentAndHandle(targetY: targetY)
        } else {
            // 아직 도달하지 않았으면 재확인
            DispatchQueue.global().asyncAfter(deadline: .now() + Constant.Time.evaluationCheckInterval) { [weak self] in
                self?.evaluateBlock()
            }
        }
    }

    /// 정렬을 체크하고 결과에 따라 물리 처리를 다르게 적용합니다.
    /// - 성공: 블록 고정 후 배치
    /// - 실패: 물리를 유지하여 자연스럽게 떨어지도록
    private func checkAlignmentAndHandle(targetY: CGFloat) {
        guard let block = currentBlockView else { return }

        // 현재 블록 위치를 게임 모델에 업데이트
        stackGame.updateCurrentBlockPosition(positionX: block.position.x, positionY: targetY)

        let isAligned = stackGame.checkAlignment()

        if isAligned {
            // 정렬 성공: 블록 고정
            block.fixPosition()
            block.physicsBody?.velocity = CGVector.zero
            block.physicsBody?.angularVelocity = 0
            block.position = CGPoint(x: block.position.x, y: targetY)
            isProcessing = false

            placeBlockSuccess()
        } else {
            // 정렬 실패: 물리를 유지하여 계속 떨어지도록
            isProcessing = false
            placeBlockFail()
        }
    }

    /// 블록이 성공적으로 배치되었을 때의 처리를 수행합니다.
    /// - 폭탄 블록: 패널티 적용 후 블록 제거
    /// - 일반 블록: 스택에 추가, 점수 증가, 보상 적용, 카메라 이동
    private func placeBlockSuccess() {
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
            stackGame.placeBombSuccess()

            DispatchQueue.main.asyncAfter(deadline: .now() + Constant.Time.bombRemovalDelay) { [weak self] in
                block.removeFromParent()
                self?.spawnBlock()
            }
        } else {
            blockViews.append(block)

            // 높이 증가 (렌더링 정보)
            currentHeight += block.size.height

            // 코어에 블록 배치 성공 알림 (위치는 이미 업데이트됨)
            stackGame.placeBlockSuccess()

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
    private func placeBlockFail() {
        guard
            let block = currentBlockView,
            let currentBlock = stackGame.currentBlock
        else { return }

        // 폭탄 블록 실패 = 보상, 일반 블록 실패 = 패널티
        if currentBlock.type.isBomb {
            stackGame.placeBombFail()
        } else {
            stackGame.placeBlockFail()
        }

        // 일정 시간 후 블록 제거 및 다음 블록 생성
        DispatchQueue.main.asyncAfter(deadline: .now() + Constant.Time.failedBlockRemovalDelay) { [weak self] in
            block.removeFromParent()
            self?.spawnBlock()
        }

        currentBlockView = nil
    }
}
