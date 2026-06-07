//
//  ComponentGameToolBarView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentGameToolBarView: View {

    @State private var feverStage: Int = 0
    @State private var feverProgress: Double = 0.0
    @State private var coffeeCount: Int = 5
    @State private var energyDrinkCount: Int = 3

    private var feverMultiplier: Double {
        feverStage == 0 ? 0 : Double(feverStage) * 1.0
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                GameToolBar(
                    feverStage: feverStage,
                    feverProgress: feverProgress,
                    feverMultiplier: feverMultiplier,
                    coffeeCount: coffeeCount,
                    energyDrinkCount: energyDrinkCount,
                    onClose: {},
                    onCoffee: {},
                    onEnergyDrink: {}
                )
            }

            // MARK: - Controls
            List {
                Section("피버 단계") {
                    Picker("단계", selection: $feverStage) {
                        Text("0").tag(0)
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section("피버 진행도") {
                    Slider(value: $feverProgress, in: 0...1)
                    Text("\(Int(feverProgress * 100))%")
                        .foregroundStyle(Color.gray400)
                }

                Section("아이템 개수") {
                    Stepper("커피: \(coffeeCount)", value: $coffeeCount, in: 0...999)
                    Stepper("에너지드링크: \(energyDrinkCount)", value: $energyDrinkCount, in: 0...999)
                }

                Section {
                    Text("상태 변경이나 유효성 검사는 비즈니스 로직이므로 예시 앱에는 반영되지 않아요.")
                        .font(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("GameToolBar")
    }
}

#Preview {
    NavigationStack {
        ComponentGameToolBarView()
    }
}
