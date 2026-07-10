//
//  ScreenID.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 7/2/26.
//

import Foundation

enum ScreenID: String {
    case splash
    case nickname

    case restart

    case update01
    case update02
    case noticeUpdate

    case career

    case settings

    case working
    case coding
    case matching
    case avoiding
    case stacking

    case codingExit
    case matchingExit
    case avoidingExit
    case stackingExit

    case coffee
    case bacchus
    case bonus

    case skill

    case item

    case probability01
    case probability02

    case house
    case buyingHouse

    case mission

    case quiz01
    case quiz02
    case quiz03
    case quiz04

    case quizReward
    case quizRewardResult
}

extension ScreenID {
    static func scenario(level: Int, page: Int) -> String {
        return String(
            format: "lv%02dScene%02d",
            level,
            page
        )
    }

    static func tutorial(page: Int) -> String {
        return String(format: "tutorial%02d", page)
    }
}
