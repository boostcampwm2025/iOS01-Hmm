//
//  NewQuizGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/18/26.
//

import SwiftUI

import DUDesignSystem

struct NewQuizGameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quizGame: QuizGame
    @State private var showQuizAdPopup: Bool = false
    @State private var showQuizRewardPopup: Bool = false
    @State private var finalDiamondsEarned: Int = 0

    init(user: User) {
        _quizGame = State(initialValue: QuizGame(user: user))
    }

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack(spacing: 0) {
                HStack(spacing: TokenSpacing.xs) {
                    DUIcon(.dogFace, size: .size28)
                    DUIcon(.dogFoot, size: .size28)
                    ItemLabel(text: "개발 퀴즈",
                              font: .title1,
                              color: .black300)
                }
                Spacer()
                DUIcon(.close, size: .size28)
                    .onTapGesture { dismiss() }
            }
            .padding(.top, TokenGrid.paddingTop)
            .padding(.bottom, TokenGrid.paddingBottom)

            // 타이머
            VStack(spacing: TokenSpacing.xs) {
                HStack(spacing: 0) {
                    ItemLabel(text: quizGame.state.progressText,
                              font: .label,
                              color: .black300)
                    Spacer()
                    if quizGame.remainingSeconds > 0 {
                        HStack(spacing: TokenSpacing.xs) {
                            ItemLabel(text: "\(quizGame.remainingSeconds)",
                                      font: .label,
                                      color: .black300)
                            ItemLabel(text: "s",
                                      font: .label,
                                      color: .black300)
                        }
                    } else {
                        ItemLabel(text: "제한 시간 종료",
                                  font: .label,
                                  color: .black300)
                    }
                }
                ProgressBar(progress: quizGame.state.timerProgress)
            }
            .padding(.bottom, TokenSpacing.xl)

            // 문제, 보상
            VStack(spacing: TokenSpacing.xl) {
                HStack(spacing: 0) {
                    ItemLabel(text: quizGame.currentQuestion?.question ?? "",
                              font: .body,
                              color: .black300)
                    Spacer()
                }
                HStack(spacing: 0) {
                    Spacer()
                    ItemLabel(text: "\(Policy.Game.Quiz.diamondsPerCorrect)",
                              icon: .diamond,
                              iconSize: .size20,
                              font: .subheadline,
                              color: .black300)
                }
            }
            .padding(.bottom, TokenSpacing.xl)

            // 해설
            if quizGame.phase == .showingExplanation {
                HStack(spacing: 0) {
                    ItemLabel(text: quizGame.currentAnswerResult?.isCorrect == true ?
                              "정답\n\(quizGame.currentQuestion?.explanation ?? "")" :
                              "오답\n\(quizGame.currentQuestion?.explanation ?? "")",
                              font: .label,
                              color: quizGame.currentAnswerResult?.isCorrect == true ? .accentGreen : .accentRed)
                    Spacer()
                }
            }

            Spacer()

            // 선지 버튼
            VStack(spacing: TokenSpacing.md) {
                ForEach((quizGame.currentQuestion?.options ?? []).indices, id: \.self) { index in
                    let options = quizGame.currentQuestion?.options ?? []
                    QuizButton(text: "\(index + 1). \(options[index])",
                               state: quizGame.selectedAnswerIndex == index ? .selected : .default) {
                        if quizGame.selectedAnswerIndex == index {
                            quizGame.deselectAnswer()
                        } else {
                            quizGame.selectAnswer(index)
                        }
                    }
                    .disabled(quizGame.phase == .showingExplanation)
                }
            }
            .padding(.bottom, TokenSpacing.lg)

            // 제출 버튼
            TextButton(text: quizGame.phase == .showingExplanation ?
                       quizGame.state.nextButtonTitle : "제출하기",
                       type: .primary,
                       state: quizGame.state.isSubmitEnabled || quizGame.phase == .showingExplanation ? .default : .disabled
            ) {
                if quizGame.phase == .showingExplanation {
                    if quizGame.state.nextButtonTitle == "보상받기" {
                        showQuizAdPopup = true
                    } else {
                        quizGame.proceedToNextQuestion()
                    }
                } else {
                    quizGame.submitSelectedAnswer()
                }
            }
            .padding(.bottom, TokenGrid.paddingBottom)
        }
        .padding(.horizontal, TokenGrid.paddingSide)
        .background(Color.beige50)
        .onAppear {
            if quizGame.phase == .ready {
                quizGame.startGame()
            }
        }
        .onChange(of: quizGame.remainingSeconds) { _, newValue in
            if newValue == 3 {
                SoundService.shared.trigger(.quizCountdown)
            } else if newValue == 0 {
                SoundService.shared.trigger(.quizTimeOver)
            }
        }
        .onDisappear {
            SoundService.shared.stopAllSFX()
        }
        .overlay {
            if showQuizAdPopup {
                ZStack {
                    Color.black300PopUpDimStatusBar.ignoresSafeArea()
                    DiamondPopup(
                        type: .ad(
                            cancelText: "닫기",
                            adText: "2배 얻기",
                            cancelAction: {
                                showQuizAdPopup = false
                                quizGame.completeGame(multiplier: 1.0)
                                dismiss()
                            },
                            adAction: {
                                Task { await handleWatchAd() }
                            }
                        ),
                        title: "보너스",
                        text: "퀴즈 풀이를 완료했습니다!\n진정한 개발자에 한 걸음 더 가까워졌습니다.",
                        diamond: quizGame.state.totalDiamondsEarned
                    )
                }
            }
        }
        .overlay {
            if showQuizRewardPopup {
                ZStack {
                    Color.black300PopUpDimStatusBar.ignoresSafeArea()
                    DiamondPopup(
                        type: .default(
                            buttonText: "확인",
                            action: {
                                showQuizRewardPopup = false
                                dismiss()
                            }
                        ),
                        title: "보상 지급 완료!",
                        text: "다이아를 2배로 받았습니다!",
                        diamond: finalDiamondsEarned
                    )
                }
            }
        }
    }
}

// MARK: - Helper
private extension NewQuizGameView {
    func handleWatchAd() async {
        showQuizAdPopup = false
        let success = await AdService.shared.showAdWithResult(.interstitial)
        if success {
            finalDiamondsEarned = quizGame.state.totalDiamondsEarned * 2
            quizGame.completeGame(multiplier: 2.0)
            showQuizRewardPopup = true
        } else {
            quizGame.completeGame(multiplier: 1.0)
            dismiss()
        }
    }
}

#Preview {
    NewQuizGameView(user: User(
        nickname: "Preview",
        wallet: Wallet(),
        inventory: Inventory(),
        record: Record()
    ))
}
