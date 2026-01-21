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

private enum Constant {
    enum Padding {
        static let horizontalPadding: CGFloat = 25
    }

    enum Color {
        static let overlay = SwiftUI.Color.black.opacity(0.3)
    }
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: TabItem = .work
    @State private var popupContent: (String, AnyView)?
    @State private var isCareerPopupPresented: Bool = false

    private var autoGainSystem: AutoGainSystem
    private let user: User
    let careerProgress: Double = 0.3

    init(user: User) {
        self.autoGainSystem = AutoGainSystem(user: user)
        self.user = user
    }

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
                    .onTapGesture {
                        isCareerPopupPresented = true
                    }
                }
                .frame(height: geometry.size.height * 0.5)
                .background(
                    Image(user.inventory.housing.imageName)
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
                        EnhanceView(user: user, popupContent: $popupContent)
                    case .shop:
                        ShopView(user: user, popupContent: $popupContent)
                    case .mission:
                        Color.white
                            .overlay(Text("미션 화면").foregroundColor(.gray))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .background(AppTheme.backgroundColor)
            .onAppear(perform: autoGainSystem.startSystem)
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    autoGainSystem.startSystem()
                } else if newValue == .inactive || newValue == .background {
                    autoGainSystem.stopSystem()
                }
            }
            .overlay {
                if let popupContent {
                    ZStack {
                        Constant.Color.overlay
                            .ignoresSafeArea()

                        Popup(title: popupContent.0, contentView: popupContent.1)
                            .padding(.horizontal, Constant.Padding.horizontalPadding)
                    }
                }
            }
        }
        .overlay {
            if isCareerPopupPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isCareerPopupPresented = false
                    }

                Popup(title: "커리어") {
                    VStack(spacing: 20) {
                        Text("여~~기~~")
                            .textStyle(.body)

                        MediumButton(title: "닫기", isFilled: true) {
                            isCareerPopupPresented = false
                        }
                    }
                }
                .padding(.horizontal, 25)
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
            housing: .init(tier: .street)
        ),
        record: .init(),
        skills: [
            .init(key: SkillKey(game: .tap, tier: .beginner), level: 100),
            .init(key: SkillKey(game: .language, tier: .beginner), level: 100),
            .init(key: SkillKey(game: .dodge, tier: .beginner), level: 100),
            .init(key: SkillKey(game: .stack, tier: .beginner), level: 100)
        ]
    )
    MainView(user: user)
}
