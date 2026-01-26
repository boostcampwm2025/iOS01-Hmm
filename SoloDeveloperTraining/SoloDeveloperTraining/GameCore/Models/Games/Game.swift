//
//  Game.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 게임 프로토콜
protocol Game {
    /// action parameter
    associatedtype ActionInput
    /// 게임 종류
    var kind: GameType { get set }
    /// 유저
    var user: User { get set }
    /// 피버 시스템
    var feverSystem: FeverSystem { get set }
    /// 버프 시스템
    var buffSystem: BuffSystem { get set }
    /// 캐릭터 애니메이션 시스템
    var animationSystem: CharacterAnimationSystem? { get set }

    /// 게임 시작
    func startGame()
    /// 게임 종료
    func stopGame()
    /// action 수행
    @discardableResult
    func didPerformAction(_ input: ActionInput) async -> Int
}

/// 게임 타입
enum GameType: Int, CaseIterable {
    case tap = 0
    case language = 1
    case dodge = 2
    case stack = 3

    /// 화면에 표시될 제목
    var displayTitle: String {
        switch self {
        case .tap: "코드짜기"
        case .language: "언어 맞추기"
        case .dodge: "버그 피하기"
        case .stack: "데이터 쌓기"
        }
    }
}
