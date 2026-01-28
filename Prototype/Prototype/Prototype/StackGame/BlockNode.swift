//
//  BlockNode.swift
//  Prototype
//
//  Created by 최범수 on 2025-12-18.
//

import SpriteKit

final class BlockNode: SKSpriteNode {
    private var action: SKAction?

    init(size: CGSize, color: UIColor) {
        super.init(texture: nil, color: color, size: size)
        self.name = "block"
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    func startMoving(distance: CGFloat) {
        let duration = Double.random(in: 0.5...1.5)
        let moveRight = SKAction.moveBy(x: distance, y: 0, duration: duration)
        let moveLeft = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        let sequence = SKAction.sequence([moveRight, moveLeft])
        let repeatAction = SKAction.repeatForever(sequence)
        self.action = repeatAction
        self.run(repeatAction)
    }

    func stopMoving() {
        self.removeAllActions()
    }

    func enableGravity() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.mass = 1
    }
}
