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
}

struct QuizQuestionView: View {
    @State private var quizGame: QuizGame

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
                rewardCount: Constant.rewardCount
            )

            /// 해설 영역
            QuizExplanationView(
                isSubmitted: state.phase == .showingExplanation,
                explanation: state.currentQuestion?.explanation ?? "",
                isCorrect: state.currentAnswerResult?.isCorrect ?? false
            )

            /// 선지, 제출버튼 영역
            QuizOptionsView(
                options: state.currentQuestion?.options ?? [],
                selectedIndex: state.selectedAnswerIndex,
                isShowingExplanation: state.phase == .showingExplanation,
                submitButtonTitle: state.phase == .showingExplanation ? state.nextButtonTitle : "제출하기",
                onSelect: { index in
                    quizGame.selectAnswer(index)
                },
                onSubmit: {
                    if state.phase == .showingExplanation {
                        quizGame.proceedToNextQuestion()
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
    }
}

// MARK: - 퀴즈 헤더 뷰
private struct QuizHeaderView: View {
    let currentQuizNumber: Int
    let totalQuizCount: Int
    let remainingSeconds: Int
    let quizTitle: String
    let rewardCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 타이틀
            HStack(spacing: Constant.Spacing.title) {
                Image(.quizDogFace)
                Image(.quizDogFoot)
                Text("개발 퀴즈")
                    .textStyle(.largeTitle)
                Spacer()
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
                maxValue: Double(totalQuizCount),
                currentValue: Double(currentQuizNumber),
                text: "\(remainingSeconds)s"
            )
            .padding(.bottom, Constant.Padding.remainSecondsBottom)

            // 문제
            Text(quizTitle)
                .textStyle(.title)
                .padding(.bottom, Constant.Padding.questionTitleBottom)
                .fixedSize(horizontal: false, vertical: true)

            // 보상
            HStack {
                Spacer()
                CurrencyLabel(axis: .horizontal, icon: .diamond, textStyle: .title2, value: rewardCount)
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
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var resultPrefix: String {
        isCorrect ? "정답\n" : "오답\n"
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

#Preview {
    QuizQuestionView(user: User(
        nickname: "Preview User",
        wallet: Wallet(),
        inventory: Inventory(),
        record: Record()
    ))
}
