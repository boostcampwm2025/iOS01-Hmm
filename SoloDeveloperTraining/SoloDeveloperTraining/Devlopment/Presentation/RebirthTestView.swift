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
        self.rebirthStoryPages = repository.fetchRebirthStory()
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

    func injectGameStats() {
        testUser.record.totalTapCount = 15000
        testUser.record.totalEarnedMoney = 10000000
        testUser.record.totalSpentMoney = 5000000
        testUser.record.languageCorrectCount = 800
        testUser.record.languageConsecutiveCorrect = 25
        testUser.record.dodgeGoldCollectedCount = 300
        testUser.record.dodgeMaxCombo = 150
        testUser.record.dodgeBugAvoidedCount = 1000
        testUser.record.stackingSuccessCount = 500
        testUser.record.coffeeUseCount = 50
        testUser.record.energyDrinkUseCount = 30

        print("✅ 게임 통계 주입 완료")
    }

    func addCurrency(gold: Int = 999999, diamond: Int = 500) {
        testUser.wallet.addGold(gold)
        testUser.wallet.addDiamond(diamond)
        print("✅ 재화 추가: 골드 +\(gold), 다이아 +\(diamond)")
    }

    func levelUpSkills(to level: Int = 10) {
        for skill in testUser.skills {
            for _ in 0..<level {
                try? skill.upgrade()
            }
        }
        print("✅ 모든 스킬 Lv.\(level)로 설정")
    }

    func setCareer(_ career: Career) {
        testUser.updateCareer(to: career)
        print("✅ 커리어 변경: \(career.rawValue)")
    }

    func addPlayTime(hours: Int) {
        testUser.record.totalPlayTime += TimeInterval(hours * 3600)
        print("✅ 플레이타임 추가: +\(hours)시간")
    }

    func completeAchievements() {
        testUser.record.tutorialCompleted = true
        testUser.record.hasAchievedJuniorDeveloper = true
        print("✅ 튜토리얼 및 업적 완료")
    }

    func setChoice(for career: Career, choice: ChoiceResult) {
        selectedChoices[career] = choice
        testUser.record.choiceHistory[career] = choice
        print("✅ \(career.rawValue) 선택: \(choice.rawValue)")
    }

    func injectAllTestData() {
        injectGameStats()
        addCurrency()
        levelUpSkills()
        setCareer(.worldClassDeveloper)
        addPlayTime(hours: 5)
        completeAchievements()

        // 4개 이벤트 선택 (기본값)
        setChoice(for: .juniorDeveloper, choice: .optionA)
        setChoice(for: .nightOwlDeveloper, choice: .optionB)
        setChoice(for: .famousDeveloper, choice: .optionA)
        setChoice(for: .worldClassDeveloper, choice: .optionB)

        print("🎉 모든 테스트 데이터 주입 완료")
    }

    func resetTestUser() {
        testUser = User(nickname: "환생테스터")
        selectedChoices.removeAll()
        currentRebirthPageIndex = 0
        isShowingRebirthStory = false
        print("🔄 테스트 유저 완전 리셋")
    }

    // MARK: - Rebirth Flow

    func startRebirth() {
        guard canRebirth else { return }

        // 환생 전 스냅샷 출력
        print("\n" + captureState(label: "환생 전"))

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

        // 환생 후 스냅샷 출력
        print("\n" + captureState(label: "환생 후"))

        // UI 초기화
        isShowingRebirthStory = false
        currentRebirthPageIndex = 0
        selectedChoices.removeAll()

        print("\n🎉 환생 완료! 환생 횟수: \(testUser.record.rebirthCount)")
    }

    // MARK: - State Capture

    private func captureState(label: String) -> String {
        """
        [\(label) 상태]
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

        ✅ 유지될 데이터
        - 닉네임: \(testUser.nickname)
        - 환생 횟수: \(testUser.record.rebirthCount)
        - 달성 엔딩 수: \(testUser.record.allEndingsAchieved.count)
        - 누적 플레이타임: \(formatTime(testUser.record.totalPlayTime))

        🔄 초기화될 데이터
        [커리어 & 재화]
        - 커리어: \(testUser.career.rawValue)
        - 골드: \(testUser.wallet.gold)
        - 다이아: \(testUser.wallet.diamond)

        [게임 통계]
        - 총 탭: \(testUser.record.totalTapCount)
        - 누적 획득: \(testUser.record.totalEarnedMoney)
        - 언어 맞춤: \(testUser.record.languageCorrectCount)
        - 최고 콤보: \(testUser.record.dodgeMaxCombo)

        [업적]
        - 튜토리얼: \(testUser.record.tutorialCompleted ? "✅" : "❌")
        - 하찮은개발자: \(testUser.record.hasAchievedJuniorDeveloper ? "✅" : "❌")

        [시나리오]
        - 선택 기록: \(testUser.record.choiceHistory.count)개

        [미션]
        - 총 미션: \(testUser.record.missionSystem.allCount)개
        - 달성: \(testUser.record.missionSystem.claimedCount)개

        [스킬]
        - 평균 레벨: \(String(format: "%.1f", averageSkillLevel()))
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        """
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        return "\(hours)시간 \(minutes)분"
    }

    private func averageSkillLevel() -> Double {
        let totalLevel = testUser.skills.reduce(0) { $0 + $1.level }
        return Double(totalLevel) / Double(testUser.skills.count)
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
                HStack(spacing: 8) {
                    Button("게임통계 주입") {
                        viewModel.injectGameStats()
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)

                    Button("재화 추가") {
                        viewModel.addCurrency()
                    }
                    .buttonStyle(.bordered)
                    .tint(.yellow)
                }

                HStack(spacing: 8) {
                    Button("스킬 Lv.10") {
                        viewModel.levelUpSkills(to: 10)
                    }
                    .buttonStyle(.bordered)
                    .tint(.purple)

                    Button("업적 완료") {
                        viewModel.completeAchievements()
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                }

                Button("✨ 모든 데이터 주입 (한번에)") {
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

                    VStack(spacing: 4) {
                        HStack {
                            Text("커리어:")
                            Spacer()
                            Text(viewModel.testUser.career.rawValue)
                                .bold()
                        }
                        HStack {
                            Text("골드:")
                            Spacer()
                            Text("\(viewModel.testUser.wallet.gold)")
                                .bold()
                        }
                        HStack {
                            Text("총 탭:")
                            Spacer()
                            Text("\(viewModel.testUser.record.totalTapCount)")
                                .bold()
                        }
                        HStack {
                            Text("선택 기록:")
                            Spacer()
                            Text("\(viewModel.testUser.record.choiceHistory.count)개")
                                .bold()
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

                    Text(ending.title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.orange)

                    Text(ending.career)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(ending.description)
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
}

#Preview {
    NavigationStack {
        RebirthTestView()
    }
}
