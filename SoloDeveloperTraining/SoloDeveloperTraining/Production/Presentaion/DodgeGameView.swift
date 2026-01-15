//
//  DodgeGameView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-15.
//

import SwiftUI

private enum Constant {
    enum Size {
        static let ground: CGFloat = 60
        static let character: CGSize = CGSize(width: 40, height: 40)
    }

    enum Position {
        /// 캐릭터의 Y 위치 비율 (화면 하단 기준)
        static let characterYRatio: CGFloat = 0.25
        /// 이펙트가 캐릭터 위로 올라가는 오프셋
        static let effectOffset: CGFloat = 30
    }

    enum Threshold {
        /// 캐릭터 방향 전환을 위한 최소 이동 거리
        static let directionChange: CGFloat = 0.1
    }

    enum Padding {
        static let horizontal: CGFloat = 16
        static let toolBarBottom: CGFloat = 14
    }
}

struct DodgeGameView: View {
    private var game: DodgeGame

    @State private var gameAreaWidth: CGFloat = 0
    @State private var gameAreaHeight: CGFloat = 0
    @State private var isFacingLeft: Bool = false
    @State private var goldEffects: [EffectLabelData] = []

    @Binding var isGameStarted: Bool

    init(user: User, isGameStarted: Binding<Bool>) {
        self._isGameStarted = isGameStarted
        self.game = DodgeGame(
            user: user,
            gameAreaSize: CGSize.zero,
            onGoldChanged: { _ in }
        )
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                GameToolBar(
                    closeButtonDidTapHandler: closeGame,
                    coffeeButtonDidTapHandler: {
                        useConsumable(item: .coffee)
                    },
                    energyDrinkButtonDidTapHandler: {
                        useConsumable(item: .energyDrink)
                    },
                    feverState: game.feverSystem,
                    coffeeCount: .constant(game.user.inventory.count(.coffee) ?? 0),
                    energyDrinkCount: .constant(game.user.inventory.count(.energyDrink) ?? 0)
                )
                .padding(.horizontal, Constant.Padding.horizontal)
                .padding(.bottom, Constant.Padding.toolBarBottom)

                // 게임 영역
                ZStack(alignment: .bottom) {
                    // 바닥
                    Image(.dodgeGround)
                        .resizable()
                        .frame(height: Constant.Size.ground)

                    // 플레이어
                    RunningCharacter(isFacingLeft: isFacingLeft)
                        .frame(
                            width: Constant.Size.character.width,
                            height: Constant.Size.character.height
                        )
                        .position(
                            x: gameAreaWidth / 2 + game.motionSystem.characterX,
                            y: gameAreaHeight * (1 - Constant.Position.characterYRatio)
                        )
                        .onChange(of: game.motionSystem.characterX) { oldPositionX, newPositionX in
                            updateCharacterDirection(oldPositionX: oldPositionX, newPositionX: newPositionX)
                        }

                    // 낙하물
                    ForEach(game.gameCore.fallingItems) { item in
                        DropItem(type: item.type)
                            .position(
                                x: gameAreaWidth / 2 + item.position.x,
                                y: gameAreaHeight / 2 + item.position.y
                            )
                    }

                    // 골드 변화 이펙트
                    ForEach(goldEffects) { effect in
                        EffectLabel(
                            value: effect.value,
                            onComplete: {
                                goldEffects.removeAll { $0.id == effect.id }
                            }
                        )
                        .position(effect.position)
                    }
                }
            }
            .onAppear {
                setupGame(with: geometry.size)
            }
            .onDisappear {
                game.stopGame()
            }
        }
    }
}

private extension DodgeGameView {
    func setupGame(with size: CGSize) {
        gameAreaWidth = size.width
        gameAreaHeight = size.height

        game.setGoldChangedHandler(showGoldChangeEffect)

        game.configure(gameAreaSize: CGSize(width: size.width, height: size.height))
        game.startGame()
    }

    func showGoldChangeEffect(_ goldDelta: Int) {
        let effect = EffectLabelData(
            id: UUID(),
            position: CGPoint(
                x: gameAreaWidth / 2 + game.motionSystem.characterX,
                y: gameAreaHeight * (1 - Constant.Position.characterYRatio) - Constant.Position.effectOffset
            ),
            value: goldDelta
        )

        goldEffects.append(effect)
    }

    func useConsumable(item: ConsumableType) {
        let success = game.user.inventory.drink(item)
        if success {
            game.buffSystem.useConsumableItem(type: item)
        }
    }

    // 캐릭터의 진행 방향을 업데이트 합니다.
    func updateCharacterDirection(oldPositionX: CGFloat, newPositionX: CGFloat) {
        if abs(newPositionX - oldPositionX) > Constant.Threshold.directionChange {
            isFacingLeft = newPositionX < oldPositionX
        }
    }

    func closeGame() {
        game.stopGame()
        isGameStarted = false
    }
}

#Preview {
    @Previewable @State var isGameStarted = true

    let wallet = Wallet(gold: 1000, diamond: 0)
    let inventory = Inventory(
        equipmentItems: [],
        consumableItems: [
            .init(type: .coffee, count: 5),
            .init(type: .energyDrink, count: 5)
        ],
        housing: .street
    )
    let record = Record()
    let user = User(
        nickname: "TestUser",
        wallet: wallet,
        inventory: inventory,
        record: record,
        skills: [
            .init(game: .dodge, tier: .beginner, level: 1000)
        ]
    )

    GeometryReader { geometry in
        VStack(spacing: 0) {
            Spacer()
                .frame(maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))

            DodgeGameView(user: user, isGameStarted: $isGameStarted)
                .ignoresSafeArea()
                .frame(height: geometry.size.height / 2 - Constant.Size.ground)
        }
    }
}
