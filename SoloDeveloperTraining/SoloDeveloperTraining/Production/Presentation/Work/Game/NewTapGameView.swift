//
//  NewTapGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/14/26.
//

import SwiftUI

import DUDesignSystem

struct NewTapGameView: View {
    @State private var effectLabels: [EffectLabelData] = []

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                toolbarSection
                tapAreaSection(geometry: geometry)
            }
        }
    }
}

// MARK: - Sections
private extension NewTapGameView {

    var toolbarSection: some View {
        GameToolBar(
            feverStage: 0,
            feverProgress: 0,
            feverMultiplier: 0,
            coffeeCount: 0,
            energyDrinkCount: 0,
            onClose: { },
            onCoffee: { },
            onEnergyDrink: { }
        )
        .padding(.bottom, TokenSpacing.md)
    }

    func tapAreaSection(geometry: GeometryProxy) -> some View {
        ZStack {
            // TODO: DUAssets에서 불러오기
            Image(.tapBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)

            ForEach(effectLabels) { data in
                EffectLabel(type: .plus, text: "\(data.value)") {
                    removeEffectLabel(id: data.id)
                }
                .position(data.position)
            }

            MultiTouchView { location in
                addEffectLabel(at: location)
            }
        }
    }
}

// MARK: - Helper
private extension NewTapGameView {
    func addEffectLabel(at location: CGPoint) {
        let data = EffectLabelData(id: UUID(), position: location, value: 0)
        effectLabels.append(data)
    }

    func removeEffectLabel(id: UUID) {
        effectLabels.removeAll { $0.id == id }
    }
}

#Preview {
    NewTapGameView()
        .frame(height: 100)
}
