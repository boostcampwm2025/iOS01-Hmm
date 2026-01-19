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
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: TabItem = .work

    private var autoGainSystem: AutoGainSystem
    private let user: User

    let careerProgress: Double = 0.3

    init(user: User) {
        self.autoGainSystem = AutoGainSystem(user: user)
        self.user = user
    }

    var body: some View {
        VStack(spacing: 0) {
            // 배경 + 상태바
            ZStack(alignment: .top) {
                Image(user.inventory.housing.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()

                StatusBar(
                    career: user.career,
                    nickname: user.nickname,
                    careerProgress: careerProgress,
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
                    WorkSelectedView(user: user)
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
        .onAppear(perform: autoGainSystem.startSystem)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                autoGainSystem.startSystem()
            } else if newValue == .inactive || newValue == .background {
                autoGainSystem.stopSystem()
            }
        }
    }
}

#Preview {
    let user = User(
        nickname: "소피아",
        wallet: .init(),
        inventory: Inventory(
            equipmentItems: [
                .init(type: .chair, tier: .broken),
                .init(type: .keyboard, tier: .broken),
                .init(type: .monitor, tier: .broken),
                .init(type: .mouse, tier: .broken)
            ],
            housing: .pentHouse
        ),
        record: .init(),
        skills: [
            .init(game: .tap, tier: .beginner, level: 100),
            .init(game: .language, tier: .beginner, level: 100),
            .init(game: .dodge, tier: .beginner, level: 100),
            .init(game: .stack, tier: .beginner, level: 100)
        ]
    )
    MainView(user: user)
}
