//
//  MainView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI
import SpriteKit

private enum Constant {
    static let characterSceneSize = CGSize(width: 100, height: 100)
    static let spriteViewSize = CGSize(width: 200, height: 200)
    static let topAreaHeightRatio: CGFloat = 0.5
}

enum AppTheme {
    static let backgroundColor: Color = AppColors.beige200
}

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedTab: TabItem = .work

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
                TabBar(selectedTab: $selectedTab)

                Group {
                    switch selectedTab {
                    case .work:
                        WorkSelectedView(user: user, animationSystem: animationSystem)
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
