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
    // TODO: - 팀원들과 의논하기
    /// 업적이라는 것이, 실시간으로 달성 여부를 확인해야하는지?
    /// 실시간으로 확인한다고 하면 미션탭에 빨간 점 같은 것을 표기하여 달성한 업적이 있는지 표현하는지?
    /// raven - 수집해야하는 항목이, 탭, 단어 맞추기 등 다양한 항목 중 하나가 사용이 될 것 같은데, 그런 다양성을 가질 수 있는 타입을 어떻게 만들어야하는지..
    /// edward - 유기적으로 어떻게 해당 타입이 연결되는게 맞을지 잘 모르겠습니다.. 유저가 처음부터 모든 업적을 달성하지 못한 상태로 가지고 있는게 좋을것 같다..! 이 타입 하나에 체크..? 달성여부 메서드를 포함해야할 것 같아요
    
    /// 업적 제목
    var title: String { get set }
    /// 업적 설명
    var description: String { get set }
    
    /// 업적 달성여부 확인
    func check(record: Record) -> AchievementState
}
