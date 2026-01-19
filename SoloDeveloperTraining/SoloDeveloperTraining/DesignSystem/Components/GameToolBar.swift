//
//  GameToolBar.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/12/26.
//

import SwiftUI

private enum Constant {
    enum Size {
        static let closeButton = CGSize(width: 24, height: 24)
        static let coffeeIcon = CGSize(width: 22, height: 22)
        static let energyDrinkIcon = CGSize(width: 20, height: 22)
    }

    enum Spacing {
        static let toolBar: CGFloat = 20
        static let consumableItem: CGFloat = 6
        static let itemIconText: CGFloat = 2
    }

    static let itemCountLabelWidth: CGFloat = 16
    static let feverBarHeight: CGFloat = 15
    static let disabledAlpha: CGFloat = 0.3
}

struct GameToolBar: View {

    // MARK: - Properties
    /// 닫기 버튼 탭 핸들러
    let closeButtonDidTapHandler: () -> Void
    /// 커피 버튼 탭 핸들러
    let coffeeButtonDidTapHandler: () -> Void
    /// 에너지 드링크 버튼 탭 핸들러
    let energyDrinkButtonDidTapHandler: () -> Void

    /// 피버 상태 관리 객체
    let feverState: FeverState

    /// 버프 시스템
    let buffSystem: BuffSystem

    /// 커피 보유 개수
    let coffeeCount: Binding<Int>
    /// 에너지 드링크 보유 개수
    let energyDrinkCount: Binding<Int>

    var body: some View {
        HStack(spacing: Constant.Spacing.toolBar) {
            closeButton
            feverBar
            HStack(spacing: Constant.Spacing.consumableItem) {
                coffeeButton
                energyDrinkButton
            }
        }
    }
}

// MARK: - SubViews
private extension GameToolBar {
    /// 닫기 버튼
    var closeButton: some View {
        Button {
            closeButtonDidTapHandler()
        } label: {
            Image(.close)
                .resizable()
                .frame(
                    width: Constant.Size.closeButton.width,
                    height: Constant.Size.closeButton.height
                )
        }
    }

    /// 피버 게이지 바
    var feverBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 배경 바 (이전 단계 색상)
                Rectangle()
                    .frame(height: Constant.feverBarHeight)
                    .foregroundStyle(feverBarBackgroundColor)

                // 전경 바 (현재 단계 색상, 진행도에 따라 너비 변경)
                Rectangle()
                    .frame(
                        width: feverBarFillWidth(totalWidth: geometry.size.width),
                        height: Constant.feverBarHeight
                    )
                    .foregroundStyle(feverBarFillColor)

                // 피버 배수 텍스트
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

    /// 커피 아이템 버튼
    var coffeeButton: some View {
        Button {
            coffeeButtonDidTapHandler()
        } label: {
            HStack(spacing: Constant.Spacing.itemIconText) {
                Image(.coffee)
                    .resizable()
                    .frame(
                        width: Constant.Size.coffeeIcon.width,
                        height: Constant.Size.coffeeIcon.height
                    )
                Text("\(coffeeCount.wrappedValue)")
                    .textStyle(.caption2)
                    .foregroundStyle(.black)
                    .frame(width: Constant.itemCountLabelWidth)
            }
        }
        .disabled(isCoffeeBuffActive)
        .opacity(isCoffeeBuffActive ? Constant.disabledAlpha : 1.0)
    }

    /// 에너지 드링크 아이템 버튼
    var energyDrinkButton: some View {
        Button {
            energyDrinkButtonDidTapHandler()
        } label: {
            HStack(spacing: Constant.Spacing.itemIconText) {
                Image(.energyDrink)
                    .resizable()
                    .frame(
                        width: Constant.Size.energyDrinkIcon.width,
                        height: Constant.Size.energyDrinkIcon.height
                    )
                Text("\(energyDrinkCount.wrappedValue)")
                    .textStyle(.caption2)
                    .foregroundStyle(.black)
                    .frame(width: Constant.itemCountLabelWidth)
            }
        }
        .disabled(isEnergyDrinkBuffActive)
        .opacity(isEnergyDrinkBuffActive ? Constant.disabledAlpha : 1.0)
    }
}

// MARK: - Helper
private extension GameToolBar {
    /// 커피 버프 활성화 여부
    var isCoffeeBuffActive: Bool {
        buffSystem.coffeeDuration > 0
    }

    /// 에너지 드링크 버프 활성화 여부
    var isEnergyDrinkBuffActive: Bool {
        buffSystem.energyDrinkDuration > 0
    }

    /// 피버 바 전경 색상 (현재 단계)
    var feverBarFillColor: Color {
        switch feverState.feverStage {
        case 0: return .gray400
        case 1: return .accentYellow
        case 2: return .lightOrange
        case 3: return .accentRed
        default: return .gray400
        }
    }

    /// 피버 바 배경 색상 (이전 단계)
    var feverBarBackgroundColor: Color {
        switch feverState.feverStage {
        case 0: return .gray200
        case 1: return .gray400
        case 2: return .accentYellow
        case 3: return .lightOrange
        default: return .accentRed
        }
    }

    /// 현재 피버 단계 내에서의 진행도에 따른 바 너비 계산
    /// - Parameter totalWidth: 피버 바 전체 너비
    /// - Returns: 현재 진행도에 따른 바 너비
    func feverBarFillWidth(totalWidth: CGFloat) -> CGFloat {
        let currentPercent = feverState.feverPercent
        // 현재 단계 내에서의 진행도 (0.0 ~ 1.0)
        let progressRatio: Double

        switch currentPercent {
        case 0..<100:
            progressRatio = currentPercent / 100.0
        case 100..<200:
            progressRatio = (currentPercent - 100) / 100.0
        case 200..<300:
            progressRatio = (currentPercent - 200) / 100.0
        case 300...:
            progressRatio = min((currentPercent - 300) / 100.0, 1.0)
        default:
            progressRatio = 0
        }
        return totalWidth * progressRatio
    }
}

#Preview {
    @Previewable @State var coffeeCount: Int = 10
    @Previewable @State var drinkCount: Int = 10
    let feverSystem = FeverSystem(decreaseInterval: 0.1, decreasePercentPerTick: 3)
    let buffSystem = BuffSystem()

    VStack {
        Button {
            if !feverSystem.isRunning {
                feverSystem.start()
            }
            feverSystem.gainFever(20)
        } label: {
            Text("GainFever")
        }

        Button {
            buffSystem.useConsumableItem(type: .coffee)
        } label: {
            Text("Use Coffee")
        }

        Button {
            buffSystem.useConsumableItem(type: .energyDrink)
        } label: {
            Text("Use Energy Drink")
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
            buffSystem: buffSystem,
            coffeeCount: $coffeeCount,
            energyDrinkCount: $drinkCount
        )
        .padding()
    }
}
