//
//  LanguageGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

enum LanguageType: String {
    case swift = "Swift"
    case kotlin = "Kotlin"
    case dart = "Dart"
    case python = "Python"

    var imageName: String {
        switch self {
        case .swift: return "icon_swift"
        case .kotlin: return "icon_kotlin"
        case .dart: return "icon_dart"
        case .python: return "icon_python"
        }
    }

    var backgroundColorName: String {
        switch self {
        case .swift: return "PastelYellow"
        case .kotlin: return "PastelPink"
        case .dart: return "PastelBlue"
        case .python: return "PastelGreen"
        }
    }
}

enum LanguageItemState {
    case completed
    case active
    case upcoming
}

class LanguageGame {
    let user: User
    let calculator: Calculator
    let feverSystem: FeverSystem

    init(user: User, calculator: Calculator, feverSystem: FeverSystem) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
    }

    func startGame() {}
    func endGame() {}

    func actionDidOccur() {}
}
