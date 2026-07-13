//
//  DodgeGameTestView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/13/26.
//

import SwiftUI

import DUDesignSystem

/// Dodge 게임 테스트 뷰
struct DodgeGameTestView: View {
    let user: User

    @State private var game: DodgeGame
    @State private var currentGold: Int = 0
    @State private var coffeeCount: Int = 0
    @State private var energyDrinkCount: Int = 0
    @State private var buffDuration: Int = 0
    @State private var recentGoldChange: Int?
    @State private var showGoldAnimation: Bool = false
    @State private var goldPerAction: Int = 0
    @State private var sliderValue: Double = 0
    @State private var gameAreaWidth: CGFloat = 300
    @State private var gameAreaHeight: CGFloat = 400
    @State private var goldAnimationTask: DispatchWorkItem?

    init(user: User) {
        self.user = user

        // 초기 크기 (onAppear에서 실제 크기로 업데이트됨)
        let initialSize = CGSize(width: 300, height: 400)

        _game = State(initialValue: DodgeGame(
            user: user,
            gameAreaSize: initialSize, onGoldChanged: { _ in }
        ))
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // GameToolBar 추가
                GameToolBar(
                    feverStage: game.feverSystem.feverStage,
                    feverProgress: {
                        let stageBase = Double(game.feverSystem.feverStage) * 100.0
                        return (game.feverSystem.feverPercent - stageBase) / 100.0
                    }(),
                    feverMultiplier: game.feverSystem.feverStage == 0 ? 0 : game.feverSystem.feverMultiplier,
                    coffeeCount: coffeeCount,
                    energyDrinkCount: energyDrinkCount,
                    onClose: { game.stopGame() },
                    onCoffee: { useCoffee() },
                    onEnergyDrink: { useEnergyDrink() }
                )
                .padding()

                Spacer()

                // 게임 영역
                ZStack {
                    // 배경
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        )

                    // 낙하물들
                    ForEach(game.gameCore.fallingItems) { item in
                        DropItem(type: mapDropItemType(item.type))
                        .position(
                            x: gameAreaWidth / 2 + item.position.x,
                            y: gameAreaHeight / 2 + item.position.y
                        )
                }

                // 플레이어 (characterX가 0일 때 정확히 중앙에 위치)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                    .position(
                        x: gameAreaWidth / 2 + game.motionSystem.characterX,
                        y: gameAreaHeight - gameAreaHeight * 0.25
                    )

                // 골드 변화 표시
                if showGoldAnimation, let goldChange = recentGoldChange {
                    Text(goldChange > 0 ? "+\(goldChange)" : "\(goldChange)")
                        .font(.title)
                        .bold()
                        .foregroundColor(goldChange > 0 ? .green : .red)
                        .position(
                            x: gameAreaWidth / 2 + game.motionSystem.characterX,
                            y: gameAreaHeight - gameAreaHeight * 0.375
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .frame(width: gameAreaWidth, height: gameAreaHeight)

            Spacer()

            // 시뮬레이터 테스트용 슬라이더
            VStack(spacing: 10) {
                Text("🎮 Simulator Control")
                    .font(.headline)
                HStack(spacing: 12) {
                    Text("←")
                        .font(.title2)
                    Slider(value: .init(get: {
                        sliderValue
                    }, set: { value in
                        sliderValue = value
                        game.motionSystem.characterX = value * game.motionSystem.screenLimit
                    }), in: -1...1)
                    .frame(width: max(gameAreaWidth - 80, 200))
                    Text("→")
                        .font(.title2)
                }
            }
            .padding()

            // 게임 정보 표시
            VStack(spacing: 15) {
                // 현재 골드
                HStack {
                    Text("💰 Gold:")
                        .font(.headline)
                    Text("\(currentGold)")
                        .font(.title2)
                        .bold()
                }

                // 액션당 획득 골드
                HStack {
                    Text("📈 Per Action:")
                        .font(.headline)
                    Text("\(goldPerAction)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.blue)
                }

                // 버프 사용 시간
                HStack {
                    Text("⚡️ Buff Time:")
                        .font(.headline)
                    Text("\(buffDuration)s")
                        .font(.title3)
                        .bold()
                        .foregroundColor(buffDuration > 0 ? .orange : .gray)
                }

                // Start/Stop 버튼
                Button(
                    action: {
                        if game.gameCore.isRunning == true {
                            game.stopGame()
                        } else {
                            game.startGame()
                        }
                    },
                    label: {
                        Text(game.gameCore.isRunning == true ? "⏸ Stop" : "▶️ Start")
                            .font(.headline)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(game.gameCore.isRunning == true ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                )
                .padding(.top, 5)
            }
            .padding()
            }
            .onChange(of: geometry.size) { _, newSize in
                updateGameArea(for: newSize)
            }
            .onAppear {
                setupGame(with: geometry.size)
            }
        }
    }

    private func mapDropItemType(_ type: FallingItemType) -> DropItem.DropItemType {
        switch type {
        case .smallGold: return .smallGold
        case .largeGold: return .largeGold
        case .bug:       return .bug
        }
    }

    private func updateGameArea(for size: CGSize) {
        // 게임 영역 크기 계산
        let availableWidth = size.width - 32 // padding 고려
        let availableHeight = size.height * 0.5 // 화면의 50% 사용

        gameAreaWidth = availableWidth
        gameAreaHeight = availableHeight

        // 게임 시스템에 크기 전달 (gameCore와 motionSystem 모두 업데이트)
        game.configure(gameAreaSize: CGSize(width: availableWidth, height: availableHeight))
    }

    private func setupGame(with size: CGSize) {
        // 게임 영역 크기 설정
        updateGameArea(for: size)

        // 골드 변화 콜백 설정
        game.setGoldChangedHandler { goldDelta in
            showGoldChangeAnimation(goldDelta)
        }

        // 초기 값 업데이트
        Task {
            await updateGold()
            await updateItemCounts()
        }

        // 상태 변화 감지를 위한 타이머
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task {
                await self.updateGold()
                await self.updateItemCounts()
                await self.updateGoldPerAction()
                await MainActor.run {
                    self.buffDuration = game.buffSystem.duration
                }
            }
        }
    }

    private func updateGoldPerAction() async {
        let perAction = Calculator.calculateGoldPerAction(
            game: .dodge,
            user: game.user,
            feverMultiplier: game.feverSystem.feverMultiplier,
            buffMultiplier: game.buffSystem.multiplier
        )
        await MainActor.run {
            goldPerAction = perAction
        }
    }

    private func showGoldChangeAnimation(_ goldDelta: Int) {
        // 이전 애니메이션 작업 취소
        goldAnimationTask?.cancel()

        // 새 골드 변화 설정
        recentGoldChange = goldDelta

        withAnimation(.easeIn(duration: 0.2)) {
            showGoldAnimation = true
        }

        // 새 애니메이션 작업 생성
        let task = DispatchWorkItem {
            withAnimation(.easeOut(duration: 0.3)) {
                showGoldAnimation = false
            }
        }
        goldAnimationTask = task

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: task)
    }

    private func updateGold() async {
        let gold = game.user.wallet.gold
        await MainActor.run {
            currentGold = gold
        }
    }

    private func updateItemCounts() async {
        let coffee = game.user.inventory.count(.coffee) ?? 0
        let energyDrink = game.user.inventory.count(.energyDrink) ?? 0
        await MainActor.run {
            coffeeCount = coffee
            energyDrinkCount = energyDrink
        }
    }

    private func useCoffee() {
        Task {
            let success = game.user.inventory.drink(.coffee)
            if success {
                game.buffSystem.useConsumableItem(type: .coffee)
            }
        }
    }

    private func useEnergyDrink() {
        Task {
            let success = game.user.inventory.drink(.energyDrink)
            if success {
                game.buffSystem.useConsumableItem(type: .energyDrink)
            }
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
    DodgeGameTestView(user: user)
}
