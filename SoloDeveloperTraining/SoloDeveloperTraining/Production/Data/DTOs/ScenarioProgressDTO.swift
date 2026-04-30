//
//  ScenarioProgressDTO.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

struct ScenarioProgressDTO: Codable {
    let currentCareer: String?
    let currentPageIndex: Int
    let completedCareers: [String]
    let levelupQueue: [String]

    init(from progress: ScenarioProgress) {
        self.currentCareer = progress.currentCareer?.rawValue
        self.currentPageIndex = progress.currentPageIndex
        self.completedCareers = progress.completedCareers.map { $0.rawValue }
        self.levelupQueue = progress.levelupQueue.map { $0.rawValue }
    }

    func toScenarioProgress() -> ScenarioProgress {
        let career = currentCareer.flatMap { Career(rawValue: $0) }
        let completed = Set(completedCareers.compactMap { Career(rawValue: $0) })
        let queue = levelupQueue.compactMap { Career(rawValue: $0) }

        return ScenarioProgress(
            currentCareer: career,
            currentPageIndex: currentPageIndex,
            completedCareers: completed,
            levelupQueue: queue
        )
    }
}
