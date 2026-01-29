//
//  CareerSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

@Observable
final class CareerSystem {
    private let user: User
    var currentCareer: Career
    var careerProgress: Double = 0.0
    var onCareerChanged: ((Career) -> Void)?

    init(user: User) async {
        self.user = user
        self.currentCareer = await user.career
        await updateProgress()
    }

    /// 누적 재산을 기반으로 현재 달성한 커리어 계산
    func calculateCareer() async -> Career {
        let totalWealth = user.record.totalEarnedMoney

        var achievedCareer: Career = .unemployed
        for career in Career.allCases {
            if totalWealth >= career.requiredWealth {
                achievedCareer = career
            } else {
                break
            }
        }
        return achievedCareer
    }

    /// 커리어 업데이트
    func updateCareer() async {
        let newCareer = await calculateCareer()
        if currentCareer != newCareer {
            currentCareer = newCareer
            await user.updateCareer(to: newCareer)
            onCareerChanged?(newCareer)

            if newCareer == .juniorDeveloper {
                user.record.record(.juniorDeveloperAchieve)
            }
        }
        await updateProgress()
    }
}

// MARK: - Helper
private extension CareerSystem {
    /// 현재 커리어의 진행도 계산 (0.0 ~ 1.0)
    func updateProgress() async {
        guard let nextCareer = currentCareer.nextCareer else {
            careerProgress = 1.0
            return
        }

        let totalWealth = user.record.totalEarnedMoney
        let currentRequirement = currentCareer.requiredWealth
        let nextRequirement = nextCareer.requiredWealth

        let progress = Double(totalWealth - currentRequirement) / Double(nextRequirement - currentRequirement)
        careerProgress = max(0.0, min(1.0, progress))
    }
}
