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
                    ItemLabel(text: "\(quizGame.remainingSeconds)s",
                              font: .label,
                              color: .black300)
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
            HStack(spacing: 0) {
                ItemLabel(text: quizGame.currentAnswerResult?.isCorrect == true ?
                          "정답\n\(quizGame.currentQuestion?.explanation ?? "")" :
                          "오답\n\(quizGame.currentQuestion?.explanation ?? "")",
                          font: .label,
                          color: .accentGreen)
                Spacer()
            }

            Spacer()

            // 선지 버튼
            VStack(spacing: TokenSpacing.md) {
                ForEach((quizGame.currentQuestion?.options ?? []).indices, id: \.self) { index in
                    let options = quizGame.currentQuestion?.options ?? []
                    QuizButton(text: "\(index + 1)",
                               state: quizGame.selectedAnswerIndex == index ? .selected : .default)
                    {
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
                    quizGame.proceedToNextQuestion()
                } else {
                    quizGame.submitSelectedAnswer()
                }
            }
            .padding(.bottom, TokenGrid.paddingBottom)
        }
        .padding(.horizontal, TokenGrid.paddingSide)
        .onAppear {
            quizGame.startGame()
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
        .background(Color.beige50)
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
