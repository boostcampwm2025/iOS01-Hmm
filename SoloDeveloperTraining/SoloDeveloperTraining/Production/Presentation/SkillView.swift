//
//  SkillView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-20.
//

import SwiftUI

private enum Constant {
    static let horizontalPadding: CGFloat = 16
    static let popupHorizontalPadding: CGFloat = 25
    static let itemCardSpacing: CGFloat = 12
    static let popupContentSpacing: CGFloat = 20
}

struct SkillView: View {
    private let user: User
    private let careerSystem: CareerSystem?
    private let skillSystem: SkillSystem

    @Binding var popupContent: PopupConfiguration?

    init(
        user: User,
        careerSystem: CareerSystem?,
        popupContent: Binding<PopupConfiguration?>
    ) {
        self.user = user
        self.careerSystem = careerSystem
        self.skillSystem = SkillSystem(user: user, careerSystem: careerSystem)
        self._popupContent = popupContent
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Constant.itemCardSpacing) {
                ForEach(skillSystem.skillList(), id: \.skill) { skillState in
                    ItemRow(
                        title: skillState.skill.title,
                        description: {
                            let currentTotal = skillSystem.calculateCurrentTotalGold(for: skillState.skill.key.game)
                            let afterTotal = skillSystem.calculateTotalGoldAfterUpgrade(skill: skillState.skill)
                            return " 골드 획득: \(currentTotal.formatted()) -> \(afterTotal.formatted())"
                        }(),
                        imageName: skillState.skill.imageName,
                        cost: skillState.skill.upgradeCost,
                        state: skillState.itemState
                    ) {
                        upgrade(skill: skillState.skill)
                    }
                }
            }
        }
        .padding(.bottom)
        .scrollIndicators(.never)
    }
}

private extension SkillView {
    func upgrade(skill: Skill) {
        do {
            try skillSystem.upgrade(skill: skill)
        } catch let error as UserReadableError {
            popupContent = PopupConfiguration(title: "스킬") {
                VStack(spacing: Constant.popupContentSpacing) {
                    Text(error.message)
                        .textStyle(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    MediumButton(title: "확인", isFilled: true) {
                        popupContent = nil
                    }
                }
            }
        } catch {
            // UserReadableError를 채택하지 않은 예상치 못한 에러
            // 실제로는 발생하지 않지만 Swift 컴파일러 요구사항
            popupContent = PopupConfiguration(title: "스킬") {
                VStack(spacing: Constant.popupContentSpacing) {
                    Text(error.localizedDescription)
                        .textStyle(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    MediumButton(title: "확인", isFilled: true) {
                        popupContent = nil
                    }
                }
            }
        }
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
            // 데이터 쌓기
            .init(key: SkillKey(game: .stack, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .stack, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .stack, tier: .advanced), level: 1)
        ]
    )

    SkillView(user: user, careerSystem: nil, popupContent: .constant(nil))
}
