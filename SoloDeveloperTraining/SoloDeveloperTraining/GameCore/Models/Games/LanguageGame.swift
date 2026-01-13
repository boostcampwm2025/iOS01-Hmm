//
//  LanguageGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

private enum Constant {
    enum Fever {
        static let successFever: Double = 33.0
        static let failureFever: Double = 0.0
    }
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
    var languageItemList: [LanguageItem] = [
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
        let isSuccess = languageButtonTapHandler(tappedItemType: input)
        feverSystem
            .gainFever(
                isSuccess ? Constant.Fever.successFever : Constant.Fever.failureFever
            )
        let gainGold = calculator.calculateGoldPerAction(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        if isSuccess {
            await user.wallet.addGold(gainGold)
            return gainGold
        }
        await user.wallet.spendGold(gainGold / 2)
        return (gainGold / 2) * -1
    }

    private func languageButtonTapHandler(tappedItemType: LanguageType) -> Bool {
        let activeItem = languageItemList[Constant.activeItemIndex]
        print("\n✅ \(tappedItemType) 버튼 클릭")

        guard activeItem.languageType == tappedItemType else {
            print("잘못된 버튼을 클릭했습니다.")
            return false
        }

        // 1. 처음 요소 제거
        languageItemList.removeFirst()
        // 2. 새 요소를 마지막에 추가
        languageItemList.append(makeNewLanguageItem())
        // 3. 상태 업데이트
        updateLanguageItemList()

        print("변경된 아이템 리스트")
        languageItemList.forEach { print("언어: \($0.languageType), 상태: \($0.state)") }

        return true
    }

    private func makeNewLanguageItem() -> LanguageItem {
        let randomType: LanguageType = [.swift, .kotlin, .dart, .python].randomElement()!
        return LanguageItem(languageType: randomType, state: .upcoming)
    }

    private func updateLanguageItemList() {
        for (index, item) in languageItemList.enumerated() {
            if item.state == .empty { continue }

            let newState: LanguageItemState = index < Constant.activeItemIndex ? .completed : index == Constant.activeItemIndex ? .active : .upcoming
            languageItemList[index] = .init(
                languageType: item.languageType,
                state: newState
            )
        }
    }
}
