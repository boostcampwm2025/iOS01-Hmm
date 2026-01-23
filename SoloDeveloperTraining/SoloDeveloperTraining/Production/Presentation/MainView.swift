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
    }

    enum QuizButton {
        static let top: CGFloat = 128
        static let trailing: CGFloat = 16
    }
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: TabItem = .work
    @State private var popupContent: PopupConfiguration?
    @State private var careerSystem: CareerSystem?
    @State private var showQuizView: Bool = false

    private var autoGainSystem: AutoGainSystem
    private let user: User
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
                            career: careerSystem?.currentCareer ?? .unemployed,
                            nickname: user.nickname,
                            careerProgress: careerSystem?.careerProgress ?? 0.0,
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
                    }
                    VStack {
                        Spacer()
                        HStack {
                            FeedbackSettingView()
                                .padding()
                            Spacer()
                        }

                    // 퀴즈 버튼 추가
                    VStack {
                        HStack {
                            Spacer()
                            SmallButton(title: "퀴즈", hasBadge: true) {
                                showQuizView = true
                            }
                        }
                        .padding(.top, Constant.QuizButton.top)
                        .padding(.trailing, Constant.QuizButton.trailing)

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
            .onAppear {
                autoGainSystem.startSystem()
                Task {
                    if careerSystem == nil {
                        careerSystem = await CareerSystem(user: user)
                        careerSystem?.onCareerChanged = { [weak scene] newCareer in
                            scene?.updateCareerAppearance(to: newCareer)
                        }
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
            .fullScreenCover(isPresented: $showQuizView) {
                QuizGameView(user: user)
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
