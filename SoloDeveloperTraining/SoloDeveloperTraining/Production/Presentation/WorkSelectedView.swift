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

    static let contentSpacing: CGFloat = 17
    static let descriptionSpacing: CGFloat = 10
}

struct WorkSelectedView: View {

    let user: User
    @State var selectedIndex: Int?
    @State var isGameStarted: Bool = false

    var body: some View {
        Group {
            if isGameStarted, let index = selectedIndex {
                gameView(for: index)
            } else {
                selectionView
            }
        }
    }
}

// MARK: - Subviews
private extension WorkSelectedView {

    var selectionView: some View {
        VStack(alignment: .leading, spacing: Constant.contentSpacing) {
            workSegmentControl
            descriptionStack
            startButton
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.bottom, Constant.Padding.selectionViewBottom)
    }

    var workSegmentControl: some View {
        WorkSegmentControl(
            items: workItems,
            selectedIndex: $selectedIndex
        )
    }

    var descriptionStack: some View {
        VStack(alignment: .leading, spacing: Constant.descriptionSpacing) {
            Text("언어 맞추기 게임 스토리 설명")
                .foregroundStyle(.black)
                .textStyle(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("언어 맞추기 게임 액션 설명")
                .foregroundStyle(.gray200)
                .textStyle(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var startButton: some View {
        LargeButton(title: "시작하기") {
            isGameStarted = true
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .disabled(selectedIndex == nil)
    }
}

// MARK: - Helper
private extension WorkSelectedView {

    var workItems: [WorkItem] {
        return [
            .init(
                title: "코드짜기",
                description: "효과 설명",
                imageName: "background_street"
            ),
            .init(
                title: "언어 맞추기",
                description: "효과 설명",
                imageName: "background_street"
            ),
            .init(
                title: "버그 피하기",
                description: "효과 설명",
                imageName: "background_street"
            ),
            .init(
                title: "물건 쌓기",
                description: "효과 설명",
                imageName: "background_street",
                isDisabled: false
            )
        ]
    }

    @ViewBuilder
    func gameView(for index: Int) -> some View {
        switch index {
        case 0:
            TapGameView(user: user, isGameStarted: $isGameStarted)
        case 1:
            LanguageGameView(user: user, isGameStarted: $isGameStarted)
        case 2:
            DodgeGameView(user: user, isGameStarted: $isGameStarted)
        case 3:
            StackGameView(user: user, isGameStarted: $isGameStarted)
        default:
            EmptyView()
        }
    }
}

#Preview {
    let user = User(
        nickname: "Test",
        wallet: .init(),
        inventory: .init(),
        record: .init()
    )

    WorkSelectedView(user: user)
}
