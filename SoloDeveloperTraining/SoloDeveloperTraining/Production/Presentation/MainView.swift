//
//  MainView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI
import SpriteKit

enum AppTheme {
    static let backgroundColor: Color = AppColors.beige200
}

private enum Constant {
    static let characterSceneSize = CGSize(width: 100, height: 100)
    static let spriteViewSize = CGSize(width: 200, height: 200)
    static let topAreaHeightRatio: CGFloat = 0.5

    enum Padding {
        static let horizontalPadding: CGFloat = 25
    }

    enum Color {
        static let overlay = SwiftUI.Color.black.opacity(0.3)
    }

    enum CareerPopup {
        static let title: String = "커리어"
        static let maxHeight: CGFloat = 650
        static let contentHorizontalPadding: CGFloat = 16
        static let progressBarTopPadding: CGFloat = 18
        static let progressBarBottomPadding: CGFloat = 18
        static let careerRowSpacing: CGFloat = 10
        static let scrollViewBottomPadding: CGFloat = 45
    }
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: TabItem = .work
    @State private var popupContent: PopupConfiguration?

    private var autoGainSystem: AutoGainSystem
    private let user: User
    let careerProgress: Double = 0.3
    private let scene: CharacterScene
    private let animationSystem: CharacterAnimationSystem

    init(user: User) {
        self.autoGainSystem = AutoGainSystem(user: user)
        self.user = user

        self.scene = CharacterScene(size: Constant.characterSceneSize, user: user)
        self.scene.scaleMode = .aspectFit
        self.scene.playIdle()

        // 애니메이션 시스템 생성 및 클로저 연결
        self.animationSystem = CharacterAnimationSystem()
        self.animationSystem.onSmile = { [weak scene] in
            scene?.playSmile()
        }
        self.animationSystem.onIdle = { [weak scene] in
            scene?.playIdle()
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Color.clear
                    VStack(spacing: 0) {
                        StatusBar(
                            career: user.career,
                            nickname: user.nickname,
                            careerProgress: careerProgress,
                            gold: user.wallet.gold,
                            diamond: user.wallet.diamond
                        )
                        .onTapGesture {
                            showCareerPopup()
                        }
                        Spacer()
                        SpriteView(scene: scene, options: [.allowsTransparency])
                            .frame(width: Constant.spriteViewSize.width, height: Constant.spriteViewSize.height)
                            .background(Color.clear)
                        Spacer()
                    }
                }
                .frame(height: geometry.size.height * Constant.topAreaHeightRatio)
                .background(
                    Image(user.inventory.housing.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )

                // 탭바
                TabBar(
                    selectedTab: $selectedTab,
                    hasCompletedMisson: user.record
                        .missionSystem.hasCompletedMission)

                Group {
                    switch selectedTab {
                    case .work:
                        WorkSelectedView(user: user, animationSystem: animationSystem)
                    case .enhance:
                        EnhanceView(user: user, popupContent: $popupContent)
                    case .shop:
                        ShopView(user: user, popupContent: $popupContent)
                    case .mission:
                        MissionView(user: user)
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
        popupContent = PopupConfiguration(
            title: Constant.CareerPopup.title,
            maxHeight: Constant.CareerPopup.maxHeight
        ) {
            VStack(alignment: .center, spacing: 0) {
                CareerProgressBar(
                    career: user.career,
                    currentGold: user.wallet.gold
                )
                .padding(.bottom, Constant.CareerPopup.progressBarBottomPadding)
                .padding(.top, Constant.CareerPopup.progressBarTopPadding)

                ScrollView {
                    VStack(spacing: Constant.CareerPopup.careerRowSpacing) {
                        ForEach(Career.allCases, id: \.self) { career in
                            CareerRow(
                                career: career,
                                userCareer: user.career
                            )
                        }
                    }
                }
                .scrollIndicators(.never)
                .padding(.bottom, Constant.CareerPopup.scrollViewBottomPadding)

                MediumButton(title: "닫기", isFilled: true) {
                    popupContent = nil
                }
            }
            .padding(.horizontal, Constant.CareerPopup.contentHorizontalPadding)
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
