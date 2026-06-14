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
    let record: Record
    let repository: ScenarioRepository
    let onComplete: () -> Void

    @State private var currentPageIndex: Int
    @State private var selected: String = ""
    @State private var finalEnding: Ending? = nil

    // 공유하기
    @State private var isShareSheetPresented = false
    // 환생하기
    @State private var isRebirthConfirmPopupPresented = false
    // 저장하기
    @State private var showSaveCompletedToast = false
    @State private var showSaveCompletedToastMessage = ""

    init(manager: ScenarioManager, record: Record, repository: ScenarioRepository, onComplete: @escaping () -> Void) {
        self.manager = manager
        self.record = record
        self.repository = repository
        self.onComplete = onComplete
        // 저장된 인덱스로 초기화하여 앱 재시작 시 해당 페이지부터 시작하게 함
        self._currentPageIndex = State(initialValue: manager.currentPageIndex)
    }

    var body: some View {
        ZStack {
            Color.black300EventDim.ignoresSafeArea()
            VStack(spacing: TokenSpacing.lg) {
                if finalEnding != nil {
                    HStack(spacing: TokenSpacing.sm) {
                        Image(.story)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("엔딩 결과").duFont(.title1).foregroundStyle(Color.white300)
                        Spacer()
                        Button(action: onComplete) {
                            DUIcon(.close, size: .size28)
                        }
                    }
                    .padding(.horizontal, TokenSpacing.lg)
                }

                if let ending = finalEnding {
                    StoryCard(
                        type: .ending(title: ending.type.title),
                        text: ending.type.description,
                        imageName: manager.currentScenario?.career.scenarioImagePrefix ?? ""
                    )
                    .id("ending")
                } else if let page = manager.currentPage {
                    StoryCard(
                        type: .levelUp,
                        text: page.text,
                        imageName: manager.currentScenario?.career.scenarioImagePrefix ?? ""
                    )
                    .id(currentPageIndex)
                }

                Group {
                    if finalEnding != nil {
                        // 3. 엔딩 전용 버튼 (저장/공유/환생)
                        EventButton(type: .ending(
                            onSave: {
                                guard let ending = finalEnding,
                                      let image = renderEndingImage(ending) else {
                                    return
                                }
                                PhotoLibraryService.saveImageToPhotoLibrary(image) { success in
                                    showSaveCompletedToast = true
                                    showSaveCompletedToastMessage = success ? "이미지 저장에 성공했습니다." : "이미지 저장에 실패했습니다."
                                }
                            },
                            onShare: {
                                isShareSheetPresented = true
                            },
                            onRebirth: {
                                isRebirthConfirmPopupPresented = true
                            }
                        ))
                    } else if let page = manager.currentPage {
                        // 4. 일반 진행 버튼 (다음/선택/다시선택)
                        eventButtonView(for: page)
                    }
                }
                .padding(.horizontal, TokenSpacing.lg)
            }

            if isRebirthConfirmPopupPresented || isShareSheetPresented {
                Color.black300PopUpDimStatusBar.ignoresSafeArea()
            }

            if isShareSheetPresented, let ending = finalEnding {
                ShareSheetView(
                    isPresented: $isShareSheetPresented,
                    kakaoMessageTemplateID: ending.type.kakaoMessageTemplateID,
                    urlString: "\(ShareService.baseURL)/\(ending.type.webURLSlug)"
                )
                .padding(.horizontal, TokenSpacing.lg)
            }

            if isRebirthConfirmPopupPresented {
                rebirthConfirmPopupView
            }
        }
        .onAppear {
            restoreEndingIfNeeded()
        }
        .darkToast(
            isShowing: $showSaveCompletedToast,
            message: showSaveCompletedToastMessage
        )
    }
}

private extension ScenarioStoryView {
    var rebirthConfirmPopupView: some View {
        DUDesignSystem.Popup(type: .confirm(
            title: "환생하기",
            body: "전생의 기억은 모두 잃고 새로 태어나게됩니다.\n환생하시겠습니까?",
            cancelText: "이대로 살기",
            confirmText: "환생하기",
            cancelAction: onComplete,
            confirmAction: {
                record.resetForRebirth()
                onComplete()
            }
        ))
    }

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
                // TODO: 재선택 로직 추가
            }, onComplete: {
                handleNextTap()
            }))
        }
    }

    func restoreEndingIfNeeded() {
        guard manager.currentScenario?.scenarioType == .final,
              let finalChoice = record.choiceHistory[.worldClassDeveloper] else { return }
        calculateAndShowEnding(with: finalChoice)
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

    @MainActor
    func renderEndingImage(_ ending: Ending) -> UIImage? {
        let targetView = makeEndingCard(for: ending)

        let renderer = ImageRenderer(content: targetView)
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = false
        return renderer.uiImage
    }

    func makeEndingCard(for ending: Ending) -> some View {
        StoryCard(
            type: .ending(title: ending.type.title),
            text: ending.type.description,
            imageName: manager.currentScenario?.career.scenarioImagePrefix ?? ""
        )
        .frame(width: 400)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
    }
}
