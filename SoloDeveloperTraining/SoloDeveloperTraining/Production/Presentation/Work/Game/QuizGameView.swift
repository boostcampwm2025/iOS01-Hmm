//
//  QuizGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/22/26.
//

import SwiftUI

import DUDesignSystem

struct QuizGameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quizGame: QuizGame
    @State private var finalDiamondsEarned: Int = 0
    @State private var adRewardFlowID: String?

    init(user: User) {
        _quizGame = State(initialValue: QuizGame(user: user))
    }

    var screenID: ScreenID {
        switch quizGame.phase {
        case .questionInProgress: return .quiz02
        case .showingExplanation:
            return quizGame.state.currentAnswerResult == .correct ? .quiz03 : .quiz04
        default: return .quiz01
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            timerSection
            questionSection
            explanationSection
            Spacer()
            optionsSection
        }
        .ignoresSafeArea(edges: [.top, .bottom])
        .analyticsScreen(screenID)
        .padding(.horizontal, TokenGrid.paddingSide)
        .background(Color.beige50)
        .onAppear {
            if quizGame.phase == .ready {
                quizGame.startGame()
            }
        }
        .onChange(of: quizGame.remainingSeconds) { _, newValue in
            if newValue == 3 {
                SoundService.shared.trigger(.count)
            } else if newValue == 0 {
                SoundService.shared.trigger(.over)
            }
        }
        .onChange(of: quizGame.phase) { _, newValue in
            let phase = quizGame.phase
            if phase == .showingExplanation && quizGame.state.currentAnswerResult == .correct {

            }
        }
        .onDisappear { SoundService.shared.stopAllSFX() }
    }

    // MARK: - Sections

    private var headerSection: some View {
        HStack(spacing: 0) {
            HStack(spacing: TokenSpacing.xs) {
                DUIcon(.dogFace, size: .size28)
                DUIcon(.dogFoot, size: .size28)
                ItemLabel(text: "개발 퀴즈", font: .title1, color: .black300)
            }
            Spacer()
            DUIcon(.close, size: .size28)
                .onTapGesture {
                    SoundService.shared.trigger(.click)
                    dismiss()
                }
        }
        .padding(.top, TokenGrid.paddingTop)
        .padding(.bottom, TokenGrid.paddingBottom)
    }

    private var timerSection: some View {
        VStack(spacing: TokenSpacing.xs) {
            HStack(spacing: 0) {
                ItemLabel(text: quizGame.state.progressText, font: .label, color: .black300)
                Spacer()
                if quizGame.remainingSeconds > 0 {
                    HStack(spacing: TokenSpacing.xs) {
                        ItemLabel(text: "\(quizGame.remainingSeconds)", font: .label, color: .black300)
                        ItemLabel(text: "s", font: .label, color: .black300)
                    }
                } else {
                    ItemLabel(text: "제한 시간 종료", font: .label, color: .black300)
                }
            }
            ProgressBar(progress: quizGame.state.timerProgress)
        }
        .padding(.bottom, TokenSpacing.xl)
    }

    private var questionSection: some View {
        VStack(spacing: TokenSpacing.xl) {
            HStack(spacing: 0) {
                ItemLabel(text: quizGame.currentQuestion?.question ?? "", font: .body, color: .black300, textAlignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            HStack(spacing: 0) {
                Spacer()
                ItemLabel(text: "\(Policy.Game.Quiz.diamondsPerCorrect)", icon: .diamond, iconSize: .size20, font: .subheadline, color: .black300)
            }
        }
        .padding(.bottom, TokenSpacing.xl)
    }

    private var explanationSection: some View {
        Group {
            if quizGame.phase == .showingExplanation {
                HStack(spacing: 0) {
                    ItemLabel(
                        text: quizGame.currentAnswerResult?.isCorrect == true ?
                        "정답\n\(quizGame.currentQuestion?.explanation ?? "")" :
                        "오답 / 정답은 \((quizGame.currentQuestion?.correctAnswerIndex ?? 0) + 1)번이다.\n\(quizGame.currentQuestion?.explanation ?? "")",
                        font: .label,
                        color: quizGame.currentAnswerResult?.isCorrect == true ? .accentGreen : .accentRed,
                        textAlignment: .leading
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
        }
    }

    private var optionsSection: some View {
        VStack(spacing: TokenSpacing.md) {
            VStack(spacing: TokenSpacing.md) {
                ForEach((quizGame.currentQuestion?.options ?? []).indices, id: \.self) { index in
                    let options = quizGame.currentQuestion?.options ?? []
                    QuizButton(
                        text: "\(index + 1). \(options[index])",
                        state: quizGame.selectedAnswerIndex == index ? .selected : .default
                    ) {
                        if quizGame.selectedAnswerIndex == index {
                            quizGame.deselectAnswer()
                        } else {
                            quizGame.selectAnswer(index)
                        }
                    }
                    .disabled(quizGame.phase == .showingExplanation)
                }
            }

            TextButton(
                text: quizGame.phase == .showingExplanation ? quizGame.state.nextButtonTitle : "제출하기",
                type: .primary,
                state: quizGame.state.isSubmitEnabled || quizGame.phase == .showingExplanation ? .default : .disabled
            ) {
                SoundService.shared.trigger(.click)
                if quizGame.phase == .showingExplanation {
                    if quizGame.state.nextButtonTitle == "보상받기" {
                        let flowID = AnalyticsService.shared.makeAdRewardFlowID()
                        adRewardFlowID = flowID
                        AnalyticsService.shared.logAdOfferViewed(
                            adRewardFlowID: flowID,
                            rewardType: .diamond,
                            rewardAmount: quizGame.state.totalDiamondsEarned
                        )
                        PopupManager.shared.show { adPopupOverlay }
                    } else {
                        quizGame.proceedToNextQuestion()
                    }
                } else {
                    quizGame.submitSelectedAnswer()
                }
            }
            .padding(.bottom, TokenGrid.paddingBottom)
        }
    }

    // MARK: - Overlays

    private var adPopupOverlay: some View {
        DiamondPopup(
            type: .ad(
                cancelText: "닫기",
                adText: "2배 얻기",
                cancelAction: {
                    SoundService.shared.trigger(.click)
                    PopupManager.shared.dismiss()
                    if let flowID = adRewardFlowID {
                        AnalyticsService.shared.logAdOfferDismissed(
                            adRewardFlowID: flowID,
                            rewardType: .diamond,
                            rewardAmount: quizGame.state.totalDiamondsEarned,
                            dismissReason: .close
                        )
                        adRewardFlowID = nil
                    }
                    quizGame.completeGame(multiplier: 1.0)
                    dismiss()
                },
                adAction: {
                    SoundService.shared.trigger(.click)
                    Task { await handleWatchAd() }
                }
            ),
            title: "보상 지급",
            text: "퀴즈 풀이를 완료했습니다!\n진정한 개발자에 한 걸음 더 가까워졌습니다.",
            diamond: quizGame.state.totalDiamondsEarned
        )
        .analyticsScreen(.quizReward)
    }

    private var rewardPopupOverlay: some View {
        DiamondPopup(
            type: .default(
                buttonText: "닫기",
                action: {
                    SoundService.shared.trigger(.click)
                    PopupManager.shared.dismiss()
                    dismiss()
                }
            ),
            title: "보상 지급 완료",
            text: "다이아를 두 배로 받았습니다!",
            diamond: finalDiamondsEarned
        )
        .analyticsScreen(.quizRewardResult)
    }
}

// MARK: - Helper
private extension QuizGameView {
    func handleWatchAd() async {
        guard let flowID = adRewardFlowID else { return }
        let baseDiamonds = quizGame.state.totalDiamondsEarned

        AnalyticsService.shared.logAdWatchClicked(
            adRewardFlowID: flowID,
            rewardType: .diamond,
            rewardAmount: baseDiamonds
        )

        let result = await AdService.shared.showAdWithResult(.interstitial)
        if result.isOffline {
            PopupManager.shared.dismiss()
            PopupManager.shared.showNoNetworkAlert()
            return
        }
        adRewardFlowID = nil

        if result.success {
            finalDiamondsEarned = baseDiamonds * 2
            let earnedByAd = finalDiamondsEarned - baseDiamonds

            AnalyticsService.shared.logAdWatchCompleted(
                adRewardFlowID: flowID,
                rewardType: .diamond,
                rewardAmount: earnedByAd,
                adWatchDurationSec: result.watchDurationSec
            )
            quizGame.completeGame(multiplier: 2.0)
            PopupManager.shared.replace { rewardPopupOverlay }
            AnalyticsService.shared.logAdRewardClaimed(
                adRewardFlowID: flowID,
                rewardType: .diamond,
                rewardAmount: earnedByAd
            )
        } else {
            quizGame.completeGame(multiplier: 1.0)
            PopupManager.shared.dismiss()
            dismiss()
        }
    }
}

#Preview {
    QuizGameView(user: User(
        nickname: "Preview User",
        wallet: Wallet(),
        inventory: Inventory(),
        record: Record()
    ))
}
