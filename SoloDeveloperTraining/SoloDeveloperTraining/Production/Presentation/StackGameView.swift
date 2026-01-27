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

    enum Padding {
        static let horizontal: CGFloat = 16
        static let toolBarBottom: CGFloat = 14
    }
}

struct StackGameView: View {
    @State private var stackGame: StackGame
    @State private var scene: StackGameScene

    /// 게임 시작 상태 (부모 뷰와 바인딩)
    @Binding var isGameStarted: Bool
    @Binding var isGameViewDisappeared: Bool

    @State private var effectLabels: [EffectLabelData] = []

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        isGameViewDisappeared: Binding<Bool>,
        animationSystem: CharacterAnimationSystem? = nil
    ) {
        let stackGame = StackGame(user: user, animationSystem: animationSystem)
        self._stackGame = State(initialValue: stackGame)
        self._isGameStarted = isGameStarted
        self._isGameViewDisappeared = isGameViewDisappeared
        let initialScene = StackGameScene(
            stackGame: stackGame,
            onBlockDropped: { _ in }
        )
        self._scene = State(initialValue: initialScene)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 상단 툴바 (닫기, 아이템 버튼, 피버 게이지)
                toolbarSection
                // 게임 영역 (SpriteKit 씬, 골드 이펙트)
                gameAreaSection
            }
            .background(AppTheme.backgroundColor)
            .navigationBarBackButtonHidden(true) // 임시로 숨김
            .onAppear {
                setupGameCallbacks(with: geometry)
            }
            .pauseGameStyle(
                isGameViewDisappeared: $isGameViewDisappeared,
                onLeave: { handleCloseButton() },
                onPause: { scene.pauseGame() },
                onResume: { scene.resumeGame()}
            )
        }
    }
}

// MARK: - View Components
private extension StackGameView {
    /// 상단 툴바
    var toolbarSection: some View {
        GameToolBar(
            closeButtonDidTapHandler: handleCloseButton,
            coffeeButtonDidTapHandler: { useConsumableItem(.coffee) },
            energyDrinkButtonDidTapHandler: { useConsumableItem(.energyDrink) },
            feverState: stackGame.feverSystem,
            buffSystem: stackGame.buffSystem,
            coffeeCount: .constant(stackGame.user.inventory.count(.coffee) ?? 0),
            energyDrinkCount: .constant(stackGame.user.inventory.count(.energyDrink) ?? 0)
        )
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.bottom, Constant.Padding.toolBarBottom)
    }

    /// 게임 영역
    var gameAreaSection: some View {
        ZStack {
            SpriteView(scene: scene)

            ForEach(effectLabels) { effectLabel in
                EffectLabel(
                    value: effectLabel.value,
                    onComplete: { removeEffectLabel(id: effectLabel.id) }
                )
                .position(effectLabel.position)
            }
        }
    }
}

// MARK: - Actions
private extension StackGameView {
    /// 닫기 버튼 클릭 처리
    func handleCloseButton() {
        stackGame.stopGame()
        isGameStarted = false
    }

    /// 소비 아이템 사용 처리
    func useConsumableItem(_ type: ConsumableType) {
        if stackGame.user.inventory.drink(type) {
            // 햅틱 재생
            HapticService.shared.trigger(.success)
            stackGame.buffSystem.useConsumableItem(type: type)
            stackGame.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
        }
    }
}

// MARK: - Helper Methods
private extension StackGameView {
    /// 게임 콜백 설정
    func setupGameCallbacks(with geometry: GeometryProxy) {
        scene.onBlockDropped = { gold in
            showEffectLabel(
                at: CGPoint(
                    x: geometry.size.width * randomEffectXRatio,
                    y: randomEffectYOffset
                ),
                value: gold
            )
        }
    }

    /// 효과 라벨 추가
    /// - Parameters:
    ///   - location: 표시할 위치
    ///   - value: 표시할 값
    func showEffectLabel(at location: CGPoint, value: Int) {
        let labelData = EffectLabelData(
            id: UUID(),
            position: location,
            value: value
        )
        effectLabels.append(labelData)
    }

    /// 효과 라벨 제거 (애니메이션 완료 시 콜백으로 호출)
    /// - Parameter id: 제거할 효과 라벨의 ID
    func removeEffectLabel(id: UUID) {
        effectLabels.removeAll { $0.id == id }
    }

    /// 랜덤 효과 라벨 X 위치 비율
    var randomEffectXRatio: CGFloat {
        Constant.effectLabelXRatios.randomElement() ?? 0.4
    }

    /// 랜덤 효과 라벨 Y 오프셋
    var randomEffectYOffset: CGFloat {
        Constant.effectLabelYPositions.randomElement() ?? 200
    }
}
