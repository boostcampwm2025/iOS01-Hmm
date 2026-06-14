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
    let repository: ScenarioRepository
    let record: Record
    let onComplete: () -> Void

    @State private var currentPageIndex: Int = 0
    @State private var selected: String = ""
    @State private var finalEnding: Ending? = nil

    var body: some View {
        ZStack {
            Color.black300EventDim.ignoresSafeArea()
            VStack(spacing: TokenSpacing.lg) {
                if let ending = finalEnding {
                    // 1. 최종 결과 확정 시: 엔딩 카드 (타이틀 + 결과 설명)
                    StoryCard(
                        type: .ending(title: ending.type.title),
                        text: ending.type.description,
                        imageName: manager.currentScenario?.career.scenarioImagePrefix ?? ""
                    )
                } else if let page = manager.currentPage {
                    // 2. 시나리오 진행 중 (인트로, 스토리, 선택): 일반 카드 (텍스트만)
                    StoryCard(
                        type: .levelUp,
                        text: page.text,
                        imageName: manager.currentScenario?.career.scenarioImagePrefix ?? ""
                    )
                }

                Group {
                    if finalEnding != nil {
                        // 3. 엔딩 전용 버튼 (저장/공유/환생)
                        EventButton(type: .ending(
                            onSave: { /* 이미지 저장 로직 */ },
                            onShare: { /* 공유 로직 */ },
                            onRebirth: {
                                record.resetForRebirth()
                                onComplete()
                            }
                        ))
                    } else if let page = manager.currentPage {
                        // 4. 일반 진행 버튼 (다음/선택/다시선택)
                        eventButtonView(for: page)
                    }
                }
                .padding(.horizontal, TokenSpacing.lg)
            }
        }
    }
}

private extension ScenarioStoryView {
    /// 페이지 타입에 따른 EventButton 뷰 생성
    @ViewBuilder
    func eventButtonView(for page: ScenarioPage) -> some View {
        switch page.pageType {
        case .story:
            EventButton(type: .next(action: { handleNextTap() }))
        case .choice(let choice):
            EventButton(
                type: .choice(
                    optionA: choice.optionA,
                    optionB: choice.optionB,
                    selected: selected,
                    onSelect: { selection in
                        selected = selection
                        handleChoice(
                            selection == choice.optionA ? .optionA : .optionB
                        )
                    }
                )
            )
        case .result:
            EventButton(type: .reselect(onReselect: {
                // 시나리오 처음으로 (필요 시 구현)
            }, onComplete: {
                handleNextTap()
            }))
        }
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
        if let career = manager.currentScenario?.career {
            record.choiceHistory[career] = result
        }

        if manager.currentScenario?.scenarioType == .final {
            // 최종 엔딩 계산 및 화면 전환
            calculateAndShowEnding(with: result)
        } else {
            manager.selectChoice(result)
            updatePage()
        }
    }

    func calculateAndShowEnding(with finalChoice: ChoiceResult) {
        let evt01 = record.choiceHistory[.juniorDeveloper] ?? .optionA
        let evt02 = record.choiceHistory[.nightOwlDeveloper] ?? .optionA
        let evt03 = record.choiceHistory[.famousDeveloper] ?? .optionA
        let evt04 = finalChoice

        let ending = repository.calculateEnding(
            evt01: evt01,
            evt02: evt02,
            evt03: evt03,
            evt04: evt04
        )

        withAnimation(.spring()) {
            finalEnding = ending
        }
    }

    func updatePage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            manager.moveToNextPage()
            currentPageIndex = manager.currentPageIndex
        }
    }
}
