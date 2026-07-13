//
//  LanguageGameItem.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/21/26.
//

struct LanguageGameItem {
    let languageType: LanguageType
    let state: LanguageItemState
}

enum LanguageType: String, CaseIterable {
    case swift = "Swift"
    case kotlin = "Kotlin"
    case dart = "Dart"
    case python = "Python"
    case empty = ""

    static func random() -> Self {
        return LanguageType.allCases
            .filter { $0 != .empty}.randomElement() ?? .swift
    }
}

enum LanguageItemState {
    case completed
    case active
    case upcoming
    case empty
}
