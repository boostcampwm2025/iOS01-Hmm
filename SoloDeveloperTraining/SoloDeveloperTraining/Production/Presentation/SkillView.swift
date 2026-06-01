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
    let adRewardNow: Date

    init(
        user: User,
        careerSystem: CareerSystem?,
        popupContent: Binding<PopupConfiguration?>,
        adRewardNow: Date
    ) {
        self.user = user
        self.careerSystem = careerSystem
        self.skillSystem = SkillSystem(user: user, careerSystem: careerSystem)
        self._popupContent = popupContent
        self.adRewardNow = adRewardNow
    }

    var skillAdItemRow: some View {
        let isActive = SkillAdRewardManager.isRewardActive(user: user, now: adRewardNow)
        let canUseToday = SkillAdRewardManager.canUseRewardToday(user: user, now: adRewardNow)

        return ItemRow(
            title: "업무 효율 대박",
            description: "5분간 골드 \(Int(Policy.Ad.SkillReward.rewardMultiplier))배 획득",
            imageName: "skill_ad_reward",
            price: .text(isActive ? "사용중" : "AD"),
            state: adRewardButtonState(isActive: isActive, canUseToday: canUseToday),
            action: {
                Task { await handleWatchAd() }
            }
        )
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Constant.itemCardSpacing) {
                skillAdItemRow
                ForEach(skillSystem.skillList(), id: \.skill) { skillState in
                    ItemRow(
                        title: skillState.skill.title,
                        description: {
                            let current = skillState.skill.gainGold
                            let after = skillState.skill.gainGoldAfterUpgrade
                            return "레벨업시 골드 획득 \(Int(current).formatted) -> \(Int(after).formatted)"
                        }(),
                        imageName: skillState.skill.imageName,
                        cost: skillState.skill.upgradeCost,
                        state: skillState.itemState,
                        action: { upgrade(skill: skillState.skill) },
                        onLongPressAction: { upgradeRepeating(skill: skillState.skill) }
                    )
                }
            }
        }
        .padding(.bottom)
        .scrollIndicators(.never)
    }
}

private extension SkillView {
    func adRewardButtonState(isActive: Bool, canUseToday: Bool) -> ItemState {
        if isActive {
            return .insufficient
        }
        return canUseToday ? .available : .locked
    }

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

    func upgradeRepeating(skill: Skill) -> Bool {
        do {
            try skillSystem.upgrade(skill: skill)
            return true
        } catch {
            return false
        }
    }

    func handleWatchAd() async {
        let isActive = SkillAdRewardManager.isRewardActive(user: user, now: adRewardNow)
        let canUseToday = SkillAdRewardManager.canUseRewardToday(user: user, now: adRewardNow)
        guard adRewardButtonState(isActive: isActive, canUseToday: canUseToday) == .available else { return }

        let success = await AdService.shared.showAdWithResult(.interstitial)
        if success {
            popupContent = PopupConfiguration(title: "보상 완료") {
                VStack(spacing: Constant.popupContentSpacing) {
                    Text(
                        "\(Int(Policy.Ad.SkillReward.rewardDuration / 60))분간 게임 재화를 \(Int(Policy.Ad.SkillReward.rewardMultiplier))배로 획득합니다."
                    )
                    .textStyle(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    MediumButton(title: "확인", isFilled: true) {
                        popupContent = nil
                    }
                }
                .onDisappear {
                    SkillAdRewardManager.grantReward(user: user)
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

    SkillView(user: user, careerSystem: nil, popupContent: .constant(nil), adRewardNow: Date())
}
