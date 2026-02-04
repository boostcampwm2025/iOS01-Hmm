//
//  LanguageGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

enum LanguageType: String, CaseIterable {
    case swift = "Swift"
    case kotlin = "Kotlin"
    case dart = "Dart"
    case python = "Python"
    case empty = ""

    var imageName: String {
        switch self {
        case .swift: return "language_swift"
        case .kotlin: return "language_kotlin"
        case .dart: return "language_dart"
        case .python: return "language_python"
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

@Observable
final class LanguageGame: Game {
    typealias ActionInput = LanguageType
    var kind: GameType = .language
    var user: User
    var feverSystem: FeverSystem
    var buffSystem: BuffSystem
    var animationSystem: CharacterAnimationSystem?

    let itemCount: Int

    // 한 화면에 보여지는 아이템 리스트
    var itemList: [LanguageItem] = []

    // 활성화 아이템 외에 양쪽에 보여지는 아이템의 개수
    var leadingAndTrailingItemCount: Int {
        itemCount / 2
    }

    init(
        user: User,
        feverSystem: FeverSystem = FeverSystem(
            decreaseInterval: Policy.Fever.decreaseInterval,
            decreasePercentPerTick: Policy.Fever.Language.decreasePercent
        ),
        buffSystem: BuffSystem,
        itemCount: Int,
        animationSystem: CharacterAnimationSystem? = nil
    ) {
        self.user = user
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
        self.itemCount = itemCount
        self.animationSystem = animationSystem
        self.itemList = makeInitialItemList()
    }

    func startGame() {
        feverSystem.start()
        if itemList.isEmpty {
            itemList = makeInitialItemList()
        }
    }

    func stopGame() {
        feverSystem.stop()
        buffSystem.stop()
        itemList = []
    }

    /// 게임 일시정지 (피버, 버프 시스템 보존)
    func pauseGame() {
        feverSystem.pause()
        buffSystem.pause()
    }

    /// 게임 재개
    func resumeGame() {
        feverSystem.resume()
        buffSystem.resume()
    }

    // ===== 📊 측정용 static 변수 =====
    #if DEBUG
    private static var callCount = 0
    #endif

    func didPerformAction(_ input: LanguageType) async -> Int {
        // ===== 📊 측정 코드 시작 =====
        #if DEBUG
        Self.callCount += 1
        let currentCall = Self.callCount
        let startTime = CFAbsoluteTimeGetCurrent()
        var recordTime: Double = 0
        defer {
            let totalElapsed = (CFAbsoluteTimeGetCurrent() - startTime) * 1000
            print("⏱️ [BEFORE #\(currentCall)] Total: \(String(format: "%.2f", totalElapsed))ms | Record: \(String(format: "%.2f", recordTime))ms")
        }
        #endif
        // ===== 📊 측정 코드 끝 =====

        // Task가 취소되었으면 즉시 종료
        guard !Task.isCancelled else { return 0 }

        // 게임 종료 후 버튼 탭 크래시 방지
        guard itemList.count > leadingAndTrailingItemCount else { return 0 }

        let isSuccess = languageButtonTapHandler(tappedItemType: input)

        // 비즈니스 로직 실행 전 다시 한 번 취소 확인
        guard !Task.isCancelled else { return 0 }

        feverSystem
            .gainFever(
                isSuccess ? Policy.Fever.Language.gainPerCorrect : Policy.Fever.Language.lossPerIncorrect
            )
        let gainGold = Calculator.calculateGoldPerAction(
            game: kind,
            user: user,
            feverMultiplier: feverSystem.feverMultiplier,
            buffMultiplier: buffSystem.multiplier
        )
        if isSuccess {
            user.wallet.addGold(gainGold)

            // ===== 📊 Record 시간 측정 시작 =====
            #if DEBUG
            let recordStart = CFAbsoluteTimeGetCurrent()
            #endif

            /// 정답 횟수 기록
            user.record.record(.languageCorrect)
            /// 누적 재산 업데이트
            user.record.record(.earnMoney(gainGold))

            #if DEBUG
            recordTime = (CFAbsoluteTimeGetCurrent() - recordStart) * 1000
            #endif
            // ===== 📊 Record 시간 측정 끝 =====

            // 재화 획득 시 캐릭터 웃게 만들기
            animationSystem?.playSmile()
            return gainGold
        }
        user.wallet.spendGold(Int(Double(gainGold) * Policy.Game.Language.incorrectGoldLossMultiplier))

        // ===== 📊 Record 시간 측정 시작 (오답 케이스) =====
        #if DEBUG
        let recordStart = CFAbsoluteTimeGetCurrent()
        #endif

        /// 오답 횟수 기록
        user.record.record(.languageIncorrect)

        #if DEBUG
        recordTime = (CFAbsoluteTimeGetCurrent() - recordStart) * 1000
        #endif
        // ===== 📊 Record 시간 측정 끝 =====

        return Int(Double(gainGold) * Policy.Game.Language.incorrectGoldLossMultiplier) * -1
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

        for index in 0..<itemCount {
            if index < activeIndex {
                // 1. 중앙 앞부분: 빈 아이템 (이미 지나간 영역)
                items.append(.init(languageType: .empty, state: .empty))
            } else if index == activeIndex {
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
            var newState: LanguageItemState
            if index < leadingAndTrailingItemCount {
                newState = .completed
            } else if index == leadingAndTrailingItemCount {
                newState = .active
            } else {
                newState = .upcoming
            }
            itemList[index] = .init(
                languageType: item.languageType,
                state: newState
            )
        }
    }
}
