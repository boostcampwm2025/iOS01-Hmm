//
//  ScenarioStoryView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/12/26.
//

import SwiftUI
import DUDesignSystem

struct ScenarioStoryView: View {
    let manager: ScenarioManager
    let onComplete: () -> Void

    @State private var currentPageIndex: Int = 0

    var body: some View {
        ZStack {
            Color.black300EventDim.ignoresSafeArea()
            VStack(spacing: TokenSpacing.lg) {
                if let page = manager.currentPage {
                    StoryCard(
                        type: storyCardType(for: page),
                        text: page.text,
                        imageName: manager.currentScenario?.career.scenarioImagePrefix ?? ""
                    )
                    .id(currentPageIndex)
                }
                if let page = manager.currentPage {
                    eventButtonView(for: page)
                }
            }
        }
    }
}

private extension ScenarioStoryView {
    /// 페이지 타입에 따른 StoryCard 타입 결정
    func storyCardType(for page: ScenarioPage) -> StoryCard.StoryCardType {
        let careerName = manager.currentScenario?.career.rawValue ?? ""
        let isFinal = manager.currentScenario?.scenarioType == .final

        if isFinal {
            // 엔딩 시나리오인 경우 (타이틀 노출)
            return .ending(title: careerName)
        } else {
            // 일반 레벨업 시나리오인 경우 (TextBox만 노출)
            return .levelUp
        }
    }

    /// 페이지 타입에 따른 EventButton 뷰 생성
    @ViewBuilder
    func eventButtonView(for page: ScenarioPage) -> some View {
        Group {
            switch page.pageType {
            case .story, .result:
                // 일반 스토리나 결과 페이지는 '다음으로' 버튼
                EventButton(type: .next)

            case .choice(let choice):
                // 선택지 페이지는 '선택' 버튼
                EventButton(
                    type: .choice,
                    firstChoice: choice.optionA,
                    secondChoice: choice.optionB,
                )
            }
        }.padding(.horizontal, TokenSpacing.lg)
    }

    func handleNextTap() {
        if manager.isLastPage {
            manager.completeScenario()
            onComplete()
        } else {
            updatePage()
        }
    }

    func handleChoice(_ result: ChoiceResult) {
        manager.selectChoice(result)
        updatePage()
    }

    func updatePage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            manager.moveToNextPage()
            currentPageIndex = manager.currentPageIndex
        }
    }
}
