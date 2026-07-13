//
//  GameToolBar.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct GameToolBar: View {

    /// 피버 단계 (0~3)
    public var feverStage: Int
    /// 현재 단계 내 진행도 (0.0 ~ 1.0)
    public var feverProgress: Double
    /// 피버 배수 텍스트 (0이면 미표시)
    public var feverMultiplier: Double
    /// 커피 보유 개수
    public var coffeeCount: Int
    /// 에너지드링크 보유 개수
    public var energyDrinkCount: Int
    /// 커피 쿨다운 진행도 (0.0 = 사용 가능, 1.0 = 쿨다운 시작 직후)
    public var coffeeCooldown: Double
    /// 에너지드링크 쿨다운 진행도 (0.0 = 사용 가능, 1.0 = 쿨다운 시작 직후)
    public var energyDrinkCooldown: Double

    public var onClose: () -> Void
    public var onCoffee: () -> Void
    public var onEnergyDrink: () -> Void

    public init(
        feverStage: Int,
        feverProgress: Double,
        feverMultiplier: Double = 0,
        coffeeCount: Int,
        energyDrinkCount: Int,
        coffeeCooldown: Double = 0,
        energyDrinkCooldown: Double = 0,
        onClose: @escaping () -> Void,
        onCoffee: @escaping () -> Void,
        onEnergyDrink: @escaping () -> Void
    ) {
        self.feverStage = feverStage
        self.feverProgress = max(0, min(1, feverProgress))
        self.feverMultiplier = feverMultiplier
        self.coffeeCount = coffeeCount
        self.energyDrinkCount = energyDrinkCount
        self.coffeeCooldown = max(0, min(1, coffeeCooldown))
        self.energyDrinkCooldown = max(0, min(1, energyDrinkCooldown))
        self.onClose = onClose
        self.onCoffee = onCoffee
        self.onEnergyDrink = onEnergyDrink
    }

    private var fillColor: Color {
        switch feverStage {
        case 0: return Color.gray400
        case 1: return Color.accentYellow
        case 2: return Color.lightOrange
        case 3: return Color.accentRed
        default: return Color.gray400
        }
    }

    private var backgroundColor: Color {
        switch feverStage {
        case 0: return Color.black300GrayBar
        case 1: return Color.gray400
        case 2: return Color.accentYellow
        case 3: return Color.lightOrange
        default: return Color.black300GrayBar
        }
    }

    public var body: some View {
        HStack(spacing: TokenSpacing.sm) {
            Button(action: onClose) {
                DUIcon(.close, size: .size24)
            }

            feverBar

            HStack(spacing: TokenSpacing.sm) {
                Spacer()
                itemButton(icon: .coffee,
                           count: coffeeCount,
                           cooldown: coffeeCooldown,
                           action: onCoffee)
                itemButton(icon: .energyDrink,
                           count: energyDrinkCount,
                           cooldown: energyDrinkCooldown,
                           action: onEnergyDrink)
            }
            .frame(width: 114)
        }
        .padding(.horizontal, TokenSpacing.md)
    }

    private var feverBar: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(backgroundColor)
                    .frame(height: 16)

                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(fillColor)
                    .frame(width: geo.size.width * feverProgress, height: 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if feverMultiplier > 0 {
                    ItemLabel(text: String(format: "Fever %.1fx !!", feverMultiplier), font: .caption, color: .white300)
                }
            }
        }
        .frame(height: 16)
    }

    private func itemButton(icon: DUIconName, count: Int, cooldown: Double, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ItemLabel(text: "\(count)", icon: icon, iconSize: .size24, font: .caption, color: .black300)
                .mask(
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            Rectangle()
                                .opacity(TokenOpacity.opacity20)
                                .frame(height: geometry.size.height * cooldown)
                            Rectangle()
                                .opacity(TokenOpacity.opacity100)
                                .frame(height: geometry.size.height * (1 - cooldown))
                        }
                    }
                )
        }
        .disabled(cooldown > 0)
    }
}

#Preview {
    VStack(spacing: TokenSpacing.lg) {
        GameToolBar(feverStage: 0, feverProgress: 0, coffeeCount: 999, energyDrinkCount: 999, onClose: {}, onCoffee: {}, onEnergyDrink: {})
        GameToolBar(feverStage: 0, feverProgress: 0.5, coffeeCount: 999, energyDrinkCount: 999, onClose: {}, onCoffee: {}, onEnergyDrink: {})
        GameToolBar(feverStage: 1, feverProgress: 0.8, feverMultiplier: 0.8, coffeeCount: 999, energyDrinkCount: 999, coffeeCooldown: 0.3, energyDrinkCooldown: 0.7, onClose: {}, onCoffee: {}, onEnergyDrink: {})
        GameToolBar(feverStage: 2, feverProgress: 0.5, feverMultiplier: 2.0, coffeeCount: 999, energyDrinkCount: 999, coffeeCooldown: 1.0, energyDrinkCooldown: 0.0, onClose: {}, onCoffee: {}, onEnergyDrink: {})
        GameToolBar(feverStage: 3, feverProgress: 0.3, feverMultiplier: 3.0, coffeeCount: 999, energyDrinkCount: 999, coffeeCooldown: 0.0, energyDrinkCooldown: 1.0, onClose: {}, onCoffee: {}, onEnergyDrink: {})
    }
    .padding(TokenSpacing.lg)
    .background(Color.beige200)
}
