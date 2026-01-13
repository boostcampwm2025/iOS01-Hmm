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

final class LanguageGame: Game {
    var kind: GameType = .language
    var user: User
    var calculator: Calculator
    var feverSystem: FeverSystem
    var buffSystem: BuffSystem

    let languageItemList: [LanguageItem] = [
        LanguageItem(languageType: .swift, state: .active),
        LanguageItem(languageType: .kotlin, state: .upcoming),
        LanguageItem(languageType: .dart, state: .upcoming),
        LanguageItem(languageType: .python, state: .upcoming),
        LanguageItem(languageType: .swift, state: .upcoming),
        LanguageItem(languageType: .kotlin, state: .upcoming),
        LanguageItem(languageType: .dart, state: .upcoming),
        LanguageItem(languageType: .python, state: .upcoming),
    ]

    init(
        user: User,
        calculator: Calculator,
        feverSystem: FeverSystem,
        buffSystem: BuffSystem
    ) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
    }

    func startGame() {
        feverSystem.start()
    }

    func stopGame() {
        feverSystem.stop()
    }

    func didPerformAction() async -> Int {
        print("언어 맞추기 버튼 클릭")
        return 0
    }


}
