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
        static let toolBarBottom: CGFloat = 14
    }
}

struct TapGameView: View {
    // MARK: - Properties
    /// 의존 게임
    let tapGame: TapGame
    /// 닫기 버튼 핸들러
    let onClose: () -> Void

    // MARK: - State
    /// 터치한 위치에 표시될 EffectLabel들의 위치와 값
    @State private var effectLabels: [EffectLabelData] = []

    var body: some View {
        VStack(spacing: 0) {
            GameToolBar(
                closeButtonDidTapHandler: { onClose() },
                coffeeButtonDidTapHandler: {
                    handleItemButtonTap(type: .coffee)
                },
                energyDrinkButtonDidTapHandler: {
                    handleItemButtonTap(type: .energyDrink)
                },
                feverState: tapGame.feverSystem,
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

            ZStack {
                Image("background_tapGame")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

                ForEach(effectLabels) { effectLabel in
                    EffectLabel(
                        value: effectLabel.value,
                        onComplete: { effectLabels.removeAll { $0.id == effectLabel.id } }
                    )
                    .position(effectLabel.position)
                }
            }
            // 터치 가능한 영역 정의
            .contentShape(Rectangle())
            .onTapGesture { location in
                Task { await handleTap(at: location) }
            }
        }
    }
}

// MARK: - Private Methods
private extension TapGameView {
    /// 소비 아이템 버튼 탭 처리
    func handleItemButtonTap(type: ConsumableType) {
        let success = tapGame.inventory.drink(type)

        if success {
            // 버프 시스템에 아이템 사용 알림
            tapGame.buffSystem.useConsumableItem(type: type)
        }
    }

    /// 터치 이벤트 처리
    /// - Parameter location: 터치한 위치
    @MainActor
    func handleTap(at location: CGPoint) async {
        let gainGold = await tapGame.didPerformAction()
        addEffectLabel(at: location, value: gainGold)
    }

    /// 터치 위치에 EffectLabel 추가
    /// - Parameters:
    ///   - location: 터치한 위치
    ///   - value: 표시할 값
    func addEffectLabel(at location: CGPoint, value: Int) {
        let labelData = EffectLabelData(
            id: UUID(),
            position: location,
            value: value
        )
        effectLabels.append(labelData)
    }
}

#Preview {
    let tapGame = TapGame(
        user: User(
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
                Skill(game: .tap, tier: .beginner, level: 10),
                Skill(game: .tap, tier: .intermediate, level: 5)
            ]
        ),
        calculator: Calculator(),
        feverSystem: FeverSystem(decreaseInterval: 0.1, decreasePercentPerTick: 3),
        buffSystem: BuffSystem()
    )

    tapGame.startGame()

    return TapGameView(tapGame: tapGame, onClose: {}).frame(width: 300, height: 300)
}
