//
//  StatusBar.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct StatusBar: View {

    public var imageName: String
    public var careerName: String
    public var nickname: String
    public var careerProgress: Double
    public var gold: String
    public var diamond: String
    public var time: String?

    public init(
        imageName: String,
        careerName: String,
        nickname: String,
        careerProgress: Double,
        gold: String,
        diamond: String,
        time: String? = nil
    ) {
        self.imageName = imageName
        self.careerName = careerName
        self.nickname = nickname
        self.careerProgress = max(0, min(1, careerProgress))
        self.gold = gold
        self.diamond = diamond
        self.time = time
    }

    public var body: some View {
        HStack {
            HStack(spacing: TokenSpacing.sm) {
                Image(imageName, bundle: .module)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipped()

                VStack(alignment: .leading, spacing: TokenSpacing.xs) {
                    HStack(spacing: TokenSpacing.xs) {
                        ItemLabel(text: careerName, font: .caption, color: .black300)
                        ItemLabel(text: nickname, font: .caption, color: .black300)
                    }
                    careerProgressBar
                }
                .fixedSize(horizontal: true, vertical: false)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: TokenSpacing.xs) {
                HStack(spacing: TokenSpacing.xs) {
                    ItemLabel(text: gold, icon: .coinBag, iconSize: .size16, font: .caption, color: .black300)
                    ItemLabel(text: diamond, icon: .diamond, iconSize: .size16, font: .caption, color: .black300)
                }
                if let time {
                    HStack(spacing: TokenSpacing.xs) {
                        ItemLabel(text: "업무 효율 대박: ", font: .caption, color: .black300)
                        ItemLabel(text: time, font: .caption, color: .black300)
                    }
                }
            }
        }
    }

    private var careerProgressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black300PopUpDimStatusBar)
                Capsule()
                    .fill(Color.lightOrange)
                    .frame(width: geo.size.width * careerProgress)
            }
            .clipShape(Capsule())
        }
        .frame(height: 10)
    }
}

#Preview {
    VStack(spacing: TokenSpacing.lg) {
        StatusBar(
            imageName: "icon_coffee",
            careerName: "개발자 지망생",
            nickname: "소피아",
            careerProgress: 0.3,
            gold: "20,000",
            diamond: "20"
        )
        StatusBar(
            imageName: "icon_coffee",
            careerName: "개발자 지망생",
            nickname: "소피아",
            careerProgress: 0.7,
            gold: "20,000",
            diamond: "20",
            time: "04:34"
        )
    }
    .padding(TokenSpacing.lg)
    .background(Color.beige200)
}
