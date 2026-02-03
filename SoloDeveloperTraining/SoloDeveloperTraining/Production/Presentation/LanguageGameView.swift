//
//  LanguageGameView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    enum Padding {
        static let horizontal: CGFloat = 16
        static let toolBarBottom: CGFloat = 10
    }

    enum Spacing {
        static let itemHorizontal: CGFloat = 25
        static let buttonHorizontal: CGFloat = 17
    }

    enum Game {
        static let itemCount: Int = 5
        static let feverDecreaseInterval: Double = 0.1
        static let feverDecreasePercentPerTick: Double = 5
    }

    enum EffectLabel {
        static let offsetY: CGFloat = -34
    }
}

struct LanguageGameView: View {
    // MARK: Properties
    let user: User

    /// 게임에 사용되는 언어 타입 목록
    private let languageTypeList: [LanguageType] = [
        .swift,
        .kotlin,
        .dart,
        .python
    ]

    // MARK: State Properties
    /// 게임 시작 상태 (부모 뷰와 바인딩)
    @Binding var isGameStarted: Bool
    @Binding var isGameViewDisappeared: Bool

    /// 상태를 유지
    @State private var game: LanguageGame

    /// 획득한 골드를 표시하기 위한 효과 라벨 배열
    @State private var effectValues: [(id: UUID, value: Int)] = []

    /// 현재 진행 중인 언어 버튼 탭 Task
    @State private var currentActionTask: Task<Void, Never>?

    init(
        user: User,
        isGameStarted: Binding<Bool>,
        isGameViewDisappeared: Binding<Bool>,
        animationSystem: CharacterAnimationSystem? = nil
    ) {
        self._isGameStarted = isGameStarted
        self._isGameViewDisappeared = isGameViewDisappeared
        self.user = user

        // 게임 초기화
        let game = LanguageGame(
            user: user,
            feverSystem: .init(
                decreaseInterval: Constant.Game.feverDecreaseInterval,
                decreasePercentPerTick: Constant.Game.feverDecreasePercentPerTick
            ),
            buffSystem: .init(),
            itemCount: Constant.Game.itemCount,
            animationSystem: animationSystem
        )
        self._game = State(initialValue: game)
        self.game.startGame()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                // 상단 툴바 (닫기, 아이템 버튼, 피버 게이지)
                toolbarSection
                Spacer()
                // 중앙 언어 아이템 영역 (획득 골드 효과 포함)
                languageItemsSection
                Spacer()
                // 하단 언어 선택 버튼 영역
                languageButtonsSection
                Spacer()
            }
            .pauseGameStyle(
                isGameViewDisappeared: $isGameViewDisappeared,
                height: geometry.size.height,
                onLeave: { handleCloseButton() },
                onPause: { game.pauseGame() },
                onResume: { game.resumeGame() }
            )
        }
    }
}

// MARK: - View Components
private extension LanguageGameView {
    /// 상단 툴바
    var toolbarSection: some View {
        GameToolBar(
            closeButtonDidTapHandler: handleCloseButton,
            coffeeButtonDidTapHandler: { useConsumableItem(.coffee) },
            energyDrinkButtonDidTapHandler: { useConsumableItem(.energyDrink) },
            feverState: game.feverSystem,
            buffSystem: game.buffSystem,
            coffeeCount: .constant(game.user.inventory.count(.coffee) ?? 0),
            energyDrinkCount: .constant(game.user.inventory.count(.energyDrink) ?? 0)
        )
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.bottom, Constant.Padding.toolBarBottom)
    }

    /// 중앙 언어 아이템 영역
    var languageItemsSection: some View {
        HStack(alignment: .bottom, spacing: Constant.Spacing.itemHorizontal) {
            ForEach(Array(game.itemList.enumerated()), id: \.offset) { _, item in
                LanguageItem(
                    languageType: item.languageType,
                    state: item.state
                )
            }
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            // 획득한 골드를 표시하는 효과 라벨
            ZStack {
                ForEach(effectValues, id: \.id) { effect in
                    EffectLabel(value: effect.value) {
                        removeEffectLabel(id: effect.id)
                    }
                }
            }
            .offset(y: Constant.EffectLabel.offsetY)
        }
    }

    /// 하단 언어 선택 버튼 영역
    var languageButtonsSection: some View {
        HStack(spacing: Constant.Spacing.buttonHorizontal) {
            ForEach(languageTypeList, id: \.self) { type in
                LanguageButton(languageType: type) {
                    handleLanguageButtonTap(type)
                }
            }
        }
    }
}

// MARK: - Actions
private extension LanguageGameView {
    /// 닫기 버튼 클릭 처리
    func handleCloseButton() {
        // 진행 중인 액션 Task 취소
        currentActionTask?.cancel()
        currentActionTask = nil

        game.stopGame()
        isGameStarted = false
    }

    /// 언어 버튼 클릭 처리
    func handleLanguageButtonTap(_ type: LanguageType) {
        // 이전 액션이 진행 중이면 취소
        currentActionTask?.cancel()

        currentActionTask = Task {
            let gainedGold = await game.didPerformAction(type)

            // Task가 취소되었으면 UI 업데이트 생략
            guard !Task.isCancelled else { return }

            SoundService.shared.trigger(gainedGold > 0 ? .languageCorrect : .languageWrong)
            if gainedGold <= 0 {
                HapticService.shared.trigger(.error)
            }
            showEffectLabel(gainedGold: gainedGold)
        }
    }

    /// 소비 아이템 사용 처리
    func useConsumableItem(_ type: ConsumableType) {
        if game.user.inventory.drink(type) {
            SoundService.shared.trigger(.itemConsume)
            HapticService.shared.trigger(.success)
            game.buffSystem.useConsumableItem(type: type)
            game.user.record.record(type == .coffee ? .coffeeUse : .energyDrinkUse)
        }
    }
}

// MARK: - Helper Methods
private extension LanguageGameView {
    /// 획득한 골드를 표시하는 효과 라벨 추가
    /// - Parameter gainedGold: 획득한 골드 (음수일 경우 손실)
    func showEffectLabel(gainedGold: Int) {
        let effectId = UUID()
        effectValues.append((id: effectId, value: gainedGold))
    }

    /// 효과 라벨 제거 (애니메이션 완료 시 콜백으로 호출)
    /// - Parameter id: 제거할 효과 라벨의 ID
    func removeEffectLabel(id: UUID) {
        effectValues.removeAll { $0.id == id }
    }
}

#Preview {
    @Previewable @State var isGameStarted = true
    @Previewable @State var isGameViewDisappeared = true
    let user = User(
        nickname: "Test",
        wallet: .init(),
        inventory: .init(),
        record: .init(),
        skills: [
            .init(key: SkillKey(game: .language, tier: .beginner), level: 1000)
        ]
    )

    LanguageGameView(user: user, isGameStarted: $isGameStarted, isGameViewDisappeared: $isGameViewDisappeared, animationSystem: nil)
}
