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
    let user: User?
    let manager: ScenarioManager
    let repository: ScenarioRepository
    let backgroundColor: Color?
    let onComplete: () -> Void

    @State private var currentPageIndex: Int
    @State private var selected: String = ""
    @State private var finalEnding: Ending? = nil
    @State private var isShowingAd = false
    @State private var adRewardFlowID: String?

    // 공유하기
    @State private var isShareSheetPresented = false
    @State private var currentShareID = ""
    // 환생하기
    @State private var isRebirthConfirmPopupPresented = false

    init(
        user: User?,
        manager: ScenarioManager,
        repository: ScenarioRepository,
        backgroundColor: Color = .black300EventDim,
        onComplete: @escaping () -> Void
    ) {
        self.user = user
        self.manager = manager
        self.repository = repository
        self.backgroundColor = backgroundColor
        self.onComplete = onComplete
        // 저장된 인덱스로 초기화하여 앱 재시작 시 해당 페이지부터 시작하게 함
        self._currentPageIndex = State(initialValue: manager.currentPageIndex)
    }

    var isEnding: Bool { finalEnding != nil }

    var body: some View {
        ZStack {
            backgroundColor

            VStack(spacing: isEnding ? TokenSpacing.xl : TokenSpacing.lg) {
                if isEnding { endingResultView }

                if let ending = finalEnding {
                    StoryCard(
                        type: .ending(title: ending.type.title),
                        text: ending.type.description,
                        imageName: ending.type.imageName
                    )
                    .id("ending")
                } else if let page = manager.currentPage {
                    StoryCard(
                        type: .levelUp,
                        text: page.text,
                        imageName: page.imageName ?? ""
                    )
                    .id(currentPageIndex)
                }

                if let ending = finalEnding {
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
                            isShareSheetPresented = true
                        },
                        onRebirth: {
                            SoundService.shared.trigger(.click)
                            isRebirthConfirmPopupPresented = true
                        }
                    ))
                } else if let page = manager.currentPage {
                    eventButtonView(for: page)
                }
            }
            .frame(maxHeight: .infinity, alignment: isEnding ? .top : .center)

            if isRebirthConfirmPopupPresented || isShareSheetPresented {
                Color.black300PopUpDimStatusBar.ignoresSafeArea()
            }

            if isShareSheetPresented, let ending = finalEnding {
                ShareSheetView(
                    isPresented: $isShareSheetPresented,
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

            if isRebirthConfirmPopupPresented {
                rebirthConfirmPopupView
            }
        }
        .ignoresSafeArea()
        .onAppear {
            restoreEndingIfNeeded()
        }
    }
}

// MARK: - 서브 뷰
private extension ScenarioStoryView {
    var endingResultView: some View {
        HStack(spacing: TokenSpacing.sm) {
            DUIcon(.movieSlate, size: .size28)
            Text("엔딩 결과").duFont(.title1).foregroundStyle(Color.white300)
            Spacer()
            Button(action: {
                SoundService.shared.trigger(.click)
                onComplete()
            }) {
                DUIcon(.close, size: .size28)
            }
        }
        .frame(height: 30)
        .padding(.top, TokenGrid.paddingTop)
        .padding([.bottom, .horizontal], TokenSpacing.lg)
    }

    var rebirthConfirmPopupView: some View {
        NoticePopup(
            type: .confirm(
                cancelText: "그냥 살기",
                confirmText: "환생하기",
                cancelAction: {
                    SoundService.shared.trigger(.click)
                    onComplete()
                },
                confirmAction: {
                    SoundService.shared.trigger(.click)
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

                AnalyticsService.shared.logAdWatchClicked(
                    adRewardFlowID: flowID,
                    adPlacement: .reselectionReward,
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
                            adPlacement: .reselectionReward,
                            rewardType: .reselect,
                            rewardAmount: 0,
                            adWatchDurationSec: result.watchDurationSec
                        )
                        selected = ""
                        withAnimation(Animation.standard) {
                            manager.reselectChoice()
                            currentPageIndex = manager.currentPageIndex
                        }
                        AnalyticsService.shared.logAdRewardClaimed(
                            adRewardFlowID: flowID,
                            adPlacement: .reselectionReward,
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

        let flowID = AnalyticsService.shared.makeAdRewardFlowID()
        adRewardFlowID = flowID
        AnalyticsService.shared.logAdOfferViewed(
            adRewardFlowID: flowID,
            adPlacement: .reselectionReward,
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
        withAnimation(Animation.standard) {
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

        withAnimation(Animation.standard) {
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

            manager.startScenario(rebirthScenario)

            currentPageIndex = manager.currentPageIndex
            selected = ""
            finalEnding = nil

            isRebirthConfirmPopupPresented = false
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
        renderer.isOpaque = false
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
