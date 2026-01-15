//
//  WorkSelectedView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let horizontalPadding: CGFloat = 16
    static let contentSpacing: CGFloat = 17
    static let descriptionSpacing: CGFloat = 10
}

struct WorkSelectedView: View {

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
        .padding(.horizontal, Constant.horizontalPadding)
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
        Button {
            isGameStarted = true
        } label: {
            Text("시작하기")
                .frame(maxWidth: .infinity)
        }
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
                imageName: "background_street",
                isDisabled: true
            ),
            .init(
                title: "언어 맞추기",
                description: "효과 설명",
                imageName: "background_street"
            ),
            .init(
                title: "버그 피하기",
                description: "효과 설명",
                imageName: "background_street",
                isDisabled: true
            ),
            .init(
                title: "물건 쌓기",
                description: "효과 설명",
                imageName: "background_street",
                isDisabled: true
            )
        ]
    }

    @ViewBuilder
    func gameView(for index: Int) -> some View {
        switch index {
        case 0:
            Color.white.overlay(Text("코드 짜기").foregroundColor(.gray))
        case 1:
            Color.white.overlay(Text("언어 맞추기").foregroundColor(.gray))
        case 2:
            Color.white.overlay(Text("버그 피하기").foregroundColor(.gray))
        case 3:
            Color.white.overlay(Text("물건 쌓기").foregroundColor(.gray))
        default:
            EmptyView()
        }
    }
}

#Preview {
    WorkSelectedView()
}
