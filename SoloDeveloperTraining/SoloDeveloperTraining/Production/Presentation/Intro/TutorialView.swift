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
        TutorialPage(imageName: .tutorialWork),
        TutorialPage(imageName: .tutorialSkill),
        TutorialPage(imageName: .tutorialItem),
        TutorialPage(imageName: .tutorialHousing),
        TutorialPage(imageName: .tutorialQuiz),
        TutorialPage(imageName: .tutorialMission),
        TutorialPage(imageName: .tutorialCareer)
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
            .interactiveDismissDisabled(true)
    }
}

#Preview {
    TutorialView {
        print("튜토리얼 완료")
    }
}
