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
    // 화면 상태
    @State private var selectedIndex: Int?
    @State private var isSubmitted: Bool = false

    // 퀴즈 데이터 (예시)
    let currentQuizNumber: Int = 1
    let totalQuizNumber: Int = 3
    let remainSeconds: Int = 60
    let questionTitle = "오늘은 중요한 기능을 배포하는 날이다. 다음 중 개발자가 가장 들으면 안되는 말은?"
    let reward: Int = 20
    let options: [String] = [
        "(컴펌 코드도 보아) 이 부분요?",
        "(함께 코드를 보며) 이 부분 빨리 수정 가능할까요?",
        "(컴펌 코드도 보아) 이 부분 빨리 수정 가능할까요?",
        "(컴펌 코드도 보아) 이 부분 빨리 수정 가능할까요?"
    ]
    let correctAnswerIndex: Int = 1  // 정답 인덱스 (예시)
    let explanation: String = "해설 어쩌구 저쩌구다."  // 해설 텍스트

    var body: some View {

            VStack(spacing: 0) {
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
                        Text("\(currentQuizNumber) / \(totalQuizNumber)")
                            .textStyle(.headline)
                    }
                    .padding(.bottom, Constant.Padding.quizCountBottom)

                    // progressBar
                    ProgressBar(
                        maxValue: Double(totalQuizNumber),
                        currentValue: Double(currentQuizNumber),
                        text: "\(remainSeconds)s"
                    ).padding(.bottom, Constant.Padding.remainSecondsBottom)

                    // 문제
                    Text(questionTitle)
                        .textStyle(.title)
                        .padding(.bottom, Constant.Padding.questionTitleBottom)
                        .fixedSize(horizontal: false, vertical: true)

                    // 보상
                    HStack {
                        Spacer()
                        CurrencyLabel(axis: .horizontal, icon: .diamond, textStyle: .title2, value: reward)
                    }
                }

                // 해설
                if isSubmitted {
                    Text(explanation)
                        .textStyle(.callout)
                        .foregroundColor(
                            isCorrect ? AppColors.accentGreen : AppColors.accentRed
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                } else {
                    Spacer()
                }

                VStack(spacing: 0) {
                    // 선지 4개
                    VStack(spacing: Constant.Spacing.quizButton) {
                        ForEach(options.indices, id: \.self) { index in
                            QuizButton(
                                isSelected: selectedIndex == index,
                                title: "\(index + 1). \(options[index])"
                            ) {
                                if !isSubmitted {
                                    selectedIndex = selectedIndex == index ? nil : index
                                }
                            }
                            .disabled(isSubmitted)
                        }
                    }
                    .padding(.bottom, Constant.Padding.optionsBottom)

                    // submit 버튼
                    QuizButton(
                        style: .submit,
                        isEnabled: selectedIndex != nil && !isSubmitted,
                        title: isSubmitted ? "다음으로" : "제출하기"
                    ) {
                        if !isSubmitted {
                            isSubmitted = true
                        } else {
                            // 다음 문제로 이동
                        }
                    }
                    .padding(.bottom, Constant.Padding.submitBottom)
                }
            }
            .padding(.horizontal, Constant.Padding.horizontal)
            .padding(.top, Constant.Padding.top)
            .background(AppColors.beige100)
        }

    // MARK: - Helper
    private var isCorrect: Bool {
        guard let selected = selectedIndex else { return false }
        return selected == correctAnswerIndex
    }
}

#Preview {
    QuizQuestionView()
}
