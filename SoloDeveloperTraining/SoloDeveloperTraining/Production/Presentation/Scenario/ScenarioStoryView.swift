//
//  ScenarioStoryView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/12/26.
//

import SwiftUI
import DUDesignSystem

struct ScenarioStoryView: View {
    let user: User?
    let manager: ScenarioManager
    let repository: ScenarioRepository
    let onComplete: () -> Void

    @State private var currentPageIndex: Int
    @State private var selected: String = ""
    @State private var finalEnding: Ending? = nil
    @State private var isShowingAd = false
    @State private var adRewardFlowID: String?

    // 공유하기
    @State private var currentShareID = ""

    init(
        user: User?,
        manager: ScenarioManager,
        repository: ScenarioRepository,
        onComplete: @escaping () -> Void
    ) {
        self.user = user
        self.manager = manager
        self.repository = repository
        self.onComplete = onComplete
        // 저장된 인덱스로 초기화하여 앱 재시작 시 해당 페이지부터 시작하게 함
        self._currentPageIndex = State(initialValue: manager.currentPageIndex)
    }

    var body: some View {
        Group {
            if let ending = finalEnding {
                endingResultView(ending: ending)
                    .frame(maxHeight: .infinity, alignment: .top)
            } else if let page = manager.currentPage {
                scenarioView(page: page)
            }
        }
        .analyticsScreen(
            ScreenID
                .scenario(
                    level: manager.currentScenario?.career.level ?? 0,
                    page: manager.currentPageIndex + 1
                )
        )
        .onChange(of: currentPageIndex) { _, newValue in
            AnalyticsService.shared.enterScreen(
                ScreenID.scenario(
                    level: manager.currentScenario?.career.level ?? 0,
                    page: newValue + 1
                )
            )
        }
        .id(manager.currentScenario?.id)
        .onAppear {
            restoreEndingIfNeeded()
        }
        .ignoresSafeArea()
    }
}

// MARK: - 서브 뷰
private extension ScenarioStoryView {
    @ViewBuilder
    var shareSheetPopup: some View {
        if let ending = finalEnding {
            ShareSheetView(
                isPresented: Binding(
                    get: { true },
                    set: { if !$0 { PopupManager.shared.dismiss() } }
                ),
                kakaoMessageTemplateID: ending.type.kakaoMessageTemplateID,
                shareID: currentShareID,
                resultID: ending.id,
                urlString: "\(ShareService.baseURL)/\(ending.type.webURLSlug)?share_id=\(currentShareID)&device_id=\(AnalyticsProperty.deviceIDValue)&result_id=\(ending.id)",
                onLinkCopied: {
                    ToastManager.shared.show("링크가 복사되었습니다.", anchor: .center)
                }
            )
            .padding(.horizontal, TokenSpacing.lg)
        }
    }

    func scenarioView(page: ScenarioPage) -> some View {
        VStack(spacing: TokenSpacing.lg) {
            StoryCard(
                type: .levelUp,
                text: page.text,
                imageName: page.imageName ?? ""
            )
            .id(currentPageIndex)
            eventButtonView(for: page)
        }
    }

    func endingResultView(ending: Ending) -> some View {
        VStack(spacing: TokenSpacing.none) {
            HStack(spacing: TokenSpacing.sm) {
                DUIcon(.movieSlate, size: .size28)
                Text("엔딩 결과").duFont(.title1).foregroundStyle(Color.white300)
                Spacer()
                Button(action: {
                    SoundService.shared.trigger(.click)
                    onComplete()
                }, label: { DUIcon(.close, size: .size28) })
            }
            .frame(height: 30)
            .padding([.bottom, .horizontal], TokenSpacing.lg)

            StoryCard(
                type: .ending(title: ending.type.title),
                text: ending.type.description,
                imageName: ending.type.imageName
            )
            .id("ending")
            .padding(.top, TokenSpacing.lg)
            .padding(.bottom, TokenSpacing.xl)

            EventButton(type: .ending(
                onSave: {
                    SoundService.shared.trigger(.click)
                    guard let image = renderEndingImage(ending) else { return }
                    PhotoLibraryService.saveImageToPhotoLibrary(image) { success in
                        ToastManager.shared.show(success ? "이미지가 저장되었습니다." : "사진 접근 허용이 필요해요!", anchor: .center)
                    }
                },
                onShare: {
                    SoundService.shared.trigger(.click)
                    currentShareID = UUID().uuidString
                    AnalyticsService.shared
                        .logShareButtonClicked(
                            shareID: currentShareID,
                            resultID: ending.id,
                            shareChannel: ShareChannel.unknown.rawValue
                        )
                    PopupManager.shared.show { shareSheetPopup }
                },
                onRebirth: {
                    SoundService.shared.trigger(.click)
                    PopupManager.shared.show { rebirthConfirmPopupView }
                }
            ))
        }
        .padding(.top, TokenGrid.paddingTop)
    }

    var rebirthConfirmPopupView: some View {
        NoticePopup(
            type: .confirm(
                cancelText: "그냥 살기",
                confirmText: "환생하기",
                cancelAction: {
                    SoundService.shared.trigger(.click)
                    PopupManager.shared.dismiss()
                    onComplete()
                },
                confirmAction: {
                    SoundService.shared.trigger(.click)
                    PopupManager.shared.dismiss()
                    handleRebirthScenario()
                }
            ),
            title: "환생하기",
            text: "전생의 기억은 모두 잃고 새로 태어나게됩니다.\n환생하시겠습니까?"
        )
    }

    @ViewBuilder
    func eventButtonView(for page: ScenarioPage) -> some View {
        switch page.pageType {
        case .story:
            EventButton(type: .next(action: {
                SoundService.shared.trigger(.click)
                handleNextTap()
            }))
        case .choice(let choice):
            EventButton(
                type: .choice(
                    optionA: choice.optionA,
                    optionB: choice.optionB,
                    selected: selected,
                    onSelect: { selection in
                        SoundService.shared.trigger(.click)
                        selected = selection
                        handleChoice(
                            selection == choice.optionA ? .optionA : .optionB
                        )
                    }
                )
            )
        case .result:
            EventButton(type: .reselect(onReselect: {
                SoundService.shared.trigger(.click)
                guard !isShowingAd, let flowID = adRewardFlowID else { return }
                isShowingAd = true

                let screenID = ScreenID.scenario(
                    level: manager.currentScenario?.career.level ?? 0,
                    page: manager.currentPageIndex + 1
                )
                AnalyticsService.shared.enterScreen(screenID)
                AnalyticsService.shared.logAdWatchClicked(
                    adRewardFlowID: flowID,
                    rewardType: .reselect,
                    rewardAmount: 0
                )

                Task {
                    let result = await AdService.shared.showAdWithResult(.interstitial)
                    isShowingAd = false
                    adRewardFlowID = nil

                    if result.success {
                        AnalyticsService.shared.logAdWatchCompleted(
                            adRewardFlowID: flowID,
                            rewardType: .reselect,
                            rewardAmount: 0,
                            adWatchDurationSec: result.watchDurationSec
                        )
                        selected = ""
                        withAnimation(TokenAnimation.crossFade.animation) {
                            manager.reselectChoice()
                            currentPageIndex = manager.currentPageIndex
                        }
                        AnalyticsService.shared.logAdRewardClaimed(
                            adRewardFlowID: flowID,
                            rewardType: .reselect,
                            rewardAmount: 0
                        )
                    }
                }
            }, onComplete: {
                SoundService.shared.trigger(.click)
                handleNextTap()
            }))
            .onAppear { trackReselectOfferIfNeeded(for: page) }
        }
    }
}

// MARK: - 헬퍼
private extension ScenarioStoryView {
    func trackReselectOfferIfNeeded(for page: ScenarioPage) {
        guard case .result = page.pageType, adRewardFlowID == nil else { return }

        let screenID = ScreenID.scenario(
            level: manager.currentScenario?.career.level ?? 0,
            page: manager.currentPageIndex + 1
        )
        AnalyticsService.shared.enterScreen(screenID)

        let flowID = AnalyticsService.shared.makeAdRewardFlowID()
        adRewardFlowID = flowID
        AnalyticsService.shared.logAdOfferViewed(
            adRewardFlowID: flowID,
            rewardType: .reselect,
            rewardAmount: 0
        )
    }

    func restoreEndingIfNeeded() {
        guard manager.currentScenario?.scenarioType == .final,
              let finalChoice = user?.record.choiceHistory[.worldClassDeveloper] else { return }
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
            user?.record.choiceHistory[career] = result
        }

        if manager.currentScenario?.scenarioType == .final {
            calculateAndShowEnding(with: result)
        } else {
            manager.selectChoice(result)
            updatePage()
        }
    }

    func updatePage() {
        withAnimation(TokenAnimation.crossFade.animation) {
            manager.moveToNextPage()
            currentPageIndex = manager.currentPageIndex
        }
    }

    func calculateAndShowEnding(with finalChoice: ChoiceResult) {
        let evt01 = user?.record.choiceHistory[.juniorDeveloper] ?? .optionA
        let evt02 = user?.record.choiceHistory[.nightOwlDeveloper] ?? .optionA
        let evt03 = user?.record.choiceHistory[.famousDeveloper] ?? .optionA
        let evt04 = finalChoice

        let ending = repository.calculateEnding(
            evt01: evt01,
            evt02: evt02,
            evt03: evt03,
            evt04: evt04
        )

        withAnimation(TokenAnimation.fadeInSlow.animation) {
            finalEnding = ending
        }
        SoundService.shared.playBGM(.ending)
    }

    func handleRebirthScenario() {
        if let ending = finalEnding {
            user?.resetForRebirth(ending: ending)

            let pages = repository.fetchRebirthScenarioPages()

            let rebirthScenario = Scenario(
                id: "rebirth",
                career: .unemployed,
                scenarioType: .rebirth,
                pages: pages
            )

            withAnimation(TokenAnimation.fadeInSlow.animation) {
                manager.startScenario(rebirthScenario)
                currentPageIndex = manager.currentPageIndex
                selected = ""
                finalEnding = nil
            }

            SoundService.shared.playBGM(.rebirth)
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
        renderer.isOpaque = true
        return renderer.uiImage
    }

    func makeEndingCard(for ending: Ending) -> some View {
        StoryCard(
            type: .endingDownload(title: ending.type.title),
            text: ending.type.description,
            imageName: ending.type.imageName
        )
    }
}
