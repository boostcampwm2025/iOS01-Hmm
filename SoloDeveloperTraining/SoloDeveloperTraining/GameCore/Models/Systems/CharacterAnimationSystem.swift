//
//  CharacterAnimationSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/21/26.
//

final class CharacterAnimationSystem {
    var onSmile: (() -> Void)?
    var onIdle: (() -> Void)?

    func playSmile() {
        onSmile?()
    }

    func playIdle() {
        onIdle?()
    }
}
