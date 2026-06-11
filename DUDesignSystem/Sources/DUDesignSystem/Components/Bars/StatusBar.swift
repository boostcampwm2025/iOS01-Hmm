//
//  StatusBar.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct StatusBar: View {

    public var imageName: String
    public var careerNickname: String
    public var careerProgress: Double
    public var gold: String
    public var diamond: String

    public init(
        imageName: String,
        careerNickname: String,
        careerProgress: Double,
        gold: String,
        diamond: String
    ) {
        self.imageName = imageName
        self.careerNickname = careerNickname
        self.careerProgress = max(0, min(1, careerProgress))
        self.gold = gold
        self.diamond = diamond
    }

    public var body: some View {
        HStack {
            HStack(spacing: TokenSpacing.sm) {
                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(Color.black300)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.ss))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(careerNickname)
                        .duFont(.caption)
                        .foregroundStyle(Color.black300)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    careerProgressBar
                }
            }

            Spacer()

            HStack(spacing: TokenSpacing.xs) {
                ItemLabel(text: gold, icon: .coinBag, iconSize: .size16, font: .caption, color: .black300)
                ItemLabel(text: diamond, icon: .diamond, iconSize: .size16, font: .caption, color: .black300)
            }
        }
    }

    private var careerProgressBar: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.black300PopUpDimStatusBar)
                .frame(width: 101, height: 10)

            Capsule()
                .fill(Color.lightOrange)
                .frame(width: 101 * careerProgress, height: 10)
        }
        .frame(width: 101, height: 10)
    }
}

#Preview {
    VStack(spacing: TokenSpacing.lg) {
        StatusBar(
            imageName: "icon_coffee",
            careerNickname: "개발자 지망생 소피아",
            careerProgress: 0.3,
            gold: "20,000",
            diamond: "20"
        )
        StatusBar(
            imageName: "icon_coffee",
            careerNickname: "개발자 지망생 소피아",
            careerProgress: 0.7,
            gold: "20,000",
            diamond: "20"
        )
    }
    .padding(TokenSpacing.lg)
    .background(Color.beige200)
}
