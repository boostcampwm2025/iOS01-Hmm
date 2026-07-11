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

    let adRewardNow: Date

    @State private var adRewardFlowID: String?

    init(
        user: User,
        careerSystem: CareerSystem?,
        adRewardNow: Date
    ) {
        self.user = user
        self.careerSystem = careerSystem
        self.skillSystem = SkillSystem(user: user, careerSystem: careerSystem)
        self.adRewardNow = adRewardNow
    }

    var skillAdItemRow: some View {
        let isActive = SkillAdRewardManager.isRewardActive(user: user, now: adRewardNow)
        let canUseToday = SkillAdRewardManager.canUseRewardToday(user: user, now: adRewardNow)
        let buttonState = adRewardButtonState(isActive: isActive, canUseToday: canUseToday)

        return ItemRow(
            imageName: "adBoost",
            title: "업무 효율 대박",
            description: "5분간 피버 타임 (업무 보상 X2)",
            buttonType: .singleLine(text: isActive ? "사용중" : "광고보기", icon: .ad),
            buttonState: buttonState,
            action: {
                switch buttonState {
                case .disabled: return
                case .default:
                    Task {
                        SoundService.shared.trigger(.click)
                        await handleWatchAd()
                    }
                case .locked:
                    ToastManager.shared.show("하루 사용 횟수(3회)를 초과했습니다.")
                }
            }
        )
        .onAppear {
            trackAdOfferIfNeeded(buttonState: buttonState)
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: TokenSpacing.md) {
                skillAdItemRow
                ForEach(skillSystem.skillList(), id: \.skill) { skillState in
                    let state = skillState.itemState.itemButtonState
                    ItemRow(
                        imageName: skillState.skill.imageName,
                        title: skillState.skill.title,
                        description: {
                            let increase = skillState.skill.gainGoldIncrease
                            let total = skillState.totalGainGold
                            return "액션당 +\(Int(increase).formatted) / 현재 \(Int(total).formatted)"
                        }(),
                        buttonType: skillState.itemState == .reachedMax
                            ? .singleLine(text: "MAX", icon: nil)
                            : skillState.skill.upgradeCost.itemButtonType,
                        buttonState: state,
                        action: {
                            if state == .default {
                                SoundService.shared.trigger(.click)
                                upgrade(skill: skillState.skill)
                            } else if state == .locked {
                                switch skillSystem
                                    .unlockRequirement(for: skillState.skill) {
                                case .career(let game):
                                    ToastManager.shared.show("'\(game.displayTitle)'가 해금된 후부터 구매할 수 있습니다.")
                                case .beginner(let game, let level):
                                    ToastManager.shared.show("\(game.displayTitle) 초급 Lv.\(level)부터 구매할 수 있습니다.")
                                case .intermediate(let game, let level):
                                    ToastManager.shared.show("\(game.displayTitle) 중급 Lv.\(level)부터 구매할 수 있습니다.")
                                }
                            }
                        },
                        onLongPress: { upgradeRepeating(skill: skillState.skill) }
                    )
                }
            }
            .padding(.horizontal, TokenGrid.paddingSide)
            .padding(.bottom, TokenGrid.paddingBottom)
        }
        .analyticsScreen(.skill)
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
        } catch {
            assertionFailure("강화에 실패했습니다.")
        }
    }

    func upgradeRepeating(skill: Skill) -> Bool {
        do {
            try skillSystem.upgrade(skill: skill)
            SoundService.shared.trigger(.click)
            return true
        } catch {
            return false
        }
    }

    func handleWatchAd() async {
        guard let flowID = adRewardFlowID else { return }

        AnalyticsService.shared.logAdWatchClicked(
            adRewardFlowID: flowID,
            rewardType: .skillBoost,
            rewardAmount: 0
        )

        let result = await AdService.shared.showAdWithResult(.interstitial)
        if result.isOffline {
            PopupManager.shared.showNoNetworkAlert()
            return
        }
        adRewardFlowID = nil

        if result.success {
            AnalyticsService.shared.logAdWatchCompleted(
                adRewardFlowID: flowID,
                rewardType: .skillBoost,
                rewardAmount: 0,
                adWatchDurationSec: result.watchDurationSec
            )
            SkillAdRewardManager.grantReward(user: user)
            ToastManager.shared.show("5분간 업무 보상을 2배로 획득합니다.")
            AnalyticsService.shared.logAdRewardClaimed(
                adRewardFlowID: flowID,
                rewardType: .skillBoost,
                rewardAmount: 0
            )
        }
    }

    func trackAdOfferIfNeeded(buttonState: ItemButton.ItemButtonState) {
        guard buttonState == .default, adRewardFlowID == nil else { return }

        let flowID = AnalyticsService.shared.makeAdRewardFlowID()
        adRewardFlowID = flowID
        AnalyticsService.shared.logAdOfferViewed(
            adRewardFlowID: flowID,
            rewardType: .skillBoost,
            rewardAmount: 0
        )
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

    SkillView(user: user, careerSystem: nil, adRewardNow: Date())
}
