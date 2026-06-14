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
    /// 진행 상태가 저장되는 참조 타입 레코드
    private let record: Record

    init(record: Record) {
        self.record = record
    }

    // MARK: - Scenario Control

    /// 시나리오 시작
    func startScenario(_ scenario: Scenario) {
        currentScenario = scenario
        record.scenarioProgress.startScenario(career: scenario.career)
    }

    /// 시나리오 복구 (저장된 상태로부터)
    func restoreScenario(_ scenario: Scenario) {
        currentScenario = scenario
    }

    /// 현재 페이지
    var currentPage: ScenarioPage? {
        guard let scenario = currentScenario,
              record.scenarioProgress.currentPageIndex < scenario.pages.count else {
            return nil
        }
        return scenario.pages[record.scenarioProgress.currentPageIndex]
    }

    /// 현재 페이지 인덱스
    var currentPageIndex: Int {
        record.scenarioProgress.currentPageIndex
    }

    /// 전체 페이지 수
    var totalPageCount: Int {
        currentScenario?.pageCount ?? 0
    }

    /// 마지막 페이지 여부
    var isLastPage: Bool {
        guard let scenario = currentScenario else { return false }
        return record.scenarioProgress.currentPageIndex == scenario.pages.count - 1
    }

    // MARK: - Navigation

    /// 다음 페이지로 이동
    func moveToNextPage() {
        guard !isLastPage else { return }
        record.scenarioProgress.moveToNextPage()
    }

    /// 시나리오 완료
    func completeScenario() {
        record.scenarioProgress.completeScenario()
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

        if let index = scenario.findResultPageIndex(for: choice) {
            record.scenarioProgress.currentPageIndex = index
        }
    }

    // MARK: - Progress Query

    /// 특정 커리어 완료 여부
    func isComplete(_ career: Career) -> Bool {
        record.scenarioProgress.isComplete(career)
    }

    /// 진행 중 여부
    var isInProgress: Bool {
        record.scenarioProgress.isInProgress
    }
}
