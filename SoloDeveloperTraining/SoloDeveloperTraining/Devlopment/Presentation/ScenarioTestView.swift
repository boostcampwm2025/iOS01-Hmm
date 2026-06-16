//
//  ScenarioTestView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 5/1/26.
//

import SwiftUI

@Observable
final class ScenarioTestViewModel {
    private let repository: ScenarioRepository = MockScenarioRepository()
    private var scenarioManager: ScenarioManager
    private var choiceHistory: [Career: ChoiceResult] = [:]
    private var completedCareers: Set<Career> = []

    var selectedCareer: Career = .juniorDeveloper
    var currentScenario: Scenario?
    var currentPage: ScenarioPage?

    init() {
        self.scenarioManager = ScenarioManager(record: Record())
    }

    // MARK: - Computed Properties

    var isInProgress: Bool {
        scenarioManager.isInProgress
    }

    var currentPageIndex: Int {
        guard isInProgress else { return 0 }
        return scenarioManager.currentPageIndex + 1 // 1-based for display
    }

    var totalPages: Int {
        guard isInProgress else { return 0 }
        return scenarioManager.totalPageCount
    }

    var isLastPage: Bool {
        scenarioManager.isLastPage
    }

    var pageTypeDescription: String {
        guard let page = currentPage else { return "없음" }
        switch page.pageType {
        case .story:
            return "story"
        case .choice:
            return "choice"
        case .result(let choice):
            return "result(\(choice.rawValue))"
        }
    }

    var scenarioTypeDescription: String {
        currentScenario?.scenarioType.rawValue ?? "없음"
    }

    var currentText: String {
        currentPage?.text ?? "시나리오를 시작하세요"
    }

    var currentChoice: Choice? {
        guard let page = currentPage,
              case .choice(let choice) = page.pageType else {
            return nil
        }
        return choice
    }

    var isStoryPage: Bool {
        guard let page = currentPage else { return false }
        return page.pageType == .story
    }

    var isChoicePage: Bool {
        // Final 선택 완료되면 choice 페이지 숨김
        if isFinalChoiceComplete {
            return false
        }

        guard let page = currentPage else { return false }
        if case .choice = page.pageType {
            return true
        }
        return false
    }

    var isEventResultPage: Bool {
        guard let page = currentPage,
              currentScenario?.scenarioType == .event,
              case .result = page.pageType else {
            return false
        }
        return true
    }

    var isFinalChoiceComplete: Bool {
        currentScenario?.scenarioType == .final &&
        choiceHistory[.worldClassDeveloper] != nil
    }

    var finalEnding: Ending? {
        guard let evt04Choice = choiceHistory[.worldClassDeveloper] else {
            return nil
        }

        let evt01 = choiceHistory[.juniorDeveloper] ?? .optionA
        let evt02 = choiceHistory[.nightOwlDeveloper] ?? .optionA
        let evt03 = choiceHistory[.famousDeveloper] ?? .optionA
        let evt04 = evt04Choice

        return repository.calculateEnding(
            evt01: evt01,
            evt02: evt02,
            evt03: evt03,
            evt04: evt04
        )
    }

    var kakaoMessageTemplateID: String { "133210" } // 테스트용 메시지 id

    // MARK: - Actions

    func startScenario() {
        if let scenario = repository.fetchScenario(for: selectedCareer) {
            currentScenario = scenario
            scenarioManager.startScenario(scenario)
            updateCurrentPage()
        }
    }

    func moveToNextPage() {
        scenarioManager.moveToNextPage()
        updateCurrentPage()
    }

    func selectChoiceA() {
        if let career = currentScenario?.career {
            choiceHistory[career] = .optionA
        }

        // Final 시나리오가 아닐 때만 페이지 이동
        if currentScenario?.scenarioType != .final {
            scenarioManager.selectChoice(.optionA)
        } else {
            // Final 시나리오는 선택과 동시에 완료 처리
            if let career = currentScenario?.career {
                completedCareers.insert(career)
            }
        }

        updateCurrentPage()
    }

    func selectChoiceB() {
        if let career = currentScenario?.career {
            choiceHistory[career] = .optionB
        }

        // Final 시나리오가 아닐 때만 페이지 이동
        if currentScenario?.scenarioType != .final {
            scenarioManager.selectChoice(.optionB)
        } else {
            // Final 시나리오는 선택과 동시에 완료 처리
            if let career = currentScenario?.career {
                completedCareers.insert(career)
            }
        }

        updateCurrentPage()
    }

    func completeScenario() {
        if let career = currentScenario?.career {
            completedCareers.insert(career)
        }
        scenarioManager.completeScenario()
        currentScenario = nil
        currentPage = nil
    }

    func watchAd() {
        // 광고보기: 시나리오 처음으로
        if let scenario = currentScenario {
            scenarioManager.startScenario(scenario)
            updateCurrentPage()
        }
    }

    func resetAll() {
        scenarioManager = ScenarioManager(record: Record())
        choiceHistory.removeAll()
        completedCareers.removeAll()
        currentScenario = nil
        currentPage = nil
    }

    private func updateCurrentPage() {
        currentPage = scenarioManager.currentPage
    }

    // MARK: - Choice History

    func getScenarioStatus(for career: Career) -> String {
        let isCompleted = completedCareers.contains(career)

        // event나 final 타입은 선택 기록 표시
        if career.scenarioType == .event || career.scenarioType == .final {
            if let choice = choiceHistory[career] {
                let choiceText = choice == .optionA ? "A" : "B"
                return isCompleted ? "\(choiceText) ✅" : "\(choiceText) (진행중)"
            }
        }

        // 완료 여부만 표시
        return isCompleted ? "완료 ✅" : "(미완료)"
    }

    func getStatusColor(for career: Career) -> Color {
        if completedCareers.contains(career) {
            if let choice = choiceHistory[career] {
                return choice == .optionA ? .green : .purple
            }
            return .blue
        }
        return .secondary
    }
}

struct ScenarioTestView: View {
    @State private var viewModel = ScenarioTestViewModel()
    @State private var isShareSheetPresented = false

    var shareSheetOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isShareSheetPresented = false }
            ShareSheetView(
                isPresented: $isShareSheetPresented,
                kakaoMessageTemplateID: viewModel.kakaoMessageTemplateID,
                urlString: "\(ShareService.baseURL)/\(viewModel.finalEnding?.type.webURLSlug ?? "")",
                onLinkCopied: {}
            )
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 시나리오 선택
                VStack(alignment: .leading, spacing: 8) {
                    Text("시나리오 선택")
                        .font(.headline)

                    Picker("시나리오", selection: $viewModel.selectedCareer) {
                        ForEach(Career.allCases, id: \.self) { career in
                            Text("[\(career.rawValue)] \(career.scenarioType.description)")
                                .tag(career)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .disabled(viewModel.isInProgress)
                }
                .padding(.horizontal)

                // 상태 정보
                VStack(alignment: .leading, spacing: 12) {
                    Text("상태 정보")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("• 진행중:")
                            Spacer()
                            Text(viewModel.isInProgress ? "✅" : "❌")
                        }

                        HStack {
                            Text("• 페이지:")
                            Spacer()
                            if viewModel.isInProgress {
                                Text("\(viewModel.currentPageIndex)/\(viewModel.totalPages)")
                                    .font(.system(.body, design: .monospaced))
                            } else {
                                Text("-")
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                        }

                        HStack {
                            Text("• 페이지 타입:")
                            Spacer()
                            Text(viewModel.pageTypeDescription)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.blue)
                        }

                        HStack {
                            Text("• 시나리오 타입:")
                            Spacer()
                            Text(viewModel.scenarioTypeDescription)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // 현재 페이지 내용
                VStack(alignment: .leading, spacing: 12) {
                    Text("현재 페이지 내용")
                        .font(.headline)

                    VStack(spacing: 12) {
                        // 최종 엔딩 표시 또는 일반 텍스트
                        if let ending = viewModel.finalEnding, viewModel.isFinalChoiceComplete {
                            // 최종 엔딩 UI
                            VStack(alignment: .leading, spacing: 12) {
                                Text(ending.type.title)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.orange)

                                Text(ending.type.career)
                                    .font(.title2)
                                    .foregroundColor(.secondary)

                                Divider()
                                    .padding(.vertical, 4)

                                Text(ending.type.description)
                                    .font(.body)
                                    .lineSpacing(6)

                                Text("엔딩 ID: \(ending.id)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(
                                    colors: [Color.orange.opacity(0.2), Color.yellow.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.5), lineWidth: 2)
                            )
                        } else {
                            // 일반 텍스트
                            Text(viewModel.currentText)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }

                        // 버튼들 (상태별로 표시)

                        // 시작 전
                        if !viewModel.isInProgress {
                            Button(action: viewModel.startScenario) {
                                Text("시나리오 시작")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        // Story 페이지
                        if viewModel.isStoryPage {
                            if viewModel.isLastPage && viewModel.currentScenario?.scenarioType != .final {
                                // 마지막 페이지 (Final 아닐 때): 확인 버튼
                                Button(action: viewModel.completeScenario) {
                                    Text("확인")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .buttonStyle(.borderedProminent)
                            } else {
                                // 중간 페이지: 다음 버튼
                                Button(action: viewModel.moveToNextPage) {
                                    Text("다음 페이지")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }

                        // Choice 페이지
                        if viewModel.isChoicePage, let choice = viewModel.currentChoice {
                            VStack(spacing: 8) {
                                Button(action: viewModel.selectChoiceA) {
                                    Text("A: \(choice.optionA)")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)

                                Button(action: viewModel.selectChoiceB) {
                                    Text("B: \(choice.optionB)")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple)
                            }
                        }

                        // Event Result 페이지
                        if viewModel.isEventResultPage {
                            HStack(spacing: 8) {
                                Button(action: viewModel.completeScenario) {
                                    Text("완료")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .buttonStyle(.borderedProminent)

                                Button(action: viewModel.watchAd) {
                                    Text("광고보기")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .buttonStyle(.bordered)
                                .tint(.orange)
                            }
                        }

                        // Final 엔딩 버튼
                        if viewModel.isFinalChoiceComplete {
                            VStack(spacing: 8) {
                                Button {
                                    isShareSheetPresented = true
                                } label: {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("공유하기")
                                    }
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                }
                                .buttonStyle(.borderedProminent)

                                Button(action: {}) {
                                    HStack {
                                        Image(systemName: "photo")
                                        Text("이미지 저장")
                                    }
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)

                                Button(action: {}) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("환생하기")
                                    }
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // 선택 기록
                VStack(alignment: .leading, spacing: 12) {
                    Text("시나리오 진행 기록")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Career.allCases, id: \.self) { career in
                            HStack {
                                Text("\(career.rawValue):")
                                    .font(.caption)
                                Spacer()
                                Text(viewModel.getScenarioStatus(for: career))
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(viewModel.getStatusColor(for: career))
                            }
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.05))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // 초기화 버튼
                Button(action: viewModel.resetAll) {
                    Text("전체 초기화")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top)
        }
        .overlay {
            if isShareSheetPresented {
                shareSheetOverlay
            }
        }
        .navigationTitle("시나리오 테스트")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// ScenarioType description extension
extension ScenarioType {
    var description: String {
        switch self {
        case .normal:
            return "일반"
        case .event:
            return "이벤트"
        case .final:
            return "최종"
        }
    }

    var rawValue: String {
        switch self {
        case .normal:
            return "normal"
        case .event:
            return "event"
        case .final:
            return "final"
        }
    }
}

#Preview {
    NavigationStack {
        ScenarioTestView()
    }
}
