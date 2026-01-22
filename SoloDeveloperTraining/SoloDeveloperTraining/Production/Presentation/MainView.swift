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

    enum CareerPopup {
        static let title: String = "커리어"
        static let maxHeight: CGFloat = 650
    }
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: TabItem = .work
    @State private var popupContent: PopupConfiguration?
    @State private var careerSystem: CareerSystem?

    private var autoGainSystem: AutoGainSystem
    private let user: User

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
                        career: careerSystem?.currentCareer ?? .unemployed,
                        nickname: user.nickname,
                        careerProgress: careerSystem?.careerProgress ?? 0.0,
                        gold: user.wallet.gold,
                        diamond: user.wallet.diamond
                    )
                    .onTapGesture {
                        showCareerPopup()
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
            .onAppear {
                autoGainSystem.startSystem()
                Task {
                    if careerSystem == nil {
                        careerSystem = await CareerSystem(user: user)
                    }
                }
            }
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    autoGainSystem.startSystem()
                } else if newValue == .inactive || newValue == .background {
                    autoGainSystem.stopSystem()
                }
            }
            .task(id: user.record.totalEarnedMoney) {
                await careerSystem?.updateCareer()
            }
            .overlay {
                if let popupContent {
                    ZStack {
                        Constant.Color.overlay
                            .ignoresSafeArea()
                            .onTapGesture {
                                self.popupContent = nil
                            }

                        Popup(title: popupContent.title, contentView: popupContent.content)
                            .frame(maxHeight: popupContent.maxHeight)
                            .padding(.horizontal, Constant.Padding.horizontalPadding)
                    }
                }
            }
        }
    }

    private func showCareerPopup() {
        guard let careerSystem else { return }

        popupContent = PopupConfiguration(
            title: Constant.CareerPopup.title,
            maxHeight: Constant.CareerPopup.maxHeight
        ) {
            CareerPopupView(
                careerSystem: careerSystem,
                user: user,
                onClose: {
                    popupContent = nil
                }
            )
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
