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

    let feverPercent: Binding<Double>
    let feverMultiplier: Binding<Double>
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
    }

    var body: some View {
        HStack(spacing: 20) {
            closeButton
            Rectangle()
                .frame(height: 15)
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
    @Previewable @State var feverPercent: Double = 0
    @Previewable @State var feverMultiplier: Double = 0

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
        feverPercent: $feverPercent,
        feverMultiplier: $feverMultiplier,
        coffeeCount: $coffeeCount,
        energyDrinkCount: $drinkCount
    )
    .padding()
}
