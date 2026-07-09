//
//  TutorialView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

import DUDesignSystem

struct TutorialView: View {
    @State private var currentPage: Int = 0

    let onComplete: () -> Void

    private let tutorialPages: [TutorialPage] = [
        TutorialPage(imageName: .tutorialPage1),
        TutorialPage(imageName: .tutorialPage2),
        TutorialPage(imageName: .tutorialPage3),
        TutorialPage(imageName: .tutorialPage4),
        TutorialPage(imageName: .tutorialPage5),
        TutorialPage(imageName: .tutorialPage6),
        TutorialPage(imageName: .tutorialPage7)
    ]

    var body: some View {
        TutorialPageView(page: tutorialPages[currentPage])
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                if currentPage < tutorialPages.count - 1 {
                    currentPage += 1
                } else {
                    onComplete()
                }
            }
            .analyticsScreen(ScreenID.tutorial(page: currentPage + 1))
            .onChange(of: currentPage) { _, newValue in
                AnalyticsService.shared.enterScreen(ScreenID.tutorial(page: newValue + 1))
            }
            .interactiveDismissDisabled(true)
    }
}

#Preview {
    TutorialView {
        print("튜토리얼 완료")
    }
}
