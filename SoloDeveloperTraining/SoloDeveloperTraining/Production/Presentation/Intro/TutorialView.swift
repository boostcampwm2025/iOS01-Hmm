//
//  TutorialView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let content: CGFloat = 0
        static let indicator: CGFloat = 8
        static let button: CGFloat = 15
    }

    enum Size {
        static let indicatorCircle: CGFloat = 8
    }

    enum Padding {
        static let indicatorTop: CGFloat = 60
        static let indicatorBottom: CGFloat = 40
        static let buttonHorizontal: CGFloat = 25
        static let buttonBottom: CGFloat = 50
    }
}

struct TutorialView: View {
    @Binding var isPresented: Bool
    let onComplete: () -> Void

    @State private var currentPage: Int = 0

    private let tutorialPages: [TutorialPage] = [
        TutorialPage(
            title: "환영합니다!",
            description: "1인 개발자로 성공하기 위한 여정을 시작합니다.",
            imageName: nil
        ),
        TutorialPage(
            title: "게임 플레이",
            description: "다양한 미니게임을 통해 경험치와 골드를 획득하세요.",
            imageName: nil
        ),
        TutorialPage(
            title: "장비 강화",
            description: "장비를 강화하여 더 많은 보상을 받을 수 있습니다.",
            imageName: nil
        ),
        TutorialPage(
            title: "스킬 업그레이드",
            description: "스킬을 업그레이드하여 게임 효율을 높이세요.",
            imageName: nil
        )
    ]

    var body: some View {
        ZStack {
            AppTheme.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: Constant.Spacing.content) {
                indicator
                tutorialContent
                buttonGroup
            }
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
        .padding(.top, Constant.Padding.indicatorTop)
        .padding(.bottom, Constant.Padding.indicatorBottom)
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
            }

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
        .padding(.bottom, Constant.Padding.buttonBottom)
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
