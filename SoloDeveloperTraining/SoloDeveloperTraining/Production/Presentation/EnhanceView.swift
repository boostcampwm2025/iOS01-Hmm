//
//  EnhanceView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-20.
//

import SwiftUI

private enum Constant {
    static let horizontalPadding: CGFloat = 16
    static let itemCardSpacing: CGFloat = 12
    static let popupContentSpacing: CGFloat = 20
}

struct EnhanceView: View {
    private let user: User
    private let skillSystem: SkillSystem

    init(user: User) {
        self.user = user
        self.skillSystem = SkillSystem(user: user)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Constant.itemCardSpacing) {
                ForEach(skillSystem.skillList(), id: \.skill.key) { skillState in
                    ItemRow(
                        title: skillState.skill.title,
                        description: "획득 골드 +\(Int(skillState.skill.gainGold).formatted())",
                        imageName: skillState.skill.imageName,
                        cost: skillState.skill.upgradeCost,
                        state: skillState.itemState
                    ) {
                        try? skillSystem.upgrade(skill: skillState.skill)
                    }
                }
            }
        }
        .padding(.bottom)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    let user = User(
        nickname: "테스트",
        wallet: .init(gold: 110, diamond: 100),
        inventory: .init(),
        record: .init(),
        skills: [
            // 코드짜기
            .init(key: SkillKey(game: .tap, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .tap, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .tap, tier: .advanced), level: 1),
            // 언어 맞추기
            .init(key: SkillKey(game: .language, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .language, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .language, tier: .advanced), level: 1),
            // 버그 피하기
            .init(key: SkillKey(game: .dodge, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .dodge, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .dodge, tier: .advanced), level: 1),
            // 물건 쌓기
            .init(key: SkillKey(game: .stack, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .stack, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .stack, tier: .advanced), level: 1)
        ]
    )

    EnhanceView(user: user)
}
