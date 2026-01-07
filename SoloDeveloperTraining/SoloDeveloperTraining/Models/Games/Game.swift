//
//  Game.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

protocol Game {
    /// 게임 종류
    var kind: GameKind { get set }
    /// 유저
    var user: User { get set }
    /// 계산기
    var calculator: Calculator { get set }
    /// 피버 시스템
    var feverSystem: FeverSystem { get set }
    
    /// 게임 시작
    func startGame()
    /// 게임 종료
    func stopGame()
    /// action 수행
    @discardableResult
    func didPerformAction() async -> Int
}

enum GameKind {
    case tap
    case language
    case dodge
    case stack
    
    var displayTitle: String {
        switch self {
        case .tap: "코드짜기"
        case .language: "언어 맞추기"
        case .dodge: "버그 피하기"
        case .stack: "물건 쌓기"
        }
    }
}
