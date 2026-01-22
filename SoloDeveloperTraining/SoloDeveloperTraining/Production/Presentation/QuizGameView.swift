//
//  QuizGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/22/26.
//

import SwiftUI

private enum Constant {
    enum Padding {
        static let horizontal: CGFloat = 16
        static let top: CGFloat = 15
        static let titleBottom: CGFloat = 14
        static let quizCountBottom: CGFloat = 6
        static let remainSecondsBottom: CGFloat = 30
        static let questionTitleBottom: CGFloat = 8
        static let optionsBottom: CGFloat = 30
        static let submitBottom: CGFloat = 15
    }

    enum Spacing {
        static let title: CGFloat = 2
        static let quizButton: CGFloat = 16
    }
}

struct QuizQuestionView: View {
    @State private var selectedIndex: Int?
    @State private var isSubmitted = false

    // 예시 데이터
    let currentQuizNumber = 1
    let totalQuizNumber = 3
    let remainSeconds = 60
    let questionTitle = "오늘은 중요한 기능을 배포하는 날이다. 다음 중 개발자가 가장 들으면 안되는 말은?"
    let reward = 20
    let options = [
        "(컴펌 코드도 보아) 이 부분요?",
        "(함께 코드를 보며) 이 부분 빨리 수정 가능할까요?",
        "(컴펌 코드도 보아) 이 부분 빨리 수정 가능할까요?",
        "(컴펌 코드도 보아) 이 부분 빨리 수정 가능할까요?"
    ]
    let correctAnswerIndex = 1
    let explanation = "해설 어쩌구 저쩌구다."

    var body: some View {
        VStack(spacing: 0) {

            /// 문제 헤더 영역
            QuizHeaderView(
                current: currentQuizNumber,
                total: totalQuizNumber,
                remainSeconds: remainSeconds,
                title: questionTitle,
                reward: reward
            )

            /// 해설 영역
            QuizExplanationView(
                isSubmitted: isSubmitted,
                explanation: explanation,
                isCorrect: selectedIndex == correctAnswerIndex
            )

            /// 선지, 제출버튼 영역
            QuizOptionsView(
                options: options,
                selectedIndex: selectedIndex,
                isDisabled: isSubmitted,
                isSubmitted: isSubmitted,
                onSelect: { index in
                    if !isSubmitted {
                        selectedIndex = selectedIndex == index ? nil : index
                    }
                },
                onSubmit: {
                    if !isSubmitted {
                        isSubmitted = true
                    } else {
                        // 다음 문제
                    }
                }
            )
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.top, Constant.Padding.top)
        .background(AppColors.beige100)
    }
}

// MARK: - 퀴즈 해더 뷰
private struct QuizHeaderView: View {
    let current: Int
    let total: Int
    let remainSeconds: Int
    let title: String
    let reward: Int

    var body: some View {
        VStack(spacing: 0) {
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
                Text("\(current) / \(total)")
                    .textStyle(.headline)
            }
            .padding(.bottom, Constant.Padding.quizCountBottom)

            // Progress
            ProgressBar(
                maxValue: Double(total),
                currentValue: Double(current),
                text: "\(remainSeconds)s"
            )
            .padding(.bottom, Constant.Padding.remainSecondsBottom)

            // 문제
            Text(title)
                .textStyle(.title)
                .padding(.bottom, Constant.Padding.questionTitleBottom)
                .fixedSize(horizontal: false, vertical: true)

            // 보상
            HStack {
                Spacer()
                CurrencyLabel(axis: .horizontal, icon: .diamond, textStyle: .title2, value: reward)
            }
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
                Text(explanation)
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
}

// MARK: - QuizButton 사용 뷰
private struct QuizOptionsView: View {
    let options: [String]
    let selectedIndex: Int?
    let isDisabled: Bool
    let isSubmitted: Bool
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
                    .disabled(isDisabled)
                }
            }
            .padding(.bottom, Constant.Padding.optionsBottom)

            // 제출 버튼
            QuizButton(
                style: .submit,
                isEnabled: selectedIndex != nil && !isSubmitted,
                title: isSubmitted ? "다음으로" : "제출하기"
            ) {
                onSubmit()
            }
            .padding(.bottom, Constant.Padding.submitBottom)
        }
    }
}

#Preview {
    QuizQuestionView()
}
