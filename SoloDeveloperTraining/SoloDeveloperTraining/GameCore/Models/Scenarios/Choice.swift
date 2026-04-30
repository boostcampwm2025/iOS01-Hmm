//
//  Choice.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 4/30/26.
//

/// 시나리오 선택지
struct Choice: Equatable {
    /// 옵션 A 텍스트
    let optionA: String
    /// 옵션 B 텍스트
    let optionB: String
}

/// 사용자 선택 결과
enum ChoiceResult: String {
    case optionA
    case optionB
}
