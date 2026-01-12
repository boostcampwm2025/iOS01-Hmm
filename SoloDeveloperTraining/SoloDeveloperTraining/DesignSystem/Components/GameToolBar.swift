//
//  GameToolBar.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/12/26.
//

import SwiftUI

struct GameToolBar: View {

    let closeButtonDidTapHandler: () -> Void
    let coffeeButtonDidTapHandler: () -> Void
    let energyDrinkButtonDidTapHandler: () -> Void

    let feverState: FeverState

    let coffeeCount: Binding<Int>
    let energyDrinkCount: Binding<Int>

    enum Constant {
        static let closeButtonWidth: CGFloat = 24
        static let closeButtonHeight: CGFloat = 24
        static let coffeeButtonWidth: CGFloat = 22
        static let coffeeButtonHeight: CGFloat = 22
        static let energyDrinkButtonWidth: CGFloat = 20
        static let energyDrinkButtonHeight: CGFloat = 22
        static let consumableItemCountWidth: CGFloat = 16
        static let feverBarHeight: CGFloat = 15
    }

    var body: some View {
        HStack(spacing: 20) {
            closeButton
            feverBar
            HStack(spacing: 6) {
                coffeeButton
                energyDrinkButton
            }
        }
    }

    var closeButton: some View {
        return Button {
            closeButtonDidTapHandler()
        } label: {
            Image(.close)
                .resizable()
                .frame(
                    width: Constant.closeButtonWidth,
                    height: Constant.closeButtonHeight
                )
        }
    }

    var feverBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 배경 (회색)
                Rectangle()
                    .frame(height: Constant.feverBarHeight)
                    .foregroundStyle(backgroundFeverColor)

                // 피버 게이지 - 현재 단계에 따라 색상 변경
                Rectangle()
                    .frame(
                        width: currentFeverBarWidth(totalWidth: geometry.size.width),
                        height: Constant.feverBarHeight
                    )
                    .foregroundStyle(currentFeverColor)

                // 피버 텍스트
                if feverState.feverStage != 0 {
                    Text(String(format: "Fever %.1fx !!", feverState.feverMultiplier))
                        .textStyle(.caption2)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: Constant.feverBarHeight)
    }

    /// 현재 피버 단계의 색상
    private var currentFeverColor: Color {
        switch feverState.feverStage {
        case 0:
            return .gray400
        case 1:
            return .accentYellow
        case 2:
            return .lightOrange
        case 3:
            return .accentRed
        default:
            return .gray400
        }
    }

    /// 배경 피버바의 색상
    private var backgroundFeverColor: Color {
        switch feverState.feverStage {
        case 0:
            return .gray200
        case 1:
            return .gray400
        case 2:
            return .accentYellow
        case 3:
            return .lightOrange
        default:
            return .accentRed
        }
    }

    /// 현재 피버 바 너비 (현재 단계 내에서의 진행도)
    private func currentFeverBarWidth(totalWidth: CGFloat) -> CGFloat {
        let percent = feverState.feverPercent
        // 현재 단계 내에서의 진행도 계산
        let progressInCurrentStage: Double

        switch percent {
        case 0..<100:
            progressInCurrentStage = percent / 100.0
        case 100..<200:
            progressInCurrentStage = (percent - 100) / 100.0
        case 200..<300:
            progressInCurrentStage = (percent - 200) / 100.0
        case 300...:
            progressInCurrentStage = min((percent - 300) / 100.0, 1.0)
        default:
            progressInCurrentStage = 0
        }
        return totalWidth * progressInCurrentStage
    }

    var coffeeButton: some View {
        return Button {
            coffeeButtonDidTapHandler()
        } label: {
            HStack(spacing: 2) {
                Image(.coffee)
                    .resizable()
                    .frame(
                        width: Constant.coffeeButtonWidth,
                        height: Constant.coffeeButtonHeight
                    )
                Text("\(coffeeCount.wrappedValue)")
                    .textStyle(.caption2)
                    .foregroundStyle(.black)
                    .frame(width: Constant.consumableItemCountWidth)
            }
        }
    }

    var energyDrinkButton: some View {
        return Button {
            energyDrinkButtonDidTapHandler()
        } label: {
            HStack(spacing: 2) {
                Image(.energyDrink)
                    .resizable()
                    .frame(
                        width: Constant.energyDrinkButtonWidth,
                        height: Constant.energyDrinkButtonHeight
                    )
                Text("\(energyDrinkCount.wrappedValue)")
                    .textStyle(.caption2)
                    .foregroundStyle(.black)
                    .frame(width: Constant.consumableItemCountWidth)
            }
        }
    }
}

#Preview {
    @Previewable @State var coffeeCount: Int = 10
    @Previewable @State var drinkCount: Int = 10
    let feverSystem = FeverSystem(decreaseInterval: 0.1, decreasePercentPerTick: 3)

    Button {
        if !feverSystem.isRunning {
            feverSystem.start()
        }
        feverSystem.gainFever(20)
    } label: {
        Text("GainFever")
    }

    GameToolBar(
        closeButtonDidTapHandler: {
            print("Close")
        },
        coffeeButtonDidTapHandler: {
            coffeeCount -= 1
        },
        energyDrinkButtonDidTapHandler: {
            drinkCount -= 1
        },
        feverState: feverSystem,
        coffeeCount: $coffeeCount,
        energyDrinkCount: $drinkCount
    )
    .padding()
}
