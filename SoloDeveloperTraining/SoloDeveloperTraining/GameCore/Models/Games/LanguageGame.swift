//
//  LanguageGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

private enum Constant {
    static let activeItemIndex: Int = 2
}

enum LanguageType: String {
    case swift = "Swift"
    case kotlin = "Kotlin"
    case dart = "Dart"
    case python = "Python"
    case empty = ""

    var imageName: String {
        switch self {
        case .swift: return "icon_swift"
        case .kotlin: return "icon_kotlin"
        case .dart: return "icon_dart"
        case .python: return "icon_python"
        case .empty: return ""
        }
    }

    var backgroundColorName: String {
        switch self {
        case .swift: return "PastelYellow"
        case .kotlin: return "PastelPink"
        case .dart: return "PastelBlue"
        case .python: return "PastelGreen"
        case .empty: return ""
        }
    }
}

enum LanguageItemState {
    case completed
    case active
    case upcoming
    case empty
}

final class LanguageGame: Game {
    typealias ActionInput = LanguageType
    var kind: GameType = .language
    var user: User
    var calculator: Calculator
    var feverSystem: FeverSystem
    var buffSystem: BuffSystem

    // 한 화면에 보여지는 아이템: 5개로 고정
    let languageItemList: [LanguageItem] = [
        LanguageItem(languageType: .empty, state: .empty),
        LanguageItem(languageType: .empty, state: .empty),
        LanguageItem(languageType: .dart, state: .active),
        LanguageItem(languageType: .python, state: .upcoming),
        LanguageItem(languageType: .swift, state: .upcoming),
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

    func didPerformAction(_ input: LanguageType) async -> Int {
        print("언어 맞추기 버튼 클릭")
        languageButtonTapHandler(tappedItemType: input)
        return 0
    }

    private func languageButtonTapHandler(tappedItemType: LanguageType) {
        let activeItem = languageItemList[Constant.activeItemIndex]

        if activeItem.languageType == tappedItemType {
            print("옳은 아이템")
        } else {
            print("잘못된 아이템")
        }
    }


}
