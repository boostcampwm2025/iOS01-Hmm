//
//  MainView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: TabItem = .work

    let housing: Housing = .street
    let career: Career = .unemployed
    let nickname: String = "소피아"
    let careerProgress: Double = 0.3
    let gold: Int = 20000
    let diamond: Int = 20

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
                    career: career,
                    nickname: nickname,
                    careerProgress: careerProgress,
                    gold: gold,
                    diamond: diamond
                )
                .background(Color.white.opacity(0.8))
            }

            // 탭바
            TabBarView(selectedTab: $selectedTab)

            // 탭별 콘텐츠
            Group {
                switch selectedTab {
                case .work:
                    Color.white
                        .overlay(Text("업무 화면").foregroundColor(.gray))
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
    }
}
