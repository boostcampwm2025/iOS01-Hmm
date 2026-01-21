//
//  CharacterScene.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/20/26.
//

import Foundation
import SpriteKit
import SwiftUI

private enum Constant {
    static let characterSize = CGSize(width: 100, height: 100)
    static let blinkDuration: TimeInterval = 0.1
    static let blinkInterval: TimeInterval = 3.5
    static let smileDuration: TimeInterval = 0.5
}

final class CharacterScene: SKScene {

    // MARK: - Properties
    private var characterSprite: SKSpriteNode?
    private let idleTexture = SKTexture(imageNamed: "character_default")
    private let blinkTexture = SKTexture(imageNamed: "character_close")
    private let smileTexture = SKTexture(imageNamed: "character_smile")

    private enum AnimationKey {
        static let blink = "blink"
        static let smile = "smile"
    }

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        let sprite = SKSpriteNode(texture: idleTexture)
        sprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sprite.size = Constant.characterSize
        addChild(sprite)
        characterSprite = sprite
        startBlinking()
    }

    /// 캐릭터를 웃게 만들기
    func playSmile() {
        guard let sprite = characterSprite else { return }
        // 깜빡임 애니메이션 일시 중지
        sprite.removeAction(forKey: AnimationKey.blink)
        // 웃는 애니메이션
        let smile = SKAction.sequence([
            SKAction.setTexture(smileTexture),
            SKAction.wait(forDuration: Constant.smileDuration),
            SKAction.setTexture(idleTexture),
            SKAction.run { [weak self] in
                // 웃음 애니메이션 끝나면 다시 깜빡임 시작
                self?.startBlinking()
            }
        ])
        sprite.run(smile, withKey: AnimationKey.smile)
    }

    /// 기본 상태로 돌아가기
    func playIdle() {
        guard let sprite = characterSprite else { return }
        sprite.removeAction(forKey: AnimationKey.smile)
        sprite.texture = idleTexture
        startBlinking()
    }

    // MARK: - Private Methods
    private func startBlinking() {
        guard let sprite = characterSprite else { return }
        // 이미 깜빡이는 중이면 무시
        if sprite.action(forKey: AnimationKey.blink) != nil { return }
        let blink = SKAction.sequence([
            // 대기
            SKAction.wait(forDuration: Constant.blinkInterval),
            // 눈 감기
            SKAction.setTexture(blinkTexture),
            SKAction.wait(forDuration: Constant.blinkDuration),
            // 눈 뜨기
            SKAction.setTexture(idleTexture),
            SKAction.wait(forDuration: Constant.blinkDuration)
        ])
        sprite.run(.repeatForever(blink), withKey: AnimationKey.blink)
    }
}

// MARK: - Environment Key
private struct CharacterSceneKey: EnvironmentKey {
    static let defaultValue: CharacterScene? = nil
}

extension EnvironmentValues {
    var characterScene: CharacterScene? {
        get { self[CharacterSceneKey.self] }
        set { self[CharacterSceneKey.self] = newValue }
    }
}
