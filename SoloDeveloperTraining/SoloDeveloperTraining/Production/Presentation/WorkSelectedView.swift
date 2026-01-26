//
//  WorkSelectedView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    enum Padding {
        static let horizontal: CGFloat = 16
        static let selectionViewBottom: CGFloat = 30
    }

    enum UserDefaults {
        static let lastSelectedWorkIndexKey = "lastSelectedWorkIndex"
    }

    enum Description {
        static let tapGame = "모니터를 최대한 많이 누르세요."
        static let languageGame = "올바른 버튼을 누르세요."
        static let dodgeGame = "기기를 기울여 버그를 피하고 골드를 획득하세요."
        static let stackGame = "최대한 높은 데이터를 쌓으세요."
    }

    static let contentSpacing: CGFloat = 17
    static let descriptionSpacing: CGFloat = 10
}

struct WorkSelectedView: View {

    let user: User
    let animationSystem: CharacterAnimationSystem?
    @State var selectedIndex: Int = 0
    @State var isGameStarted: Bool = false

    var body: some View {
        Group {
            if isGameStarted {
                gameView(for: selectedIndex)
            } else {
                selectionView
            }
        }
        .onAppear {
            loadLastSelectedIndex()
        }
        .onChange(of: selectedIndex) { _, newValue in
            saveLastSelectedIndex(newValue)
        }
    }
}

// MARK: - Subviews
private extension WorkSelectedView {

    var selectionView: some View {
        VStack(spacing: Constant.contentSpacing) {
            workSegmentControl
            descriptionStack
            startButton
        }
        .padding(.horizontal, Constant.Padding.horizontal)
    }

    var workSegmentControl: some View {
        WorkSegmentControl(
            items: workItems,
            selectedIndex: $selectedIndex
        )
    }

    var descriptionStack: some View {
        VStack(alignment: .leading, spacing: Constant.descriptionSpacing) {
            Text(actionDescription(for: selectedIndex))
                .foregroundStyle(.gray300)
                .textStyle(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var startButton: some View {
        LargeButton(title: "시작하기") {
            isGameStarted = true
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .padding(.bottom, Constant.Padding.selectionViewBottom)
    }
}

// MARK: - Helper
private extension WorkSelectedView {

    var workItems: [WorkItem] {
        return [
            .init(
                title: "코드짜기",
                description: "효과 설명",
                imageName: GameType.tap.imageName
            ),
            .init(
                title: "언어 맞추기",
                description: "효과 설명",
                imageName: GameType.language.imageName
            ),
            .init(
                title: "버그 피하기",
                description: "효과 설명",
                imageName: GameType.dodge.imageName
            ),
            .init(
                title: "데이터 쌓기",
                description: "효과 설명",
                imageName: GameType.stack.imageName
            )
        ]
    }

    @ViewBuilder
    func gameView(for index: Int) -> some View {
        switch index {
        case 0:
            TapGameView(user: user, isGameStarted: $isGameStarted, animationSystem: animationSystem)
        case 1:
            LanguageGameView(user: user, isGameStarted: $isGameStarted, animationSystem: animationSystem)
        case 2:
            DodgeGameView(user: user, isGameStarted: $isGameStarted, animationSystem: animationSystem)
        case 3:
            StackGameView(user: user, isGameStarted: $isGameStarted, animationSystem: animationSystem)
        default:
            EmptyView()
        }
    }

    func actionDescription(for index: Int) -> String {
        switch index {
        case 0:
            return Constant.Description.tapGame
        case 1:
            return Constant.Description.languageGame
        case 2:
            return Constant.Description.dodgeGame
        case 3:
            return Constant.Description.stackGame
        default:
            return ""
        }
    }

    func loadLastSelectedIndex() {
        let savedIndex = UserDefaults.standard.integer(forKey: Constant.UserDefaults.lastSelectedWorkIndexKey)
        if savedIndex >= 0 && savedIndex < workItems.count {
            selectedIndex = savedIndex
        } else {
            selectedIndex = 0
        }
    }

    func saveLastSelectedIndex(_ index: Int) {
        UserDefaults.standard.set(index, forKey: Constant.UserDefaults.lastSelectedWorkIndexKey)
    }
}

#Preview {
    let user = User(
        nickname: "Test",
        wallet: .init(),
        inventory: .init(),
        record: .init()
    )

    WorkSelectedView(user: user, animationSystem: nil)
}
