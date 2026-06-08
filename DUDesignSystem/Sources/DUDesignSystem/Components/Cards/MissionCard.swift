//
//  MissionCard.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct MissionCard: View {
    
    public enum MissionTrophyType: String, CaseIterable {
        case gold    = "mission_trophy_gold"
        case silver  = "mission_trophy_silver"
        case bronze  = "mission_trophy_bronze"
        case special = "mission_trophy_special"
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
    public var rewardText: String
    public var trophy: MissionTrophyType
    public var condition: String
    public var state: MissionCardState
    public var action: () -> Void

    public init(
        title: String,
        rewardText: String,
        trophy: MissionTrophyType,
        condition: String,
        state: MissionCardState,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.rewardText = rewardText
        self.trophy = trophy
        self.condition = condition
        self.state = state
        self.action = action
    }

    public var body: some View {
        VStack(spacing: TokenSpacing.xs) {
            // 타이틀
            ItemLabel(text: title, icon: nil, size: .medium, color: .black)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 보상
            ItemLabel(text: rewardText, icon: .diamond, size: .small, color: .black)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 이미지
            Image(trophy.rawValue, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 97.5, height: 71)
                .opacity(state == .claimed ? TokenOpacity.opacity60 : TokenOpacity.opacity100)

            // 조건
            Text(condition)
                .duFont(.label)
                .foregroundStyle(Color.black300)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 30)

            // 상태 바
            stateBar
        }
        .padding(.top, TokenSpacing.mm)
        .padding(.horizontal, TokenSpacing.sm)
        .padding(.bottom, TokenSpacing.sm)
        .frame(width: 113.5)
        .background(Color.beige100)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        .onTapGesture { action() }
    }

    @ViewBuilder
    private var stateBar: some View {
        switch state {
        case .default(let current, let total):
            Text("\(current) / \(total)")
                .duFont(.label)
                .foregroundStyle(Color.black300)
                .frame(maxWidth: .infinity)
                .frame(height: 15)
                .background(Color.black300GrayBar)

        case .inProgress(let current, let total):
            let progress = total > 0 ? Double(current) / Double(total) : 0
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Color.black300GrayBar
                    Color.orange300
                        .frame(width: geo.size.width * progress)
                    Text("\(current) / \(total)")
                        .duFont(.label)
                        .foregroundStyle(Color.black300)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 15)

        case .claimable:
            Text("획득하기")
                .duFont(.label)
                .foregroundStyle(Color.black300)
                .frame(maxWidth: .infinity)
                .frame(height: 15)
                .background(Color.accentGreen)

        case .claimed:
            Text("달성완료")
                .duFont(.label)
                .foregroundStyle(Color.white300)
                .frame(maxWidth: .infinity)
                .frame(height: 15)
                .background(Color.beige400)
        }
    }
}

#Preview {
    HStack(spacing: TokenSpacing.sm) {
        MissionCard(
            title: "탭따구리",
            rewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .default(current: 0, total: 10000),
            action: {}
        )
        MissionCard(
            title: "탭따구리",
            rewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .inProgress(current: 9356, total: 10000),
            action: {}
        )
        MissionCard(
            title: "탭따구리",
            rewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .claimable,
            action: {}
        )
        MissionCard(
            title: "탭따구리",
            rewardText: "20",
            trophy: .gold,
            condition: "탭 10,000회 달성",
            state: .claimed,
            action: {}
        )
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
