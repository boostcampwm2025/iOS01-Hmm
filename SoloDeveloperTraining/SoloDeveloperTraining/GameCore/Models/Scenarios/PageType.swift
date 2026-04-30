//
//  PageType.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

/// 시나리오 페이지 타입
enum PageType {
    /// 일반 스토리 페이지
    case story
    /// 선택지 페이지
    case choice(Choice)
    /// 결과 페이지
    case result(ScenarioType, ChoiceResult)
}
