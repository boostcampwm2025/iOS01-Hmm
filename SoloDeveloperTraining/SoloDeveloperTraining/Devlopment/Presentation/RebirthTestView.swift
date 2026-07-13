//
//  RebirthTestView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/6/26.
//

import SwiftUI

// MARK: - ViewModel

@Observable
final class RebirthTestViewModel {
    // MARK: - Dependencies
    private let repository: ScenarioRepository = MockScenarioRepository()

    // MARK: - Test User
    private(set) var testUser: User

    // MARK: - Scenario Simulation
    var selectedChoices: [Career: ChoiceResult] = [:]

    // MARK: - Rebirth Story State
    private var rebirthStoryPages: [ScenarioPage] = []
    var currentRebirthPageIndex: Int = 0
    var isShowingRebirthStory: Bool = false

    // MARK: - Initialization

    init() {
        self.testUser = User(nickname: "환생테스터")
        self.rebirthStoryPages = repository.fetchRebirthScenarioPages()
    }

    // MARK: - Computed Properties

    var currentEnding: Ending? {
        guard selectedChoices.count == 4,
              let evt01 = selectedChoices[.juniorDeveloper],
              let evt02 = selectedChoices[.nightOwlDeveloper],
              let evt03 = selectedChoices[.famousDeveloper],
              let evt04 = selectedChoices[.worldClassDeveloper] else {
            return nil
        }

        return repository.calculateEnding(
            evt01: evt01,
            evt02: evt02,
            evt03: evt03,
            evt04: evt04
        )
    }

    var canRebirth: Bool {
        currentEnding != nil && !isShowingRebirthStory
    }

    var currentRebirthStoryText: String {
        guard isShowingRebirthStory,
              currentRebirthPageIndex < rebirthStoryPages.count else {
            return ""
        }
        return rebirthStoryPages[currentRebirthPageIndex].text
    }

    var isLastRebirthPage: Bool {
        currentRebirthPageIndex == rebirthStoryPages.count - 1
    }

    // MARK: - Cheat Functions

    func setChoice(for career: Career, choice: ChoiceResult) {
        selectedChoices[career] = choice
        testUser.record.choiceHistory[career] = choice
    }

    func injectAllTestData() {
        // [커리어 & 재화]
        testUser.updateCareer(to: .worldClassDeveloper)
        testUser.wallet.addGold(9_999_999)
        testUser.wallet.addDiamond(999)

        // [재무 기록]
        testUser.record.totalEarnedMoney = 50_000_000
        testUser.record.totalSpentMoney = 30_000_000
        testUser.record.totalSkillUpgradeCost = 5_000_000
        testUser.record.totalEquipmentEnhancementCost = 8_000_000
        testUser.record.totalConsumablePurchaseCost = 500_000
        testUser.record.totalHousingMoveCost = 2_000_000

        // [게임 통계]
        testUser.record.totalTapCount = 25_000
        testUser.record.languageCorrectCount = 1_500
        testUser.record.languageConsecutiveCorrect = 50
        testUser.record.dodgeGoldCollectedCount = 800
        testUser.record.dodgeMaxCombo = 250
        testUser.record.dodgeBugAvoidedCount = 2_000
        testUser.record.dodgeBugCollectCount = 500
        testUser.record.stackingSuccessCount = 1_200
        testUser.record.stackConsecutiveSuccess = 30

        // [소모품 사용]
        testUser.record.coffeeUseCount = 100
        testUser.record.energyDrinkUseCount = 80

        // [업적]
        testUser.record.tutorialCompleted = true
        testUser.record.hasAchievedJuniorDeveloper = true

        // [시나리오 - 4개 이벤트 선택]
        setChoice(for: .juniorDeveloper, choice: .optionA)
        setChoice(for: .nightOwlDeveloper, choice: .optionB)
        setChoice(for: .famousDeveloper, choice: .optionA)
        setChoice(for: .worldClassDeveloper, choice: .optionB)

        // [스킬 - 모든 스킬 Lv.10]
        for skill in testUser.skills {
            for _ in 0..<10 {
                try? skill.upgrade()
            }
        }

        // [인벤토리 - 장비 업그레이드]
        for equipment in testUser.inventory.equipmentItems {
            for _ in 0..<5 {  // 5번 정도 업그레이드 시도
                _ = equipment.upgraded()
            }
        }

        // [인벤토리 - 부동산]
        testUser.inventory.housing = Housing(tier: .pentHouse)

        // [누적 플레이타임]
        testUser.record.totalPlayTime += TimeInterval(10 * 3600)  // 10시간 추가

        // [미션 - 통계 반영 후 상태 업데이트 및 일부 수령 완료 처리]
        testUser.record.missionSystem.updateCompletedMissions(record: testUser.record)

        // 완료 가능한 미션 중 절반 정도를 수령 완료 상태로 변경
        let claimableMissions = testUser.record.missionSystem.missions.filter { $0.state == .claimable }
        for (index, mission) in claimableMissions.enumerated() {
            if index % 2 == 0 {  // 절반만 claimed 처리
                _ = mission.claim()
            }
        }
    }

    func resetTestUser() {
        testUser = User(nickname: "환생테스터")
        selectedChoices.removeAll()
        currentRebirthPageIndex = 0
        isShowingRebirthStory = false
    }

    // MARK: - Rebirth Flow

    func startRebirth() {
        guard canRebirth else { return }

        // 환생 스토리 시작
        currentRebirthPageIndex = 0
        isShowingRebirthStory = true
    }

    func moveToNextRebirthPage() {
        guard currentRebirthPageIndex < rebirthStoryPages.count - 1 else { return }
        currentRebirthPageIndex += 1
    }

    func completeRebirth() {
        guard let ending = currentEnding else { return }

        // 환생 실행
        testUser.resetForRebirth(ending: ending)

        // UI 초기화
        isShowingRebirthStory = false
        currentRebirthPageIndex = 0
        selectedChoices.removeAll()
    }

}

// MARK: - View

struct RebirthTestView: View {
    @State private var viewModel = RebirthTestViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - 치트 섹션
                cheatSection

                // MARK: - 현재 상태 요약
                stateOverviewSection

                // MARK: - 시나리오 시뮬레이션
                if !viewModel.isShowingRebirthStory {
                    scenarioSimulationSection
                }

                // MARK: - 환생 스토리 또는 환생 버튼
                if viewModel.isShowingRebirthStory {
                    rebirthStorySection
                } else {
                    rebirthActionSection
                }
            }
            .padding()
        }
        .navigationTitle("환생 테스트")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Cheat Section

    private var cheatSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎮 치트 메뉴")
                .font(.headline)

            VStack(spacing: 8) {
                Button("✨ 모든 데이터 주입") {
                    viewModel.injectAllTestData()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .frame(maxWidth: .infinity)

                Button("🔄 완전 리셋") {
                    viewModel.resetTestUser()
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }

    // MARK: - State Overview Section

    private var stateOverviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 현재 상태")
                .font(.headline)

            VStack(spacing: 16) {
                // 유지될 데이터
                VStack(alignment: .leading, spacing: 8) {
                    Text("✅ 유지될 데이터")
                        .font(.subheadline)
                        .foregroundColor(.green)

                    VStack(spacing: 4) {
                        HStack {
                            Text("환생 횟수:")
                            Spacer()
                            Text("\(viewModel.testUser.record.rebirthCount)")
                                .bold()
                        }
                        HStack {
                            Text("달성 엔딩:")
                            Spacer()
                            Text("\(viewModel.testUser.record.allEndingsAchieved.count)/16")
                                .bold()
                        }
                        HStack {
                            Text("누적 플레이:")
                            Spacer()
                            Text("\(Int(viewModel.testUser.record.totalPlayTime))초")
                                .bold()
                        }
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)

                // 초기화될 데이터
                VStack(alignment: .leading, spacing: 8) {
                    Text("🔄 초기화될 데이터")
                        .font(.subheadline)
                        .foregroundColor(.red)

                    VStack(spacing: 8) {
                        // 커리어 & 재화
                        dataGroup(title: "[커리어 & 재화]") {
                            dataRow("커리어", viewModel.testUser.career.rawValue)
                            dataRow("골드", "\(viewModel.testUser.wallet.gold)")
                            dataRow("다이아", "\(viewModel.testUser.wallet.diamond)")
                        }

                        // 재무 기록
                        dataGroup(title: "[재무 기록]") {
                            dataRow("누적 획득", "\(viewModel.testUser.record.totalEarnedMoney)")
                            dataRow("누적 소비", "\(viewModel.testUser.record.totalSpentMoney)")
                            dataRow("스킬 업그레이드 비용", "\(viewModel.testUser.record.totalSkillUpgradeCost)")
                            dataRow("장비 강화 비용", "\(viewModel.testUser.record.totalEquipmentEnhancementCost)")
                            dataRow("소모품 구매 비용", "\(viewModel.testUser.record.totalConsumablePurchaseCost)")
                            dataRow("부동산 이사 비용", "\(viewModel.testUser.record.totalHousingMoveCost)")
                        }

                        // 게임 통계
                        dataGroup(title: "[게임 통계]") {
                            dataRow("총 탭 횟수", "\(viewModel.testUser.record.totalTapCount)")
                            dataRow("언어 정답 수", "\(viewModel.testUser.record.languageCorrectCount)")
                            dataRow("언어 연속 정답", "\(viewModel.testUser.record.languageConsecutiveCorrect)")
                            dataRow("회피 골드 획득", "\(viewModel.testUser.record.dodgeGoldCollectedCount)")
                            dataRow("회피 최고 콤보", "\(viewModel.testUser.record.dodgeMaxCombo)")
                            dataRow("회피 버그 회피", "\(viewModel.testUser.record.dodgeBugAvoidedCount)")
                            dataRow("회피 버그 수집", "\(viewModel.testUser.record.dodgeBugCollectCount)")
                            dataRow("스택 성공", "\(viewModel.testUser.record.stackingSuccessCount)")
                            dataRow("스택 연속 성공", "\(viewModel.testUser.record.stackConsecutiveSuccess)")
                        }

                        // 소모품 사용
                        dataGroup(title: "[소모품 사용]") {
                            dataRow("커피", "\(viewModel.testUser.record.coffeeUseCount)회")
                            dataRow("에너지드링크", "\(viewModel.testUser.record.energyDrinkUseCount)회")
                        }

                        // 업적
                        dataGroup(title: "[업적]") {
                            dataRow("튜토리얼", viewModel.testUser.record.tutorialCompleted ? "✅" : "❌")
                            dataRow("하찮은개발자 달성", viewModel.testUser.record.hasAchievedJuniorDeveloper ? "✅" : "❌")
                        }

                        // 시나리오
                        dataGroup(title: "[시나리오]") {
                            dataRow("선택 기록", "\(viewModel.testUser.record.choiceHistory.count)개")
                            dataRow("진행도 (현재 커리어)", viewModel.testUser.record.scenarioProgress.currentCareer?.rawValue ?? "없음")
                        }

                        // 스킬
                        dataGroup(title: "[스킬]") {
                            dataRow("총 스킬 수", "\(viewModel.testUser.skills.count)개")
                            dataRow("평균 레벨", String(format: "%.1f", averageSkillLevel(viewModel.testUser.skills)))
                        }

                        // 미션
                        dataGroup(title: "[미션]") {
                            dataRow("총 미션", "\(viewModel.testUser.record.missionSystem.allCount)개")
                            dataRow("달성", "\(viewModel.testUser.record.missionSystem.claimedCount)개")
                        }

                        // 인벤토리
                        dataGroup(title: "[인벤토리]") {
                            dataRow("부동산", viewModel.testUser.inventory.housing.displayTitle)
                            dataRow("장비 (키보드)", viewModel.testUser.inventory.equipmentItems.first { $0.type == .keyboard }?.displayTitle ?? "없음")
                            dataRow("장비 (마우스)", viewModel.testUser.inventory.equipmentItems.first { $0.type == .mouse }?.displayTitle ?? "없음")
                            dataRow("장비 (모니터)", viewModel.testUser.inventory.equipmentItems.first { $0.type == .monitor }?.displayTitle ?? "없음")
                            dataRow("장비 (의자)", viewModel.testUser.inventory.equipmentItems.first { $0.type == .chair }?.displayTitle ?? "없음")
                        }
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    // MARK: - Scenario Simulation Section

    private var scenarioSimulationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📖 시나리오 시뮬레이션")
                .font(.headline)

            Text("4개 이벤트의 선택을 설정하세요")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                scenarioChoiceRow(
                    career: .juniorDeveloper,
                    label: "LV04 - 하찮은 개발자"
                )

                scenarioChoiceRow(
                    career: .nightOwlDeveloper,
                    label: "LV06 - 야근 개발자"
                )

                scenarioChoiceRow(
                    career: .famousDeveloper,
                    label: "LV08 - 유명한 개발자"
                )

                scenarioChoiceRow(
                    career: .worldClassDeveloper,
                    label: "LV10 - 세계적 개발자"
                )
            }

            // 최종 엔딩 미리보기
            if let ending = viewModel.currentEnding {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🎯 최종 엔딩")
                        .font(.subheadline)
                        .bold()

                    Text(ending.type.title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.orange)

                    Text(ending.type.career)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(ending.type.description)
                        .font(.caption2)
                        .lineLimit(3)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.2), Color.yellow.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                )
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }

    private func scenarioChoiceRow(career: Career, label: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button("A") {
                viewModel.setChoice(for: career, choice: .optionA)
            }
            .buttonStyle(.bordered)
            .tint(viewModel.selectedChoices[career] == .optionA ? .green : .gray)
            .frame(width: 50)

            Button("B") {
                viewModel.setChoice(for: career, choice: .optionB)
            }
            .buttonStyle(.bordered)
            .tint(viewModel.selectedChoices[career] == .optionB ? .purple : .gray)
            .frame(width: 50)
        }
    }

    // MARK: - Rebirth Story Section

    private var rebirthStorySection: some View {
        VStack(spacing: 16) {
            Text("🔄 환생 스토리")
                .font(.headline)

            // 현재 페이지 텍스트
            Text(viewModel.currentRebirthStoryText)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)

            // 페이지 인디케이터
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index == viewModel.currentRebirthPageIndex ? Color.purple : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }

            // 버튼
            if viewModel.isLastRebirthPage {
                Button("확인 (환생 실행)") {
                    viewModel.completeRebirth()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            } else {
                Button("다음") {
                    viewModel.moveToNextRebirthPage()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
    }

    // MARK: - Rebirth Action Section

    private var rebirthActionSection: some View {
        VStack(spacing: 12) {
            if !viewModel.canRebirth {
                Text("4개 이벤트를 모두 선택하면 환생할 수 있습니다")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: viewModel.startRebirth) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("환생하기")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .disabled(!viewModel.canRebirth)
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
    }

    // MARK: - Helper View Builders

    @ViewBuilder
    private func dataGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
                .bold()
            content()
        }
    }

    private func dataRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label + ":")
                .foregroundColor(.primary.opacity(0.8))
            Spacer()
            Text(value)
                .bold()
        }
    }

    private func averageSkillLevel(_ skills: Set<Skill>) -> Double {
        guard !skills.isEmpty else { return 0.0 }
        let totalLevel = skills.reduce(0) { $0 + $1.level }
        return Double(totalLevel) / Double(skills.count)
    }
}

#Preview {
    NavigationStack {
        RebirthTestView()
    }
}
