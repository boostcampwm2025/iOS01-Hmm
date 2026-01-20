//
//  SkillTier.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/20/26.
//

/// 스킬 등급
enum SkillTier: Int, CaseIterable {
    case beginner = 0
    case intermediate = 1
    case advanced = 2

    var displayTitle: String {
        switch self {
        case .beginner: "초급"
        case .intermediate: "중급"
        case .advanced: "고급"
        }
    }

    var levelRange: LevelRange {
        switch self {
        case .beginner: LevelRange(minValue: 1, maxValue: 9999)
        case .intermediate: LevelRange(minValue: 0, maxValue: 9999)
        case .advanced: LevelRange(minValue: 0, maxValue: 9999)
        }
    }
}

/// 레벨 범위 표현을 위한 타입
struct LevelRange {
    let minValue: Int
    let maxValue: Int

    func clamped(_ level: Int) -> Int {
        max(minValue, min(maxValue, level))
    }

    func canUpgrade(from level: Int) -> Bool {
        level < maxValue
    }
}
