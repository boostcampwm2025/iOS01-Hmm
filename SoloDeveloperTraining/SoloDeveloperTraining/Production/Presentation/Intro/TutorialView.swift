//
//  TutorialView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let indicator: CGFloat = 8
        static let button: CGFloat = 15
    }

    enum Size {
        static let indicatorCircle: CGFloat = 8
    }

    enum Padding {
        static let buttonHorizontal: CGFloat = 25
        static let buttonVertical: CGFloat = 25
    }
}

struct TutorialView: View {
    @State private var currentPage: Int = 0
    @Binding var isPresented: Bool

    let onComplete: () -> Void

    private let tutorialPages: [TutorialPage] = [
        TutorialPage(
            title: "게임 플레이",
            description: "다양한 미니게임을 통해 골드를 획득하세요.",
            imageName: .tutorialWork
        ),
        TutorialPage(
            title: "스킬 업그레이드",
            description: "스킬을 업그레이드하여 게임 효율을 높이세요.",
            imageName: .tutorialSkill
        ),
        TutorialPage(
            title: "장비 강화",
            description: "장비를 강화하여 더 많은 보상을 받으세요.",
            imageName: .tutorialItem
        ),
        TutorialPage(
            title: "부동산 구매",
            description: "부동산을 구매하여 더 많은 보상을 받으세요.",
            imageName: .tutorialHousing
        ),
        TutorialPage(
            title: "퀴즈 풀기",
            description: "퀴즈를 풀고 다이아를 획득하세요.",
            imageName: .tutorialQuiz
        ),
        TutorialPage(
            title: "미션 완료",
            description: "미션을 완료하여 추가 보상을 받으세요.",
            imageName: .tutorialMission
        ),
        TutorialPage(
            title: "커리어 성장",
            description: "커리어를 발전시켜 더 높은 직급에 도전하세요.",
            imageName: .tutorialCareer
        )
    ]

    var body: some View {
        ZStack {
            AppTheme.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                tutorialContent
                buttonGroup
            }
            .ignoresSafeArea()
        }
    }
}

private extension TutorialView {
    var indicator: some View {
        HStack(spacing: Constant.Spacing.indicator) {
            ForEach(0..<tutorialPages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? AppColors.orange500 : AppColors.gray300)
                    .frame(width: Constant.Size.indicatorCircle, height: Constant.Size.indicatorCircle)
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }

    var tutorialContent: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<tutorialPages.count, id: \.self) { index in
                TutorialPageView(page: tutorialPages[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxHeight: .infinity)
    }

    var buttonGroup: some View {
        HStack(spacing: Constant.Spacing.button) {
            if currentPage > 0 {
                MediumButton(title: "이전", isFilled: true, isCancelButton: true) {
                    withAnimation {
                        currentPage -= 1
                    }
                }
            } else {
                Color.clear
                    .frame(width: 89, height: 44)
            }

            Spacer()

            indicator

            Spacer()

            if currentPage < tutorialPages.count - 1 {
                MediumButton(title: "다음", isFilled: true) {
                    withAnimation {
                        currentPage += 1
                    }
                }
            } else {
                MediumButton(title: "시작하기", isFilled: true) {
                    onComplete()
                }
            }
        }
        .padding(.horizontal, Constant.Padding.buttonHorizontal)
        .padding(.vertical, Constant.Padding.buttonVertical)
    }
}

#Preview {
    TutorialView(
        isPresented: .constant(true),
        onComplete: {
            print("튜토리얼 완료")
        }
    )
}
