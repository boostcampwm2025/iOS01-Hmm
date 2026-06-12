
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
        Group {
            switch type {
            case .levelUp:
                cardContent

            case .ending(let title):
                VStack(spacing: TokenSpacing.none) {
                    headerView(title: title)
                    cardContent
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
    }
}

// MARK: - Subviews
private extension StoryCard {
    var cardContent: some View {
        Image(imageName, bundle: .module)
            .resizable()
            .scaledToFill()
            .overlay(alignment: .bottom) {
                TextBox(text: text)
                    .padding([.horizontal, .bottom], TokenSpacing.lg)
            }
    }

    func headerView(title: String) -> some View {
        HStack {
            ItemLabel(
                text: "개발자 키우기",
                icon: .new,
                iconSize: .size20,
                font: .subheadline,
                color: .orange300
            )

            Spacer()

            ItemLabel(
                text: title,
                font: .title2,
                color: .white300
            )
        }
        .padding(.all, TokenSpacing.lg)
        .background(Color.gray700)
    }
}

#Preview {
    StoryCard(
        type: .levelUp,
        text: "테스트",
        imageName: "scenario_levelup_normal_developer"
    )
}
