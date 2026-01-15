//
//  BlockItem.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-13.
//

import SpriteKit
import SwiftUI

private enum Constant {
    // 움직이는 속도(작을수록 빠름)
    static let moveDurationRange = 0.5...1.0
    // 질량
    static let physicsMass: CGFloat = 1.0
    // 탄성 (0으로 설정하여 튀지 않도록)
    static let physicsRestitution: CGFloat = 0.0
    // 마찰 (1.0으로 설정하여 미끄러지지 않도록)
    static let physicsFriction: CGFloat = 1.0
}

final class BlockItem: SKSpriteNode {
    private var moveAction: SKAction?
    let blockType: BlockType

    init(type: BlockType = .blue) {
        self.blockType = type
        let texture = SKTexture(imageNamed: type.imageName)
        super.init(texture: texture, color: .clear, size: type.size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    func startMoving(distance: CGFloat) {
        let duration = Double.random(in: Constant.moveDurationRange)
        let moveRight = SKAction.moveBy(x: distance, y: 0, duration: duration)
        let moveLeft = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        let sequence = SKAction.sequence([moveRight, moveLeft])
        let repeatAction = SKAction.repeatForever(sequence)
        self.moveAction = repeatAction
        self.run(repeatAction, withKey: "moving")
    }

    func stopMoving() {
        self.removeAction(forKey: "moving")
        self.moveAction = nil
    }

    func enableGravity() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.mass = Constant.physicsMass
        self.physicsBody?.restitution = Constant.physicsRestitution
        self.physicsBody?.friction = Constant.physicsFriction
    }

    func fixPosition() {
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
    }

    func setupPhysicsBody(isDynamic: Bool = false) {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = isDynamic
        self.physicsBody?.allowsRotation = false
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("BlockItem Preview")
            .font(.headline)

        ForEach(BlockType.allCases, id: \.self) { type in
            VStack(spacing: 8) {
                Text(String(describing: type))
                    .font(.caption)
                    .foregroundColor(.secondary)

                SpriteView(
                    scene: {
                        let scene = SKScene(size: type.size)
                        scene.backgroundColor = .clear
                        scene.scaleMode = .aspectFit

                        let block = BlockItem(type: type)
                        block.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
                        scene.addChild(block)

                        return scene
                    }(),
                    options: [.allowsTransparency]
                )
                .frame(width: type.size.width, height: type.size.height)
            }
        }
    }
    .padding()
}
