
//
//  StoryCard.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/13/26.
//

import SwiftUI

public struct StoryCard: View {

    public enum StoryCardType: Equatable {
        case levelUp
        case ending(title: String)
        case endingDownload(title: String)

        var imageHeight: CGFloat {
            switch self {
            case .levelUp: return 560
            case .ending: return 408
            case .endingDownload: return 569
            }
        }
    }

    public let type: StoryCardType
    public let text: String
    public let imageName: String

    public init(type: StoryCardType, text: String, imageName: String) {
        self.type = type
        self.text = text
        self.imageName = imageName
    }

    public var body: some View {
        switch type {
        case .levelUp:
            cardContent

        case .ending(let title):
            VStack(spacing: TokenSpacing.none) {
                headerView(title: title)
                cardContent
            }
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
            .padding(.horizontal, TokenSpacing.lg)

        case .endingDownload(let title):
            VStack(spacing: TokenSpacing.none) {
                headerView(title: title)
                cardContent
            }
            .frame(width: 484)
        }
    }
}

// MARK: - Subviews
private extension StoryCard {
    var cardContent: some View {
        GeometryReader { geo in
            Image(imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: type.imageHeight)
                .clipped()
        }
        .frame(height: type.imageHeight)
        .overlay(alignment: .bottom) {
            TextBox(text: text)
        }
    }

    func headerView(title: String) -> some View {
        HStack {
            ItemLabel(
                text: "개발자 키우기",
                icon: .logo,
                iconSize: .size20,
                font: .subheadline,
                color: .lightOrange
            )

            Spacer()

            ItemLabel(
                text: title,
                font: .title2,
                color: .white300
            )
        }
        .padding(.all, TokenSpacing.lg)
        .frame(height: 76)
        .background(Color.gray700)
    }
}

#Preview {
    StoryCard(
        type: .levelUp,
        text: "테스트",
        imageName: "scenarioLevelupNormalDeveloper"
    )
}
