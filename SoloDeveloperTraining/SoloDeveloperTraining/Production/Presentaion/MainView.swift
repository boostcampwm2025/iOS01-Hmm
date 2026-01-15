//
//  MainView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI

enum AppTheme {
    static let backgroundColor: Color = AppColors.beige200
}

struct MainView: View {
    @State private var selectedTab: TabItem = .work
    @State private var user: User

    let housing: Housing = .street
    let calculator: Calculator
    let autoGainSystem: AutoGainSystem

    init() {
        let user = User(
            nickname: "소피아",
            wallet: .init(gold: 1000000, diamond: 100),
            inventory: .init(
                equipmentItems: [
                    .init(type: .keyboard, tier: .broken),
                    .init(type: .mouse, tier: .broken),
                    .init(type: .monitor, tier: .broken),
                    .init(type: .chair, tier: .broken)
                ],
                consumableItems: [
                    .init(type: .coffee, count: 5),
                    .init(type: .energyDrink, count: 5)
                ],
                housing: .street
            ),
            record: .init(),
            skills: [
                .init(game: .tap, tier: .beginner, level: 1000),
                .init(game: .tap, tier: .intermediate, level: 1000),
                .init(game: .tap, tier: .advanced, level: 1000),
                .init(game: .dodge, tier: .beginner, level: 500),
                .init(game: .dodge, tier: .intermediate, level: 500),
                .init(game: .dodge, tier: .advanced, level: 500),
                .init(game: .stack, tier: .beginner, level: 1)
            ]
        )
        let calculator: Calculator = Calculator()
        self.user = user
        self.calculator = calculator
        self.autoGainSystem = .init(user: user, calculator: calculator)
        autoGainSystem.startSystem()
    }

    var body: some View {
        VStack(spacing: 0) {
            // 배경 + 상태바
            ZStack(alignment: .top) {
                Image(housing.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()

                StatusBar(
                    career: user.career,
                    nickname: user.nickname,
                    // TODO: 진행도 계산 로직 추가
                    careerProgress: 0.3,
                    gold: user.wallet.gold,
                    diamond: user.wallet.diamond
                )
                .background(Color.white.opacity(0.8))
            }

            // 탭바
            TabBar(selectedTab: $selectedTab)

            // 탭별 콘텐츠
            Group {
                switch selectedTab {
                case .work:
                    // TODO: 실제 디자인으로 변경
                    NavigationStack {
                        List {
                            NavigationLink("물건 쌓기 게임") {
                                StackGameView(
                                    stackGame: StackGame(
                                        user: user,
                                        calculator: calculator
                                    )
                                )
                            }
                        }
                    }
                case .enhance:
                    Color.white
                        .overlay(Text("강화 화면").foregroundColor(.gray))
                case .shop:
                    Color.white
                        .overlay(Text("상점 화면").foregroundColor(.gray))
                case .mission:
                    Color.white
                        .overlay(Text("미션 화면").foregroundColor(.gray))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(AppTheme.backgroundColor)
    }
}
