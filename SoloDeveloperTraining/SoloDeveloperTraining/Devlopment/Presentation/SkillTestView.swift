//
//  SkillTestView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/20/26.
//

import SwiftUI

struct SkillTestView: View {
    let user: User
    let skillSystem: SkillSystem
    let calculator: Calculator

    init(user: User, calculator: Calculator) {
        self.user = user
        self.skillSystem = .init(user: user)
        self.calculator = calculator
    }
    var body: some View {
        VStack {
            Text("보유 골드: \(user.wallet.gold)")
            Text("보유 다이아: \(user.wallet.diamond)")
            Text("초당 획득 골드: \(calculator.calculateGoldPerSecond(user: user))")

            List(skillSystem.skillList(), id: \.skill) { skillState in
                itemRowView(skillState)
            }
        }
    }
}

private extension SkillTestView {
    func itemRowView(_ skillState: SkillState) -> some View {

        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(
                        "\(skillState.skill.key.game.displayTitle) " +
                        "\(skillState.skill.key.tier.displayTitle) " +
                        "Lv.\(skillState.skill.level)"
                    )
                    if skillState.locked {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text("획득 재화 \(skillState.skill.gainGold.formatted())")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if skillState.locked {
                    Text(unlockConditionText(skillState.skill))
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
            }

            Spacer()

            Button {
                do {
                    try skillSystem.buy(skill: skillState.skill)
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                VStack(alignment: .trailing) {
                    Text("💰 \(skillState.skill.upgradeCost.gold)")
                    Text("💎 \(skillState.skill.upgradeCost.diamond)")
                }
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(skillState.locked ? .gray : .black)
                )
            }
            .disabled(skillState.locked)
        }
        .padding(.vertical, 6)
        .opacity(skillState.locked ? 0.45 : 1.0)
    }

    func unlockConditionText(_ skill: Skill) -> String {
        switch skill.key.tier {
        case .beginner:
            return ""
        case .intermediate:
            return "초급 Lv.1000 필요"
        case .advanced:
            return "중급 Lv.1000 필요"
        }
    }
}

#Preview {
    let user = User(
        nickname: "user",
        wallet: .init(gold: 1000000000, diamond: 100),
        inventory: .init(),
        record: .init(),
        skills: Set(
            GameType.allCases.flatMap { game in
                SkillTier.allCases.map { tier in
                    Skill(key: .init(game: game, tier: tier), level: 999)
                }
            }
        )
    )
    SkillTestView(user: user, calculator: .init())
}
