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

    let coffeeCount: Binding<Int>
    let energyDrinkCount: Binding<Int>

    enum Constant {
        static let closeButtonWidth: CGFloat = 24
        static let closeButtonHeight: CGFloat = 24
        static let coffeeButtonWidth: CGFloat = 22
        static let coffeeButtonHeight: CGFloat = 22
        static let energyDrinkButtonWidth: CGFloat = 20
        static let energyDrinkButtonHeight: CGFloat = 22
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
                Text("5")
                    .textStyle(.caption2)
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
                Text("5")
                    .textStyle(.caption2)
            }
        }
    }
}

#Preview {
    GameToolBar(
        closeButtonDidTapHandler: {
            print("Close")
        },
        coffeeButtonDidTapHandler: {
            print("Coffee")
        },
        energyDrinkButtonDidTapHandler: {
            print("energyDrink")
        },
        coffeeCount: .constant(10),
        energyDrinkCount: .constant(10)
    )
    .padding()
}
