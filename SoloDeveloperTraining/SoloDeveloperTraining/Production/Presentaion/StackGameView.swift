//
//  StackGameView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/15/26.
//

import SwiftUI
import SpriteKit

private enum Constant {
    static let effectLabelXRatios: [CGFloat] = [0.3, 0.4, 0.7]
    static let effectLabelYPositions: [CGFloat] = [150, 200, 250]
}

struct StackGameView: View {
    let stackGame: StackGame
    let scene: StackGameScene

    /// 게임 시작 상태 (부모 뷰와 바인딩)
    @Binding var isGameStarted: Bool

    @State private var effectLabels: [EffectLabelData] = []

    init(user: User, isGameStarted: Binding<Bool>) {
        self.stackGame = StackGame(user: user, calculator: .init())
        self._isGameStarted = isGameStarted
        self.scene = StackGameScene(
            stackGame: stackGame,
            onBlockDropped: { _ in
            })
    }

    var randomEffectXRatio: CGFloat {
        Constant.effectLabelXRatios.randomElement() ?? 0.4
    }
    var randomEffectYOffset: CGFloat {
        Constant.effectLabelYPositions.randomElement() ?? 200
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                GameToolBar(
                    closeButtonDidTapHandler: stopGame,
                    coffeeButtonDidTapHandler: { useConsumableItem(.coffee) },
                    energyDrinkButtonDidTapHandler: { useConsumableItem(.energyDrink) },
                    feverState: stackGame.feverSystem,
                    coffeeCount: .constant(stackGame.user.inventory.count(.coffee) ?? 0),
                    energyDrinkCount: .constant(stackGame.user.inventory.count(.energyDrink) ?? 0)
                )
                .padding(.horizontal)
                ZStack {
                    SpriteView(
                        scene: scene
                    ).onAppear {
                        scene.onBlockDropped = { gold in
                            addEffectLabel(
                                at: CGPoint(
                                    x: geometry.size.width * randomEffectXRatio,
                                    y: randomEffectYOffset
                                ),
                                value: gold
                            )
                        }
                    }
                    ForEach(effectLabels) { effectLabel in
                        EffectLabel(
                            value: effectLabel.value,
                            onComplete: { effectLabels.removeAll { $0.id == effectLabel.id } }
                        )
                        .position(effectLabel.position)
                    }
                }
            }
            .background(AppTheme.backgroundColor)
            .navigationBarBackButtonHidden(true) // 임시로 숨김
        }
    }
}

private extension StackGameView {
    func stopGame() {
        stackGame.stopGame()
        isGameStarted = false
    }

    func useConsumableItem(_ type: ConsumableType) {
        if stackGame.user.inventory.drink(type) {
            stackGame.buffSystem.useConsumableItem(type: type)
        }
    }

    func addEffectLabel(at location: CGPoint, value: Int) {
        let labelData = EffectLabelData(
            id: UUID(),
            position: location,
            value: value
        )
        effectLabels.append(labelData)
    }
}
