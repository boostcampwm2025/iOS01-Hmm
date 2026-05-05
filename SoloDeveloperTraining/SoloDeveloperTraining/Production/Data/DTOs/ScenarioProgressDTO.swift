//
//  ScenarioProgressDTO.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

struct ScenarioProgressDTO: Codable {
    let currentCareer: Career?
    let currentPageIndex: Int
    let completedCareers: Set<Career>
    let levelupQueue: [Career]

    init(from progress: ScenarioProgress) {
        self.currentCareer = progress.currentCareer
        self.currentPageIndex = progress.currentPageIndex
        self.completedCareers = progress.completedCareers
        self.levelupQueue = progress.levelupQueue
    }

    func toScenarioProgress() -> ScenarioProgress {
        return ScenarioProgress(
            currentCareer: currentCareer,
            currentPageIndex: currentPageIndex,
            completedCareers: completedCareers,
            levelupQueue: levelupQueue
        )
    }
}
