//
//  Achievement.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

enum AchievementState {
    /// 수령
    case claimed
    /// 미수령
    case unclaimed
    /// 진행중
    case inProgress
}

protocol Achievement {
    /// 미션 아이디
    var id: Int { get set }
    /// 업적 제목
    var title: String { get set }
    /// 업적 설명
    var description: String { get set }
    /// 목표 수치
    var targetValue: Int { get set }
    /// 현재 수치
    var currentValue: Int { get set }
    /// 현재 미션 상태
    var state: AchievementState { get set }
    /// 달성 조건
    var condition: (Record) -> Bool { get }
}
