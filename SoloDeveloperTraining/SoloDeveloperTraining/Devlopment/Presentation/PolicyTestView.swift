//
//  PolicyTestView.swift
//  SoloDeveloperTraining
//

import SwiftUI

struct PolicyTestView: View {
    @State private var isLoading = false
    @State private var isMocked = false

    private var policy: PolicyDTO { policyStore.current }

    var body: some View {
        NavigationStack {
            List {
                statusSection

                // Career
                Section("커리어") {
                    row("백수", policy.career.unemployed)
                    row("노트북 보유자", policy.career.laptopOwner)
                    row("개발자 지망생", policy.career.aspiringDeveloper)
                    row("하찮은 개발자", policy.career.juniorDeveloper)
                    row("아무튼 개발자", policy.career.normalDeveloper)
                    row("밤 새는 개발자", policy.career.nightOwlDeveloper)
                    row("유능한 개발자", policy.career.skilledDeveloper)
                    row("유명한 개발자", policy.career.famousDeveloper)
                    row("올라운더 개발자", policy.career.allRounderDeveloper)
                    row("월드클래스 개발자", policy.career.worldClassDeveloper)
                }

                // Fever
                Section("피버 · 기본") {
                    row("최대 퍼센트", policy.fever.maxPercent)
                    row("감소 간격(초)", policy.fever.decreaseInterval)
                }
                Section("피버 · 단계 임계값") {
                    row("0단계", policy.fever.stageThreshold.stage0)
                    row("1단계", policy.fever.stageThreshold.stage1)
                    row("2단계", policy.fever.stageThreshold.stage2)
                    row("3단계", policy.fever.stageThreshold.stage3)
                }
                Section("피버 · 배율") {
                    row("0단계", policy.fever.multiplier.stage0)
                    row("1단계", policy.fever.multiplier.stage1)
                    row("2단계", policy.fever.multiplier.stage2)
                    row("3단계", policy.fever.multiplier.stage3)
                }
                Section("피버 · 탭") {
                    row("감소 퍼센트", policy.fever.tap.decreasePercent)
                    row("탭당 획득량", policy.fever.tap.gainPerTap)
                }
                Section("피버 · 언어") {
                    row("감소 퍼센트", policy.fever.language.decreasePercent)
                    row("정답당 획득량", policy.fever.language.gainPerCorrect)
                    row("오답당 손실량", policy.fever.language.lossPerIncorrect)
                }
                Section("피버 · 닷지") {
                    row("감소 퍼센트", policy.fever.dodge.decreasePercent)
                    row("소형 골드당 획득량", policy.fever.dodge.gainPerSmallGold)
                    row("대형 골드당 획득량", policy.fever.dodge.gainPerLargeGold)
                    row("버그 회피당 획득량", policy.fever.dodge.gainPerBugDodge)
                    row("버그 피격당 손실량", policy.fever.dodge.lossPerBugHit)
                }
                Section("피버 · 스택") {
                    row("감소 퍼센트", policy.fever.stack.decreasePercent)
                    row("성공당 획득량", policy.fever.stack.gainPerSuccess)
                    row("실패당 손실량", policy.fever.stack.lossPerFailure)
                }

                // Game
                Section("게임 · 언어") {
                    row("오답 골드 손실 배율", policy.game.language.incorrectGoldLossMultiplier)
                }
                Section("게임 · 닷지") {
                    row("소형 골드 배율", policy.game.dodge.smallGoldMultiplier)
                    row("대형 골드 배율", policy.game.dodge.largeGoldMultiplier)
                    row("버그 피격 손실 배율", policy.game.dodge.bugHitLossGoldMultiplier)
                    row("버그 회피 골드 배율", policy.game.dodge.bugDodgeGoldMultiplier)
                    row("업데이트 FPS", policy.game.dodge.updateFPS)
                    row("생성 간격(초)", policy.game.dodge.spawnInterval)
                    row("낙하 속도", policy.game.dodge.fallSpeed)
                    row("소형 골드 생성률(%)", policy.game.dodge.smallGoldSpawnRate)
                    row("대형 골드 생성률(%)", policy.game.dodge.largeGoldSpawnRate)
                    row("버그 생성률(%)", policy.game.dodge.bugSpawnRate)
                }
                Section("게임 · 닷지 · 모션") {
                    row("데드존 임계값", policy.game.dodge.motion.deadZoneThreshold)
                    row("최대 속도", policy.game.dodge.motion.maxSpeed)
                    row("최소 속도", policy.game.dodge.motion.minSpeed)
                }
                Section("게임 · 스택") {
                    row("실패 골드 손실 배율", policy.game.stack.failureGoldLossMultiplier)
                }
                Section("게임 · 퀴즈") {
                    row("게임당 문제 수", policy.game.quiz.questionsPerGame)
                    row("문제당 시간(초)", policy.game.quiz.secondsPerQuestion)
                    row("정답당 다이아몬드", policy.game.quiz.diamondsPerCorrect)
                }

                // Skill
                Section("스킬 · 레벨 범위") {
                    row("초급 최소", policy.skill.beginnerMinLevel)
                    row("초급 최대", policy.skill.beginnerMaxLevel)
                    row("중급 최소", policy.skill.intermediateMinLevel)
                    row("중급 최대", policy.skill.intermediateMaxLevel)
                    row("고급 최소", policy.skill.advancedMinLevel)
                    row("고급 최대", policy.skill.advancedMaxLevel)
                }
                skillSection("스킬 · 탭", policy.skill.tap)
                skillSection("스킬 · 언어", policy.skill.language)
                skillSection("스킬 · 닷지", policy.skill.dodge)
                skillSection("스킬 · 스택", policy.skill.stack)

                // Consumable
                Section("소비 아이템 · 커피") {
                    row("지속 시간(초)", policy.consumable.coffee.duration)
                    row("버프 배율", policy.consumable.coffee.buffMultiplier)
                    row("다이아 가격", policy.consumable.coffee.priceDiamond)
                }
                Section("소비 아이템 · 에너지 드링크") {
                    row("지속 시간(초)", policy.consumable.energyDrink.duration)
                    row("버프 배율", policy.consumable.energyDrink.buffMultiplier)
                    row("다이아 가격", policy.consumable.energyDrink.priceDiamond)
                }

                // Equipment
                Section("장비 · 업그레이드 골드 비용") {
                    row("고장난", policy.equipment.brokenUpgradeCost)
                    row("싸구려", policy.equipment.cheapUpgradeCost)
                    row("빈티지", policy.equipment.vintageUpgradeCost)
                    row("쓸만한", policy.equipment.decentUpgradeCost)
                    row("고오급", policy.equipment.premiumUpgradeCost)
                    row("다이아", policy.equipment.diamondUpgradeCost)
                    row("한정판", policy.equipment.limitedUpgradeCost)
                    row("국보급", policy.equipment.nationalTreasureUpgradeCost)
                }
                Section("장비 · 업그레이드 다이아 비용") {
                    row("고장난", policy.equipment.brokenUpgradeDiamond)
                    row("싸구려", policy.equipment.cheapUpgradeDiamond)
                    row("빈티지", policy.equipment.vintageUpgradeDiamond)
                    row("쓸만한", policy.equipment.decentUpgradeDiamond)
                    row("고오급", policy.equipment.premiumUpgradeDiamond)
                    row("다이아", policy.equipment.diamondUpgradeDiamond)
                    row("한정판", policy.equipment.limitedUpgradeDiamond)
                    row("국보급", policy.equipment.nationalTreasureUpgradeDiamond)
                }
                Section("장비 · 업그레이드 성공률") {
                    row("고장난", policy.equipment.brokenSuccessRate)
                    row("싸구려", policy.equipment.cheapSuccessRate)
                    row("빈티지", policy.equipment.vintageSuccessRate)
                    row("쓸만한", policy.equipment.decentSuccessRate)
                    row("고오급", policy.equipment.premiumSuccessRate)
                    row("다이아", policy.equipment.diamondSuccessRate)
                    row("한정판", policy.equipment.limitedSuccessRate)
                    row("국보급", policy.equipment.nationalTreasureSuccessRate)
                }
                equipmentItemSection("장비 · 키보드 초당 골드", policy.equipment.keyboard)
                equipmentItemSection("장비 · 마우스 초당 골드", policy.equipment.mouse)
                equipmentItemSection("장비 · 모니터 초당 골드", policy.equipment.monitor)
                equipmentItemSection("장비 · 의자 초당 골드", policy.equipment.chair)

                // Housing
                Section("주거 · 구매 비용") {
                    row("길바닥", policy.housing.streetPurchaseCost)
                    row("반지하", policy.housing.semiBasementPurchaseCost)
                    row("옥탑방", policy.housing.rooftopPurchaseCost)
                    row("빌라", policy.housing.villaPurchaseCost)
                    row("아파트", policy.housing.apartmentPurchaseCost)
                    row("단독주택", policy.housing.housePurchaseCost)
                    row("펜트하우스", policy.housing.pentHousePurchaseCost)
                }
                Section("주거 · 초당 골드") {
                    row("길바닥", policy.housing.streetGoldPerSecond)
                    row("반지하", policy.housing.semiBasementGoldPerSecond)
                    row("옥탑방", policy.housing.rooftopGoldPerSecond)
                    row("빌라", policy.housing.villaGoldPerSecond)
                    row("아파트", policy.housing.apartmentGoldPerSecond)
                    row("단독주택", policy.housing.houseGoldPerSecond)
                    row("펜트하우스", policy.housing.pentHouseGoldPerSecond)
                }

                // Ad
                Section("광고 · 스킬 보상") {
                    row("1일 사용 횟수", policy.ad?.skillReward.dailyLimit ?? 3)
                    row("보상 배율", policy.ad?.skillReward.rewardMultiplier ?? 2.0)
                    row("보상 지속 시간(초)", policy.ad?.skillReward.rewardDuration ?? 300)
                }

                // System
                Section("시스템") {
                    row("자동 획득 간격(초)", policy.system.autoGain.interval)
                    row("버프 감소 간격(초)", policy.system.buff.decreaseInterval)
                    row("레벨업 큐 최대 크기", policy.system.scenario?.maxLevelupQueueSize ?? 3)
                }
            }
            .navigationTitle("Policy 확인")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isMocked.toggle()
                        policyStore = isMocked ? MockPolicyStore(shouldFail: true) : PolicyStore()
                        Task { await reload() }
                    } label: {
                        Image(systemName: isMocked ? "exclamationmark.triangle.fill" : "exclamationmark.triangle")
                            .foregroundStyle(isMocked ? .red : .secondary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await reload() } } label: {
                        if isLoading {
                            ProgressView().controlSize(.small)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                    .disabled(isLoading)
                }
            }
        }
        .task { await reload() }
    }

    // MARK: - Helpers

    private var statusSection: some View {
        Section("상태") {
            row("환경", resolveEnvironment())
            row("버전", policy.version.isEmpty ? "(기본값)" : policy.version)
        }
    }

    @ViewBuilder
    private func skillSection(_ title: String, _ skill: some SkillDTOProtocol) -> some View {
        Section(title) {
            row("기본 골드", skill.baseGold)
            row("초급 골드 배율", skill.beginnerGoldMultiplier)
            row("중급 골드 배율", skill.intermediateGoldMultiplier)
            row("고급 골드 배율", skill.advancedGoldMultiplier)
            row("초급 골드 비용 배율", skill.beginnerGoldCostMultiplier)
            row("중급 골드 비용 배율", skill.intermediateGoldCostMultiplier)
            row("고급 골드 비용 배율", skill.advancedGoldCostMultiplier)
            row("다이아 비용 분배", skill.diamondCostDivider)
            row("다이아 비용 배율", skill.diamondCostMultiplier)
            row("중급 해금 레벨", skill.intermediateUnlockLevel)
            row("고급 해금 레벨", skill.advancedUnlockLevel)
        }
    }

    @ViewBuilder
    private func equipmentItemSection(_ title: String, _ item: EquipmentItemDTO) -> some View {
        Section(title) {
            row("고장난", item.brokenGoldPerSecond)
            row("싸구려", item.cheapGoldPerSecond)
            row("빈티지", item.vintageGoldPerSecond)
            row("쓸만한", item.decentGoldPerSecond)
            row("고오급", item.premiumGoldPerSecond)
            row("다이아", item.diamondGoldPerSecond)
            row("한정판", item.limitedGoldPerSecond)
            row("국보급", item.nationalTreasureGoldPerSecond)
        }
    }

    @ViewBuilder
    private func row(_ label: String, _ value: some CustomStringConvertible) -> some View {
        LabeledContent(label, value: String(describing: value))
    }

    private func reload() async {
        isLoading = true
        try? await policyStore.initialize()
        isLoading = false
    }

    private func resolveEnvironment() -> String {
        #if DEV_BUILD
        return "test (DEV_BUILD)"
        #else
        let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        return isTestFlight ? "test (TestFlight)" : "live (App Store)"
        #endif
    }
}

// MARK: - SkillDTOProtocol

protocol SkillDTOProtocol {
    var baseGold: Int { get }
    var beginnerGoldMultiplier: Int { get }
    var intermediateGoldMultiplier: Int { get }
    var advancedGoldMultiplier: Int { get }
    var beginnerGoldCostMultiplier: Int { get }
    var intermediateGoldCostMultiplier: Int { get }
    var advancedGoldCostMultiplier: Int { get }
    var diamondCostDivider: Int { get }
    var diamondCostMultiplier: Int { get }
    var intermediateUnlockLevel: Int { get }
    var advancedUnlockLevel: Int { get }
}

extension SkillTapDTO: SkillDTOProtocol {}
extension SkillLanguageDTO: SkillDTOProtocol {}
extension SkillDodgeDTO: SkillDTOProtocol {}
extension SkillStackDTO: SkillDTOProtocol {}
