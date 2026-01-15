//
//  StackGameView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/15/26.
//

import SwiftUI
import SpriteKit

struct StackGameView: View {
    @State private var game: StackGame
    private let scene: StackGameScene

    init(user: User, calculator: Calculator) {
        let game = StackGame(user: user, calculator: calculator)
        let scene = StackGameScene(stackGame: game)

        self.scene = scene
        self._game = State(wrappedValue: game)
    }

    var body: some View {
        SpriteView(scene: scene)
    }
}
