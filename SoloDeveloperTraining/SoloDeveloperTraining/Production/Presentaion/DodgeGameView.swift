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

    enum Duration {
        /// 이펙트 표시 시간 (초)
        static let effectDisplay: TimeInterval = 2.0
    }
}

private struct GoldEffect: Identifiable {
    let id = UUID()
    let value: Int
    let positionX: CGFloat
    let positionY: CGFloat
}

struct DodgeGameView: View {
    @State private var user: User
    @State private var game: DodgeGame
    @State private var gameAreaWidth: CGFloat = 0
    @State private var gameAreaHeight: CGFloat = 0
    @State private var isFacingLeft: Bool = false
    @State private var goldEffects: [GoldEffect] = []

    init(user: User) {
        self.user = user

        self._game = State(
            wrappedValue: DodgeGame(
                user: user,
                gameAreaSize: CGSize.zero,
                onGoldChanged: { _ in }
            )
        )
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                GameToolBar(
                    closeButtonDidTapHandler: game.stopGame,
                    coffeeButtonDidTapHandler: useCoffee,
                    energyDrinkButtonDidTapHandler: useEnergyDrink,
                    feverState: game.feverSystem,
                    coffeeCount: .constant(user.inventory.count(.coffee) ?? 0),
                    energyDrinkCount: .constant(user.inventory.count(.energyDrink) ?? 0)
                )
                .padding(.horizontal)

                // 게임 영역
                ZStack(alignment: .bottom) {
                    // 배경
                    Color.beige300

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
                        EffectLabel(value: effect.value)
                            .position(x: effect.positionX, y: effect.positionY)
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

extension DodgeGameView {
    private func setupGame(with size: CGSize) {
        gameAreaWidth = size.width
        gameAreaHeight = size.height

        game.setGoldChangedHandler(showGoldChangeEffect)

        game.configure(gameAreaSize: CGSize(width: size.width, height: size.height))
        game.startGame()
    }

    private func showGoldChangeEffect(_ goldDelta: Int) {
        let effect = GoldEffect(
            value: goldDelta,
            positionX: gameAreaWidth / 2 + game.motionSystem.characterX,
            positionY: gameAreaHeight * (1 - Constant.Position.characterYRatio) - Constant.Position.effectOffset
        )

        goldEffects.append(effect)

        Task {
            try? await Task.sleep(nanoseconds: UInt64(Constant.Duration.effectDisplay * 1_000_000_000))
            await MainActor.run {
                goldEffects.removeAll { $0.id == effect.id }
            }
        }
    }

    private func useCoffee() {
        let success = game.user.inventory.drink(.coffee)
        if success {
            game.buffSystem.useConsumableItem(type: .coffee)
        }
    }

    private func useEnergyDrink() {
        let success = game.user.inventory.drink(.energyDrink)
        if success {
            game.buffSystem.useConsumableItem(type: .energyDrink)
        }
    }

    // 캐릭터의 진행 방향을 업데이트 합니다.
    private func updateCharacterDirection(oldPositionX: CGFloat, newPositionX: CGFloat) {
        if abs(newPositionX - oldPositionX) > Constant.Threshold.directionChange {
            isFacingLeft = newPositionX < oldPositionX
        }
    }
}

#Preview {
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

            DodgeGameView(user: user)
                .ignoresSafeArea()
                .frame(height: geometry.size.height / 2 - Constant.Size.ground)
        }
    }
}
