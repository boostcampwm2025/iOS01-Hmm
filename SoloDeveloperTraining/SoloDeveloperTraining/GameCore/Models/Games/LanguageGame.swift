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
}

enum LanguageType: String, CaseIterable {
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

    static func random() -> Self {
        return LanguageType.allCases.randomElement() ?? .swift
    }
}

enum LanguageItemState {
    case completed
    case active
    case upcoming
    case empty
}

@Observable
final class LanguageGame: Game {
    typealias ActionInput = LanguageType
    var kind: GameType = .language
    var user: User
    var calculator: Calculator
    var feverSystem: FeverSystem
    var buffSystem: BuffSystem

    let itemCount: Int

    // 한 화면에 보여지는 아이템 리스트
    var itemList: [LanguageItem] = []

    // 활성화 아이템 외에 양쪽에 보여지는 아이템의 개수
    var leadingAndTrailingItemCount: Int {
        itemCount / 2
    }

    init(
        user: User,
        calculator: Calculator,
        feverSystem: FeverSystem,
        buffSystem: BuffSystem,
        itemCount: Int
    ) {
        self.user = user
        self.calculator = calculator
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
        self.itemCount = itemCount
        self.itemList = makeInitialItemList()
    }

    func startGame() {
        feverSystem.start()
    }

    func stopGame() {
        feverSystem.stop()
        if buffSystem.isRunning { buffSystem.stop() }
        itemList = []
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
        let activeItem = itemList[leadingAndTrailingItemCount]

        guard activeItem.languageType == tappedItemType else {
            return false
        }

        // 1. 복제 후 처음 요소 제거
        var newItems = itemList
        newItems.removeFirst()
        // 2. 새 요소를 마지막에 추가
        newItems.append(.init(languageType: LanguageType.random(), state: .upcoming))
        // 3. 요소 업데이트
        self.itemList = newItems
        // 4. 상태 업데이트
        updateLanguageItemList()

        return true
    }

    private func makeInitialItemList() -> [LanguageItem] {
        var items: [LanguageItem] = []
        let activeIndex = leadingAndTrailingItemCount // 중앙 인덱스

        for i in 0..<itemCount {
            if i < activeIndex {
                // 1. 중앙 앞부분: 빈 아이템 (이미 지나간 영역)
                items.append(.init(languageType: .empty, state: .empty))
            } else if i == activeIndex {
                // 2. 중앙: 실제 게임 타겟 (Active)
                let newType = LanguageType.random()
                items.append(.init(languageType: newType, state: .active))
            } else {
                // 3. 중앙 뒷부분: 대기 중인 아이템 (Upcoming)
                let newType = LanguageType.random()
                items.append(.init(languageType: newType, state: .upcoming))
            }
        }
        return items
    }

    private func updateLanguageItemList() {
        for (index, item) in itemList.enumerated() {
            if item.state == .empty { continue }

            let newState: LanguageItemState = index < leadingAndTrailingItemCount ? .completed : index == leadingAndTrailingItemCount ? .active : .upcoming
            itemList[index] = .init(
                languageType: item.languageType,
                state: newState
            )
        }
    }
}
