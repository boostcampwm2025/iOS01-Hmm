//
//  ScenarioProgress.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

/// 시나리오 진행 상태
struct ScenarioProgress {
    /// 현재 진행 중인 커리어
    var currentCareer: Career?
    /// 현재 페이지 인덱스
    var currentPageIndex: Int
    /// 완료한 커리어 목록
    var completedCareers: Set<Career>
    /// 레벨업 큐 (최대 3개, 초과 시 마지막 1개만 유지)
    var levelupQueue: [Career]

    init(
        currentCareer: Career? = nil,
        currentPageIndex: Int = 0,
        completedCareers: Set<Career> = [],
        levelupQueue: [Career] = []
    ) {
        self.currentCareer = currentCareer
        self.currentPageIndex = currentPageIndex
        self.completedCareers = completedCareers
        self.levelupQueue = levelupQueue
    }

    /// 시나리오 진행 중 여부
    var isInProgress: Bool {
        currentCareer != nil
    }

    /// 시나리오 시작
    mutating func startScenario(career: Career) {
        currentCareer = career
        currentPageIndex = 0
    }

    /// 다음 페이지로 이동
    mutating func moveToNextPage() {
        currentPageIndex += 1
    }

    /// 시나리오 완료
    mutating func completeScenario() {
        guard let career = currentCareer else { return }
        completedCareers.insert(career)
        currentCareer = nil
        currentPageIndex = 0
    }

    /// 레벨업 큐에 추가
    mutating func enqueueLevelUp(_ career: Career) {
        levelupQueue.append(career)
        if levelupQueue.count > Policy.Scenario.maxLevelupQueueSize {
            levelupQueue = [levelupQueue.last!]
        }
    }

    /// 레벨업 큐에서 꺼내기
    mutating func dequeueLevelUp() -> Career? {
        guard !levelupQueue.isEmpty else { return nil }
        return levelupQueue.removeFirst()
    }

    /// 특정 커리어 완료 여부
    func isComplete(_ career: Career) -> Bool {
        completedCareers.contains(career)
    }
}
