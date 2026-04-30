//
//  ScenarioManager.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

/// 시나리오 진행 관리 시스템
final class ScenarioManager {
    /// 현재 진행 중인 시나리오
    private(set) var currentScenario: Scenario?
    /// 진행 상태 참조
    private var progress: ScenarioProgress

    init(progress: ScenarioProgress) {
        self.progress = progress
    }

    // MARK: - Scenario Control

    /// 시나리오 시작
    func startScenario(_ scenario: Scenario) {
        currentScenario = scenario
        progress.startScenario(career: scenario.career)
    }

    /// 현재 페이지
    var currentPage: ScenarioPage? {
        guard let scenario = currentScenario,
              progress.currentPageIndex < scenario.pages.count else {
            return nil
        }
        return scenario.pages[progress.currentPageIndex]
    }

    /// 현재 페이지 인덱스
    var currentPageIndex: Int {
        progress.currentPageIndex
    }

    /// 전체 페이지 수
    var totalPageCount: Int {
        currentScenario?.pageCount ?? 0
    }

    /// 마지막 페이지 여부
    var isLastPage: Bool {
        guard let scenario = currentScenario else { return false }
        return progress.currentPageIndex == scenario.pages.count - 1
    }

    // MARK: - Navigation

    /// 다음 페이지로 이동
    func moveToNextPage() {
        guard !isLastPage else { return }
        progress.moveToNextPage()
    }

    /// 시나리오 완료
    func completeScenario() {
        progress.completeScenario()
        currentScenario = nil
    }

    // MARK: - Choice Handling

    /// 선택 후 적절한 결과 페이지로 이동
    func selectChoice(_ choice: ChoiceResult) {
        guard let scenario = currentScenario,
              let page = currentPage,
              case .choice = page.pageType else {
            return
        }

        // 현재 시나리오 타입과 선택에 맞는 결과 페이지 찾기
        if let index = scenario.pages.firstIndex(where: { page in
            if case .result(let scenarioType, let choiceResult) = page.pageType {
                return scenarioType == scenario.scenarioType && choiceResult == choice
            }
            return false
        }) {
            progress.currentPageIndex = index
        }
    }

    // MARK: - Progress Query

    /// 특정 커리어 완료 여부
    func isComplete(_ career: Career) -> Bool {
        progress.isComplete(career)
    }

    /// 진행 중 여부
    var isInProgress: Bool {
        progress.isInProgress
    }
}
