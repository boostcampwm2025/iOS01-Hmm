//
//  ScenarioStoryView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/12/26.
//

import SwiftUI
import DUDesignSystem

private enum Animation {
    static let standard = SwiftUI.Animation.easeInOut(duration: 0.25)
}

struct ScenarioStoryView: View {
    let user: User
    let manager: ScenarioManager
    let repository: ScenarioRepository
    let onComplete: () -> Void

    @State private var currentPageIndex: Int
    @State private var selected: String = ""
    @State private var finalEnding: Ending? = nil
    @State private var isShowingAd = false

    // 토스트 상태
    @State private var showCompletedToast = false
    @State private var showCompletedToastMessage = ""
    // 공유하기
    @State private var isShareSheetPresented = false
    // 환생하기
    @State private var isRebirthConfirmPopupPresented = false

    init(user: User, manager: ScenarioManager, repository: ScenarioRepository, onComplete: @escaping () -> Void) {
        self.user = user
        self.manager = manager
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
                        imageName: ending.type.imageName
                    )
                    .id("ending")
                    .padding(.horizontal, TokenSpacing.lg)
                } else if let page = manager.currentPage {
                    StoryCard(
                        type: .levelUp,
                        text: page.text,
                        imageName: page.imageName ?? ""
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
                                    showCompletedToast = true
                                    showCompletedToastMessage = success ? "이미지가 저장되었습니다." : "이미지 저장에 실패했습니다."
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
                    urlString: "\(ShareService.baseURL)/\(ending.type.webURLSlug)",
                    onLinkCopied: {
                        showCompletedToast = true
                        showCompletedToastMessage = "링크가 복사되었습니다."
                    }
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
        .duToast(
            isShowing: $showCompletedToast,
            message: showCompletedToastMessage
        ).padding(.bottom, TokenGrid.paddingBottom)
    }
}

// MARK: - 서브 뷰
private extension ScenarioStoryView {
    var rebirthConfirmPopupView: some View {
        NoticePopup(
            type: .confirm(
                cancelText: "그냥 살기",
                confirmText: "환생하기",
                cancelAction: onComplete,
                confirmAction: { handleRebirthScenario() }
            ),
            title: "환생하기",
            text: "전생의 기억은 모두 잃고 새로 태어나게됩니다.\n환생하시겠습니까?"
        )
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
                guard !isShowingAd else { return }
                isShowingAd = true
                Task {
                    let success = await AdService.shared.showAdWithResult(.interstitial)
                    isShowingAd = false
                    if success {
                        selected = ""
                        withAnimation(Animation.standard) {
                            manager.reselectChoice()
                            currentPageIndex = manager.currentPageIndex
                        }
                    }
                }
            }, onComplete: {
                handleNextTap()
            }))
        }
    }
}

// MARK: - 헬퍼
private extension ScenarioStoryView {
    func restoreEndingIfNeeded() {
        guard manager.currentScenario?.scenarioType == .final,
              let finalChoice = user.record.choiceHistory[.worldClassDeveloper] else { return }
        calculateAndShowEnding(with: finalChoice)
    }

    func handleNextTap() {
        if manager.isLastPage {
            onComplete()
        } else {
            updatePage()
        }
    }

    func handleChoice(_ result: ChoiceResult) {
        if let career = manager.currentScenario?.career {
            user.record.choiceHistory[career] = result
        }

        if manager.currentScenario?.scenarioType == .final {
            calculateAndShowEnding(with: result)
        } else {
            manager.selectChoice(result)
            updatePage()
        }
    }

    func updatePage() {
        withAnimation(Animation.standard) {
            manager.moveToNextPage()
            currentPageIndex = manager.currentPageIndex
        }
    }

    func calculateAndShowEnding(with finalChoice: ChoiceResult) {
        let evt01 = user.record.choiceHistory[.juniorDeveloper] ?? .optionA
        let evt02 = user.record.choiceHistory[.nightOwlDeveloper] ?? .optionA
        let evt03 = user.record.choiceHistory[.famousDeveloper] ?? .optionA
        let evt04 = finalChoice

        let ending = repository.calculateEnding(
            evt01: evt01,
            evt02: evt02,
            evt03: evt03,
            evt04: evt04
        )

        withAnimation(Animation.standard) {
            finalEnding = ending
        }
    }

    func handleRebirthScenario() {
        if let ending = finalEnding {
            user.resetForRebirth(ending: ending)

            let pages = repository.fetchRebirthScenarioPages()

            let rebirthScenario = Scenario(
                id: "rebirth",
                career: .unemployed,
                scenarioType: .normal,
                pages: pages
            )

            manager.startScenario(rebirthScenario)

            currentPageIndex = manager.currentPageIndex
            selected = ""
            finalEnding = nil

            isRebirthConfirmPopupPresented = false
        }
    }
}

// MARK: - 엔딩 이미지 카드 저장
private extension ScenarioStoryView {
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
            imageName: ending.type.imageName
        )
        .frame(width: 400)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
    }
}
