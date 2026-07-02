//
//  MissionCard.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct MissionCard: View {

    public enum MissionTrophyType: String, CaseIterable {
        case gold    = "missionTrophyGold"
        case silver  = "missionTrophySilver"
        case bronze  = "missionTrophyBronze"
        case special = "missionTrophySpecial"
    }

    public enum MissionCardState: Equatable {
        /// 단순 진행 수치 표시 (텍스트만)
        case `default`(current: Int, total: Int)
        /// 프로그래스 바로 진행도 표시
        case inProgress(current: Int, total: Int)
        case claimable
        case claimed
    }

    public var title: String
    public var goldRewardText: String?
    public var diamondRewardText: String?
    public var trophy: MissionTrophyType
    public var condition: String
    public var state: MissionCardState
    public var action: () -> Void

    public init(
        title: String,
        goldRewardText: String? = nil,
        diamondRewardText: String? = nil,
        trophy: MissionTrophyType,
        condition: String,
        state: MissionCardState,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.goldRewardText = goldRewardText
        self.diamondRewardText = diamondRewardText
        self.trophy = trophy
        self.condition = condition
        self.state = state
        self.action = action
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.sm) {
            VStack(spacing: TokenSpacing.xs) {
                ItemLabel(text: title, font: .subheadline, color: .black300)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: TokenSpacing.sm) {
                    if let gold = goldRewardText {
                        ItemLabel(text: gold, icon: .coinBag, iconSize: .size16, font: .caption, color: .black300)
                    }
                    if let diamond = diamondRewardText {
                        ItemLabel(text: diamond, icon: .diamond, iconSize: .size16, font: .caption, color: .black300)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Image(trophy.rawValue, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 97.5, height: 71)
                .opacity(state == .claimed ? TokenOpacity.opacity60 : TokenOpacity.opacity100)

            ItemLabel(text: condition, font: .label, color: .black300)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 32)

            stateBar
        }
        .padding(.top, TokenSpacing.mm)
        .padding(.horizontal, TokenSpacing.sm)
        .padding(.bottom, TokenSpacing.sm)
        .frame(maxWidth: .infinity)
        .background(state == .claimable ? Color.beige50 : Color.beige100)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        .onTapGesture { action() }
    }

    @ViewBuilder
    private var stateBar: some View {
        switch state {
        case .default(let current, let total):
            ZStack {
                Color.black300GrayBar
                ItemLabel(text: "\(current) / \(total)", font: .label, color: .black300)
            }
            .frame(maxWidth: .infinity, minHeight: 16, maxHeight: 16)

        case .inProgress(let current, let total):
            let progress = total > 0 ? Double(current) / Double(total) : 0
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Color.black300GrayBar
                    Color.orange200
                        .frame(width: geo.size.width * progress)
                    ItemLabel(text: "\(current) / \(total)", font: .label, color: .black300)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 16)

        case .claimable:
            ZStack {
                Color.accentGreen
                ItemLabel(text: "획득하기", font: .label, color: .black300)
            }
            .frame(maxWidth: .infinity, minHeight: 16, maxHeight: 16)

        case .claimed:
            ZStack {
                Color.beige400
                ItemLabel(text: "달성완료", font: .label, color: .white300)
            }
            .frame(maxWidth: .infinity, minHeight: 16, maxHeight: 16)
        }
    }
}

#Preview {
    HStack(spacing: TokenSpacing.sm) {
        MissionCard(
            title: "탭따구리",
            diamondRewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .default(current: 0, total: 10000),
            action: {}
        )
        MissionCard(
            title: "탭따구리",
            diamondRewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .inProgress(current: 9356, total: 10000),
            action: {}
        )
        MissionCard(
            title: "탭따구리",
            diamondRewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .claimable,
            action: {}
        )
        MissionCard(
            title: "탭따구리",
            diamondRewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .claimed,
            action: {}
        )
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
