//
//  SkillView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-20.
//

import SwiftUI
import DUDesignSystem

struct SkillView: View {
    private let user: User
    private let careerSystem: CareerSystem?
    private let skillSystem: SkillSystem

    @Binding var noticePopup: NoticePopup?
    let adRewardNow: Date

    init(
        user: User,
        careerSystem: CareerSystem?,
        noticePopup: Binding<NoticePopup?>,
        adRewardNow: Date
    ) {
        self.user = user
        self.careerSystem = careerSystem
        self.skillSystem = SkillSystem(user: user, careerSystem: careerSystem)
        self._noticePopup = noticePopup
        self.adRewardNow = adRewardNow
    }

    var skillAdItemRow: some View {
        let isActive = SkillAdRewardManager.isRewardActive(user: user, now: adRewardNow)
        let canUseToday = SkillAdRewardManager.canUseRewardToday(user: user, now: adRewardNow)

        return ItemRow(
            imageName: "adBoost",
            title: "업무 효율 대박",
            description: "5분간 피버타임 두배 (X1, X2, X4)",
            buttonType: .singleLine(text: isActive ? "사용중" : "광고보기", icon: .ad),
            buttonState: adRewardButtonState(isActive: isActive, canUseToday: canUseToday),
            action: {
                Task { await handleWatchAd() }
            }
        )
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: TokenSpacing.md) {
                skillAdItemRow
                ForEach(skillSystem.skillList(), id: \.skill) { skillState in
                    ItemRow(
                        imageName: skillState.skill.imageName,
                        title: skillState.skill.title,
                        description: {
                            let current = skillState.skill.gainGold
                            let after = skillState.skill.gainGoldAfterUpgrade
                            return "레벨업시 골드 획득 \(Int(current).formatted) -> \(Int(after).formatted)"
                        }(),
                        buttonType: skillState.skill.upgradeCost.itemButtonType,
                        buttonState: skillState.itemState.itemButtonState,
                        action: { upgrade(skill: skillState.skill) },
                        onLongPress: { upgradeRepeating(skill: skillState.skill) }
                    )
                }
            }
            .padding(.horizontal, TokenGrid.paddingSide)
            .padding(.bottom, TokenGrid.paddingBottom)
        }
        .scrollIndicators(.never)
    }
}

private extension SkillView {
    func adRewardButtonState(isActive: Bool, canUseToday: Bool) -> ItemButton.ItemButtonState {
        if isActive { return .disabled }
        return canUseToday ? .default : .locked
    }

    func upgrade(skill: Skill) {
        do {
            try skillSystem.upgrade(skill: skill)
        } catch let error as UserReadableError {
            noticePopup = NoticePopup(
                type: .default(buttonText: "확인", action: { noticePopup = nil }),
                title: "스킬",
                text: error.message
            )
        } catch {
            noticePopup = NoticePopup(
                type: .default(buttonText: "확인", action: { noticePopup = nil }),
                title: "스킬",
                text: error.localizedDescription
            )
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
        guard adRewardButtonState(isActive: isActive, canUseToday: canUseToday) == .default else { return }

        let result = await AdService.shared.showAdWithResult(.interstitial)
        if result.success {
            noticePopup = NoticePopup(
                type: .default(buttonText: "확인", action: {
                    noticePopup = nil
                    SkillAdRewardManager.grantReward(user: user)
                }),
                title: "보상 완료",
                text: "\(Int(Policy.Ad.SkillReward.rewardDuration / 60))분간 게임 재화를 \(Int(Policy.Ad.SkillReward.rewardMultiplier))배로 획득합니다."
            )
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
            .init(key: SkillKey(game: .tap, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .tap, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .tap, tier: .advanced), level: 1),
            .init(key: SkillKey(game: .language, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .language, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .language, tier: .advanced), level: 1),
            .init(key: SkillKey(game: .dodge, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .dodge, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .dodge, tier: .advanced), level: 1),
            .init(key: SkillKey(game: .stack, tier: .beginner), level: 1),
            .init(key: SkillKey(game: .stack, tier: .intermediate), level: 1),
            .init(key: SkillKey(game: .stack, tier: .advanced), level: 1)
        ]
    )

    SkillView(user: user, careerSystem: nil, noticePopup: .constant(nil), adRewardNow: Date())
}
