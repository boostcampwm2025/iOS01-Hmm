//
//  TapGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/14/26.
//

import SwiftUI

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
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            ZStack {
                Image("background_tapGame")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

                ForEach(effectLabels) { effectLabel in
                    EffectLabel(value: effectLabel.value)
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
        let id = UUID()
        let labelData = EffectLabelData(id: id, position: location, value: value)
        effectLabels.append(labelData)

        // 애니메이션 종료 후 제거
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            effectLabels.removeAll { $0.id == id }
        }
    }
}
