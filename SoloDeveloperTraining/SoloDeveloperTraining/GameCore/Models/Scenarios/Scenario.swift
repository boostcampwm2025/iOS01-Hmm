//
//  Scenario.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

/// 커리어별 시나리오
struct Scenario {
    /// 시나리오 고유 ID
    let id: String
    /// 해당 커리어
    let career: Career
    /// 시나리오 타입
    let scenarioType: ScenarioType
    /// 시나리오 페이지 목록
    let pages: [ScenarioPage]

    init(
        id: String,
        career: Career,
        scenarioType: ScenarioType,
        pages: [ScenarioPage]
    ) {
        self.id = id
        self.career = career
        self.scenarioType = scenarioType
        self.pages = pages
    }

    /// 첫 페이지
    var firstPage: ScenarioPage? {
        pages.first
    }

    /// 마지막 페이지
    var lastPage: ScenarioPage? {
        pages.last
    }

    /// 전체 페이지 수
    var pageCount: Int {
        pages.count
    }

    /// 선택 결과에 해당하는 결과 페이지 인덱스 찾기
    func findResultPageIndex(for choice: ChoiceResult) -> Int? {
        pages.firstIndex(where: { page in
            if case .result(let choiceResult) = page.pageType {
                return choiceResult == choice
            }
            return false
        })
    }
}
