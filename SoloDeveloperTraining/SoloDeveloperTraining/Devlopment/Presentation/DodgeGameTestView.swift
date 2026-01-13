//
//  DodgeGameTestView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/13/26.
//

import SwiftUI

struct DodgeGameTestView: View {
    let user: User
    let calculator: Calculator

    @State private var game: DodgeGame
    @State private var currentGold: Int = 0
    @State private var coffeeCount: Int = 0
    @State private var energyDrinkCount: Int = 0
    @State private var buffDuration: Int = 0
    @State private var recentGoldChange: Int? = nil
    @State private var showGoldAnimation: Bool = false
    @State private var goldPerAction: Int = 0
    @State private var sliderValue: Double = 0

    private let gameAreaWidth: CGFloat = 300
    private let gameAreaHeight: CGFloat = 400

    init(user: User, calculator: Calculator) {
        self.user = user
        self.calculator = calculator
        let feverSystem = FeverSystem(decreaseInterval: 1.0, decreasePercentPerTick: 30)
        let buffSystem = BuffSystem()
        let dodgeGame = DodgeGame(
            user: user,
            calculator: calculator,
            feverSystem: feverSystem,
            buffSystem: buffSystem
        )
        self.game = dodgeGame
    }

    var body: some View {
        VStack(spacing: 0) {
            // GameToolBar 추가
            GameToolBar(
                closeButtonDidTapHandler: {
                    game.stopGame()
                },
                coffeeButtonDidTapHandler: {
                    useCoffee()
                },
                energyDrinkButtonDidTapHandler: {
                    useEnergyDrink()
                },
                feverState: game.feverSystem,
                coffeeCount: $coffeeCount,
                energyDrinkCount: $energyDrinkCount
            )
            .padding()

            Spacer()

            // 게임 영역
            ZStack {
                // 낙하물들
                ForEach(game.gameCore.fallingItems) { item in
                    DropItem(type: item.type)
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
                        y: gameAreaHeight - 100
                    )

                // 골드 변화 표시
                if showGoldAnimation, let goldChange = recentGoldChange {
                    Text(goldChange > 0 ? "+\(goldChange)" : "\(goldChange)")
                        .font(.title)
                        .bold()
                        .foregroundColor(goldChange > 0 ? .green : .red)
                        .position(
                            x: gameAreaWidth / 2 + game.motionSystem.characterX,
                            y: gameAreaHeight - 150
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
                HStack {
                    Text("←")
                    Slider(value: .init(get: {
                        sliderValue
                    }, set: { value in
                        sliderValue = value
                        game.motionSystem.characterX = value * 100
                    }), in: -1...1)
                    .frame(width: 250)
                    Text("→")
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
                Button(action: {
                    if game.gameCore.isRunning == true {
                        game.stopGame()
                    } else {
                        game.startGame()
                    }
                }) {
                    Text(game.gameCore.isRunning == true ? "⏸ Stop" : "▶️ Start")
                        .font(.headline)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(game.gameCore.isRunning == true ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 5)
            }
            .padding()
        }
        .onAppear {
            setupGame()
        }
    }

    private func setupGame() {
        // 골드 변화 콜백 설정
        game.onGoldChanged = { goldDelta in
            self.showGoldChangeAnimation(goldDelta)
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
        let perAction = game.calculator.calculateGoldPerAction(
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
        recentGoldChange = goldDelta
        withAnimation(.easeIn(duration: 0.2)) {
            showGoldAnimation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                showGoldAnimation = false
            }
        }
    }

    private func updateGold() async {
        let gold = await game.user.wallet.gold
        await MainActor.run {
            currentGold = gold
        }
    }

    private func updateItemCounts() async {
        let coffee = await game.user.inventory.count(.coffee) ?? 0
        let energyDrink = await game.user.inventory.count(.energyDrink) ?? 0
        await MainActor.run {
            coffeeCount = coffee
            energyDrinkCount = energyDrink
        }
    }

    private func useCoffee() {
        Task {
            let success = await game.user.inventory.drink(.coffee)
            if success {
                game.buffSystem.useConsumableItem(type: .coffee)
            }
        }
    }

    private func useEnergyDrink() {
        Task {
            let success = await game.user.inventory.drink(.energyDrink)
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
    let calculator = Calculator()
    DodgeGameTestView(user: user, calculator: calculator)
}
