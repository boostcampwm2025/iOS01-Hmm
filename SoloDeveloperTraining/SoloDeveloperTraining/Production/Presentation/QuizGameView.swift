//
//  QuizGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/22/26.
//

import SwiftUI

private enum Constant {
    static let totalQuizCount: Int = 3
    static let rewardCount: Int = 5

    enum Padding {
        static let horizontal: CGFloat = 16
        static let top: CGFloat = 15
        static let titleBottom: CGFloat = 14
        static let quizCountBottom: CGFloat = 6
        static let remainSecondsBottom: CGFloat = 30
        static let questionTitleBottom: CGFloat = 8
        static let rewardBottom: CGFloat = 8
        static let optionsBottom: CGFloat = 30
        static let submitBottom: CGFloat = 15
    }

    enum Spacing {
        static let title: CGFloat = 2
        static let quizButton: CGFloat = 16
    }

    enum Size {
        static let closeButtonWidth: CGFloat = 28
        static let closeButtonHeight: CGFloat = 28
    }
}

struct QuizGameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quizGame: QuizGame
    @State private var showRewardPopup: Bool = false

    init(user: User) {
        _quizGame = State(initialValue: QuizGame(user: user))
    }

    var body: some View {
        let state = quizGame.state

        VStack(spacing: 0) {

            /// 문제 헤더 영역
            QuizHeaderView(
                currentQuizNumber: state.currentQuestion != nil ? quizGame.currentQuestionIndex + 1 : 0,
                totalQuizCount: Constant.totalQuizCount,
                remainingSeconds: state.remainingSeconds,
                quizTitle: state.currentQuestion?.question ?? "",
                rewardCount: Constant.rewardCount,
                onClose: {
                    dismiss()
                }
            )

            /// 해설 영역
            QuizExplanationView(
                isSubmitted: state.phase == .showingExplanation,
                explanation: state.currentQuestion?.explanation ?? "",
                isCorrect: state.currentAnswerResult?.isCorrect ?? false,
                correctAnswerIndex: state.currentQuestion?.correctAnswerIndex
            )

            /// 선지, 제출버튼 영역
            QuizOptionsView(
                options: state.currentQuestion?.options ?? [],
                selectedIndex: state.selectedAnswerIndex,
                isShowingExplanation: state.phase == .showingExplanation,
                submitButtonTitle: state.phase == .showingExplanation ? state.nextButtonTitle : "제출하기",
                onSelect: { index in
                    if state.selectedAnswerIndex == index {
                        quizGame.deselectAnswer()
                    } else {
                        quizGame.selectAnswer(index)
                    }
                },
                onSubmit: {
                    if state.phase == .showingExplanation {
                        if state.nextButtonTitle == "보상받기" {
                            showRewardPopup = true
                        } else {
                            quizGame.proceedToNextQuestion()
                        }
                    } else {
                        quizGame.submitSelectedAnswer()
                    }
                }
            )
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.top, Constant.Padding.top)
        .background(AppColors.beige100)
        .onAppear {
            if quizGame.state.phase == .ready {
                quizGame.startGame()
            }
        }
        .onChange(of: state.remainingSeconds) { _, newValue in
            if newValue == 2 {
                SoundService.shared.trigger(.countdownTick)
            }
        }
        .overlay {
            if showRewardPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    RewardPopupView(
                        totalDiamondsEarned: state.totalDiamondsEarned,
                        onClose: {
                            quizGame.proceedToNextQuestion()
                            showRewardPopup = false
                            dismiss()
                        }
                    )
                }
            }
        }
    }
}

// MARK: - 퀴즈 헤더 뷰
private struct QuizHeaderView: View {
    let currentQuizNumber: Int
    let totalQuizCount: Int
    let remainingSeconds: Int
    let quizTitle: String
    let rewardCount: Int
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 타이틀
            HStack(spacing: Constant.Spacing.title) {
                Image(.quizDogFace)
                Image(.quizDogFoot)
                Text("개발 퀴즈")
                    .textStyle(.largeTitle)
                Spacer()
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark.square.fill")
                        .resizable()
                        .foregroundStyle(.black)
                        .frame(
                            width: Constant.Size.closeButtonWidth,
                            height: Constant.Size.closeButtonHeight
                        )
                }
            }
            .padding(.bottom, Constant.Padding.titleBottom)

            // 문제 개수
            HStack {
                Spacer()
                Text("\(currentQuizNumber) / \(totalQuizCount)")
                    .textStyle(.headline)
            }
            .padding(.bottom, Constant.Padding.quizCountBottom)

            // Progress
            ProgressBar(
                maxValue: 60.0,
                currentValue: Double(remainingSeconds),
                text: remainingSeconds > 0 ? "\(remainingSeconds)s" : "제한 시간 종료"
            )
            .padding(.bottom, Constant.Padding.remainSecondsBottom)

            // 문제
            Text(quizTitle)
                .textStyle(.title2)
                .padding(.bottom, Constant.Padding.questionTitleBottom)
                .fixedSize(horizontal: false, vertical: true)

            // 보상
            HStack {
                Spacer()
                CurrencyLabel(axis: .horizontal, icon: .diamond, textStyle: .body, value: rewardCount)
            }
            .padding(.bottom, Constant.Padding.rewardBottom)
        }
    }
}

// MARK: - 해설 뷰
private struct QuizExplanationView: View {
    let isSubmitted: Bool
    let explanation: String
    let isCorrect: Bool
    let correctAnswerIndex: Int?

    var body: some View {
        VStack(spacing: 0) {
            if isSubmitted {
                Text(resultPrefix+explanation)
                    .textStyle(.callout)
                    .foregroundColor(
                        isCorrect ? AppColors.accentGreen : AppColors.accentRed
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.8)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var resultPrefix: String {
        if isCorrect {
            return "정답\n"
        } else {
            let answerNumber = (correctAnswerIndex ?? 0) + 1  // 0-based → 1-based
            return "오답 / 정답은 \(answerNumber)번이다.\n"
        }
    }
}

// MARK: - 선지, 제출버튼 뷰
private struct QuizOptionsView: View {
    let options: [String]
    let selectedIndex: Int?
    let isShowingExplanation: Bool
    let submitButtonTitle: String
    let onSelect: (Int) -> Void
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            // 선지
            VStack(spacing: Constant.Spacing.quizButton) {
                ForEach(options.indices, id: \.self) { index in
                    QuizButton(
                        isSelected: selectedIndex == index,
                        title: "\(index + 1). \(options[index])"
                    ) {
                        onSelect(index)
                    }
                    .disabled(isShowingExplanation)
                }
            }
            .padding(.bottom, Constant.Padding.optionsBottom)

            // 제출 버튼
            QuizButton(
                style: .submit,
                isEnabled: isShowingExplanation ? true : selectedIndex != nil,
                title: submitButtonTitle
            ) {
                onSubmit()
            }
            .padding(.bottom, Constant.Padding.submitBottom)
        }
    }
}

// MARK: - 보상 팝업 뷰
private struct RewardPopupView: View {
    let totalDiamondsEarned: Int
    let onClose: () -> Void

    var body: some View {
        Popup(title: "보상 획득") {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("퀴즈 풀이를 완료했습니다!\n진정한 개발자에 한걸음 더 가까워졌습니다.")
                        .textStyle(.body)
                        .padding(.top, 11)
                        .padding(.bottom, 20)

                    HStack(spacing: 4) {
                        Text("획득한 다이아: ")
                            .textStyle(.body)
                        CurrencyLabel(
                            axis: .horizontal,
                            icon: .diamond,
                            textStyle: .body,
                            value: totalDiamondsEarned
                        )
                    }
                    .padding(.bottom, 20)
                }
                MediumButton(title: "종료하기", isFilled: true) {
                    onClose()
                }
            }
        }
        .padding(.horizontal, 40)
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
