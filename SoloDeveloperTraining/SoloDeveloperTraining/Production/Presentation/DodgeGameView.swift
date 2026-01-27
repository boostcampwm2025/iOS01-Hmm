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
    @State private var game: DodgeGame
    @State private var gameAreaWidth: CGFloat = 0
    @State private var gameAreaHeight: CGFloat = 0
    @State private var isFacingLeft: Bool = false
    @State private var goldEffects: [EffectLabelData] = []
    // 일시정지 상태 추가
    @State private var isGamePaused: Bool = false

    @Binding var isGameStarted: Bool
    @Binding var isGameViewDisappeared: Bool

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        isGameViewDisappeared: Binding<Bool>,
        animationSystem: CharacterAnimationSystem? = nil
    ) {
        self._isGameStarted = isGameStarted
        self._isGameViewDisappeared = isGameViewDisappeared
        self.game = DodgeGame(
            user: user,
            gameAreaSize: CGSize.zero,
            onGoldChanged: { _ in },
            animationSystem: animationSystem
        )
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 상단 툴바 (닫기, 아이템 버튼, 피버 게이지)
                toolbarSection
                // 게임 영역 (바닥, 플레이어, 낙하물, 골드 이펙트)
                gameAreaSection
            }
            .onAppear {
                setupGame(with: geometry.size)
            }
            .onDisappear {
                game.stopGame()
            }
            .pauseGameStyle(
                isGameViewDisappeared: $isGameViewDisappeared,
                height: geometry.size.height,
                onLeave: { handleCloseButton() },
                onPause: {
                    isGamePaused = true
                    game.pauseGame()
                },
                onResume: {
                    isGamePaused = false
                    game.resumeGame()
                }
            )
        }
    }
}

// MARK: - View Components
private extension DodgeGameView {
    /// 상단 툴바
    var toolbarSection: some View {
        GameToolBar(
            closeButtonDidTapHandler: handleCloseButton,
            coffeeButtonDidTapHandler: { useConsumableItem(.coffee) },
            energyDrinkButtonDidTapHandler: { useConsumableItem(.energyDrink) },
            feverState: game.feverSystem,
            buffSystem: game.buffSystem,
            coffeeCount: .constant(game.user.inventory.count(.coffee) ?? 0),
            energyDrinkCount: .constant(game.user.inventory.count(.energyDrink) ?? 0)
        )
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.bottom, Constant.Padding.toolBarBottom)
    }

    /// 게임 영역
    var gameAreaSection: some View {
        ZStack(alignment: .bottom) {
            // 바닥
            groundView
            // 플레이어
            playerView
            // 낙하물
            fallingItemsView
            // 골드 변화 이펙트
            goldEffectsView
        }
    }

    /// 바닥
    var groundView: some View {
        Image(.dodgeGround)
            .resizable()
            .frame(height: Constant.Size.ground)
    }

    /// 플레이어
    var playerView: some View {
        RunningCharacter(isFacingLeft: isFacingLeft, isGamePaused: isGamePaused)
            .frame(
                width: Constant.Size.character.width,
                height: Constant.Size.character.height
            )
            .position(
                x: gameAreaWidth / 2 + (isGamePaused ? 0 : game.motionSystem.characterX),
                y: gameAreaHeight * (1 - Constant.Position.characterYRatio)
            )
            .onChange(of: game.motionSystem.characterX) { oldPositionX, newPositionX in
                updateCharacterDirection(oldPositionX: oldPositionX, newPositionX: newPositionX)
            }
    }

    /// 낙하물
    var fallingItemsView: some View {
        ForEach(game.gameCore.fallingItems) { item in
            DropItem(type: item.type)
                .position(
                    x: gameAreaWidth / 2 + item.position.x,
                    y: gameAreaHeight / 2 + item.position.y
                )
        }
    }

    /// 골드 변화 이펙트
    var goldEffectsView: some View {
        ForEach(goldEffects) { effect in
            EffectLabel(
                value: effect.value,
                onComplete: { removeEffectLabel(id: effect.id) }
            )
            .position(effect.position)
        }
    }
}

// MARK: - Actions
private extension DodgeGameView {
    /// 닫기 버튼 클릭 처리
    func handleCloseButton() {
        game.stopGame()
        isGameStarted = false
    }

    /// 소비 아이템 사용 처리
    func useConsumableItem(_ type: ConsumableType) {
        if game.user.inventory.drink(type) {
            // 햅틱 재생
            HapticService.shared.trigger(.success)
            game.buffSystem.useConsumableItem(type: type)
            game.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
        }
    }
}

// MARK: - Helper Methods
private extension DodgeGameView {
    /// 게임 초기 설정
    func setupGame(with size: CGSize) {
        gameAreaWidth = size.width
        gameAreaHeight = size.height

        game.setGoldChangedHandler(showGoldChangeEffect)

        game.configure(gameAreaSize: CGSize(width: size.width, height: size.height))
        game.startGame()
    }

    /// 골드 변화 이펙트 표시
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

    /// 효과 라벨 제거 (애니메이션 완료 시 콜백으로 호출)
    /// - Parameter id: 제거할 효과 라벨의 ID
    func removeEffectLabel(id: UUID) {
        goldEffects.removeAll { $0.id == id }
    }

    /// 캐릭터의 진행 방향을 업데이트 합니다.
    func updateCharacterDirection(oldPositionX: CGFloat, newPositionX: CGFloat) {
        guard !isGamePaused else { return }
        if abs(newPositionX - oldPositionX) > Constant.Threshold.directionChange {
            isFacingLeft = newPositionX < oldPositionX
        }
    }
}

#Preview {
    @Previewable @State var isGameStarted = true
    @Previewable @State var isGameViewDisappeared = true

    let wallet = Wallet(gold: 1000, diamond: 0)
    let inventory = Inventory(
        equipmentItems: [],
        consumableItems: [
            .init(type: .coffee, count: 5),
            .init(type: .energyDrink, count: 5)
        ],
        housing: .init(tier: .street)
    )
    let record = Record()
    let user = User(
        nickname: "TestUser",
        wallet: wallet,
        inventory: inventory,
        record: record,
        skills: [
            .init(key: SkillKey(game: .dodge, tier: .beginner), level: 1000)
        ]
    )
    
    GeometryReader { geometry in
        VStack(spacing: 0) {
            Spacer()
                .frame(maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))

            DodgeGameView(
                user: user,
                isGameStarted: $isGameStarted,
                isGameViewDisappeared: $isGameViewDisappeared
            )
            .ignoresSafeArea()
            .frame(height: geometry.size.height / 2 - Constant.Size.ground)
        }
    }
}
