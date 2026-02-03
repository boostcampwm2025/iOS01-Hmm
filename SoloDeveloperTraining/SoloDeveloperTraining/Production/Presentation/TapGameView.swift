//
//  TapGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/14/26.
//

import SwiftUI

private enum Constant {
    enum Padding {
        static let horizontal: CGFloat = 16
        static let toolBarBottom: CGFloat = 10
    }
    /// 탭 사운드 최소 재생 간격 (초)
    static let tapSoundThrottleInterval: TimeInterval = 0.05
}

struct TapGameView: View {
    // MARK: - Properties
    /// 게임 시작 상태 (부모 뷰와 바인딩)
    @Binding var isGameStarted: Bool
    @Binding var isGameViewDisappeared: Bool

    // MARK: - State
    /// 의존 게임
    @State private var tapGame: TapGame
    /// 터치한 위치에 표시될 EffectLabel들의 위치와 값
    @State private var effectLabels: [EffectLabelData] = []
    /// 탭 사운드 쓰로틀용 마지막 재생 시각
    @State private var lastTapSoundTime: Date = .distantPast

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        isGameViewDisappeared: Binding<Bool>,
        animationSystem: CharacterAnimationSystem?
    ) {
        let tapGame = TapGame(
            user: user,
            buffSystem: BuffSystem(),
            animationSystem: animationSystem
        )
        self._tapGame = State(initialValue: tapGame)
        self._isGameStarted = isGameStarted
        self._isGameViewDisappeared = isGameViewDisappeared
        self.tapGame.startGame()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 상단 툴바 (닫기, 아이템 버튼, 피버 게이지)
                toolbarSection
                // 터치 가능한 게임 영역
                tapAreaSection(geometry: geometry)
            }
            .pauseGameStyle(
                isGameViewDisappeared: $isGameViewDisappeared,
                height: geometry.size.height,
                onLeave: { handleCloseButton() },
                onPause: {
                    tapGame.pauseGame()
                    SoundService.shared.stopAllSFX()
                    lastTapSoundTime = .distantPast
                },
                onResume: { tapGame.resumeGame() }
            )
        }
    }
}

// MARK: - View Components
private extension TapGameView {
    /// 상단 툴바
    var toolbarSection: some View {
        GameToolBar(
            closeButtonDidTapHandler: handleCloseButton,
            coffeeButtonDidTapHandler: { useConsumableItem(.coffee) },
            energyDrinkButtonDidTapHandler: { useConsumableItem(.energyDrink) },
            feverState: tapGame.feverSystem,
            buffSystem: tapGame.buffSystem,
            coffeeCount: Binding(
                get: { tapGame.inventory.count(.coffee) ?? 0 },
                set: { _ in }
            ),
            energyDrinkCount: Binding(
                get: { tapGame.inventory.count(.energyDrink) ?? 0 },
                set: { _ in }
            )
        )
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.bottom, Constant.Padding.toolBarBottom)
    }

    /// 터치 가능한 게임 영역
    func tapAreaSection(geometry: GeometryProxy) -> some View {
        ZStack {
            // 배경 이미지
            Image(.tapBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)

            // 효과 라벨들
            ForEach(effectLabels) { effectLabel in
                EffectLabel(
                    value: effectLabel.value,
                    onComplete: { removeEffectLabel(id: effectLabel.id) }
                )
                .position(effectLabel.position)
            }

            // 멀티터치 뷰
            MultiTouchView { location in
                Task { await handleTap(at: location) }
            }
        }
    }
}

// MARK: - Actions
private extension TapGameView {
    /// 닫기 버튼 클릭 처리
    func handleCloseButton() {
        tapGame.stopGame()
        isGameStarted = false
    }

    /// 터치 이벤트 처리
    /// - Parameter location: 터치한 위치
    @MainActor
    func handleTap(at location: CGPoint) async {
        let now = Date()
        if !tapGame.isPaused,
           now.timeIntervalSince(lastTapSoundTime) >= Constant.tapSoundThrottleInterval {
            SoundService.shared.trigger(.tapGameTyping)
            lastTapSoundTime = now
        }
        let gainGold = await tapGame.didPerformAction()
        showEffectLabel(at: location, value: gainGold)
    }

    /// 소비 아이템 사용 처리
    func useConsumableItem(_ type: ConsumableType) {
        if tapGame.inventory.drink(type) {
            SoundService.shared.trigger(.itemConsume)
            HapticService.shared.trigger(.success)
            tapGame.buffSystem.useConsumableItem(type: type)
            tapGame.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
        }
    }
}

// MARK: - Helper Methods
private extension TapGameView {
    /// 터치 위치에 효과 라벨 추가
    /// - Parameters:
    ///   - location: 터치한 위치
    ///   - value: 표시할 값
    func showEffectLabel(at location: CGPoint, value: Int) {
        let labelData = EffectLabelData(
            id: UUID(),
            position: location,
            value: value
        )
        effectLabels.append(labelData)
    }

    /// 효과 라벨 제거 (애니메이션 완료 시 콜백으로 호출)
    /// - Parameter id: 제거할 효과 라벨의 ID
    func removeEffectLabel(id: UUID) {
        effectLabels.removeAll { $0.id == id }
    }
}

#Preview {
    @Previewable @State var isGameStarted: Bool = true
    @Previewable @State var isGameViewDisappeared: Bool = true

    let user = User(
        nickname: "Preview User",
        wallet: Wallet(gold: 10000, diamond: 50),
        inventory: Inventory(
            consumableItems: [
                Consumable(type: .coffee, count: 5),
                Consumable(type: .energyDrink, count: 3)
            ]
        ),
        record: Record(),
        skills: [
            Skill(key: SkillKey(game: .tap, tier: .beginner), level: 10),
            Skill(key: SkillKey(game: .tap, tier: .intermediate), level: 5)
        ]
    )

    TapGameView(
        user: user,
        isGameStarted: $isGameStarted,
        isGameViewDisappeared: $isGameViewDisappeared,
        animationSystem: nil
    )
}
