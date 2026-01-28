//
//  StackGameScene.swift
//  Prototype
//
//  Created by 최범수 on 2025-12-17.
//

import SpriteKit

final class StackGameScene: SKScene {
    private var isBlockProcessing: Bool = false
    private var currentBlock: BlockNode?
    private var previousBlock: BlockNode?
    private var blocks: [BlockNode] = []

    private let blockSize = CGSize(width: 80, height: 40)
    private let blockColors: [UIColor] = [
        .systemRed, .systemBlue, .systemGreen, .systemYellow,
        .systemPurple, .systemOrange, .systemPink, .systemTeal
    ]

    private var score: Int = 0
    private var currentHeight: CGFloat = 40

    private let scoreLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.fontSize = 40
        label.fontColor = .black
        label.text = 0.description
        return label
    }()

    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        setupGravity()
        setupGround()
        setupCamera()
        startGame()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentBlock != nil,
              !isBlockProcessing
        else { return }

        dropBlock()
    }

    private func setupGravity() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }

    private func setupGround() {
        let size = CGSize(width: frame.size.width, height: 10)
        let ground = SKSpriteNode(color: .gray, size: size)
        ground.position = CGPoint(x: frame.midX, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: size)
        ground.physicsBody?.isDynamic = false
        self.addChild(ground)
    }

    private func setupCamera() {
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        cameraNode.addChild(scoreLabel)
        addChild(cameraNode)
        self.camera = cameraNode
    }

    private func startGame() {
        isBlockProcessing = false
        blocks.removeAll()
        score = 0
        currentHeight = 40

        blocks.forEach { $0.removeFromParent() }
        blocks.removeAll()

        camera?.position = CGPoint(x: frame.midX, y: frame.midY)

        putInitialBlock()

        spawnBlock()
    }

    private func putInitialBlock() {
        let firstBlock = BlockNode(size: blockSize, color: .gray)
        firstBlock.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
        firstBlock.physicsBody?.isDynamic = false
        firstBlock.position = CGPoint(x: frame.midX, y: currentHeight)

        previousBlock = firstBlock
        currentHeight += firstBlock.size.height
        addChild(firstBlock)
        blocks.append(firstBlock)
    }

    private func spawnBlock() {
        isBlockProcessing = false

        let color = blockColors[score % blockColors.count]
        let block = BlockNode(size: blockSize, color: color)

        let spawnY = (camera?.position.y ?? frame.midY) + frame.height / 2 - 100
        let leftEdge = blockSize.width / 2
        let rightEdge = frame.width - blockSize.width / 2

        block.position = CGPoint(x: leftEdge, y: spawnY)
        block.startMoving(distance: rightEdge - leftEdge)

        currentBlock = block
        addChild(block)
    }

    private func dropBlock() {
        guard let block = currentBlock,
              !isBlockProcessing
        else { return }

        isBlockProcessing = true

        block.stopMoving()
        block.enableGravity()

        evaluateBlock()
    }

    private func evaluateBlock() {
        guard let block = currentBlock,
              let previous = previousBlock
        else { return }

        let targetY = previous.position.y + previous.size.height

        if block.position.y <= targetY + blockSize.height {
            checkAlignment()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
                self?.evaluateBlock()
            }
        }
    }

    private func checkAlignment() {
        guard let current = currentBlock,
              let previous = previousBlock
        else { return }

        let previousLeft = previous.position.x - previous.size.width / 2
        let previousRight = previous.position.x + previous.size.width / 2
        let previousRange = previousLeft...previousRight

        if previousRange.contains(current.position.x) {
            placeBlockSuccess()
        } else {
            placeBlockFail()
        }
    }
    private func placeBlockSuccess() {
        guard let block = currentBlock else { return }

        block.physicsBody?.isDynamic = false
        block.position = CGPoint(x: block.position.x, y: currentHeight)

        score += 1
        scoreLabel.text = score.description

        showSuccessParticle(at: block.position)

        playSuccessSound()

        blocks.append(block)
        previousBlock = block
        currentHeight += blockSize.height

        let moveCamera = SKAction.moveBy(x: 0, y: blockSize.height, duration: 0.3)
        moveCamera.timingMode = .easeInEaseOut
        camera?.run(moveCamera)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.spawnBlock()
        }
    }

    private func placeBlockFail() {
        guard let block = currentBlock,
              let previous = previousBlock
        else { return }

        score = max(0, score - 5)
        scoreLabel.text = score.description

        block.physicsBody?.isDynamic = true
        block.physicsBody?.allowsRotation = true
        block.physicsBody?.restitution = 0.3
        block.physicsBody?.friction = 0.7

        let targetY = previous.position.y + previous.size.height
        block.position.y = targetY + 5

        showFailureParticle(at: block.position)

        playFailureSound()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            block.removeFromParent()
            self?.spawnBlock()
        }
    }

    private func showSuccessParticle(at position: CGPoint) {
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(imageNamed: "spark")
        emitter.particleBirthRate = 200
        emitter.numParticlesToEmit = 50
        emitter.particleLifetime = 1.0
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2
        emitter.particleSpeed = 100
        emitter.particleSpeedRange = 50
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.2
        emitter.particleAlpha = 1.0
        emitter.particleAlphaSpeed = -1.0
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColor = .systemYellow
        emitter.position = position

        addChild(emitter)
    }

    private func showFailureParticle(at position: CGPoint) {
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(imageNamed: "bokeh")
        emitter.particleBirthRate = 100
        emitter.numParticlesToEmit = 30
        emitter.particleLifetime = 1.5
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2
        emitter.particleSpeed = 50
        emitter.particleSpeedRange = 30
        emitter.particleScale = 0.5
        emitter.particleScaleRange = 0.3
        emitter.particleAlpha = 0.8
        emitter.particleAlphaSpeed = -0.5
        emitter.particleColor = .red
        emitter.position = position

        addChild(emitter)
    }
    
    private func playSuccessSound() {
        run(SKAction.playSoundFileNamed("success.wav", waitForCompletion: false))
    }

    private func playFailureSound() {
        run(SKAction.playSoundFileNamed("failure.wav", waitForCompletion: false))
    }
}
