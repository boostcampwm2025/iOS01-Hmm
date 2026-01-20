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

    @State var user = User(
        nickname: "소피아",
        wallet: .init(),
        inventory: .init(),
        record: .init(),
        skills: [
            .init(game: .tap, tier: .beginner, level: 100),
            .init(game: .language, tier: .beginner, level: 100),
            .init(game: .dodge, tier: .beginner, level: 100),
            .init(game: .stack, tier: .beginner, level: 100)
        ]
    )
    let housing: Housing = .street
    let careerProgress: Double = 0.3

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Color.clear
                    StatusBar(
                        career: user.career,
                        nickname: user.nickname,
                        careerProgress: careerProgress,
                        gold: user.wallet.gold,
                        diamond: user.wallet.diamond
                    )
                }
                .frame(height: geometry.size.height * 0.5)
                .background(
                    Image(housing.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )

                // 탭바
                TabBar(selectedTab: $selectedTab)

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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .background(AppTheme.backgroundColor)
        }
    }
}

#Preview {
    MainView()
}
