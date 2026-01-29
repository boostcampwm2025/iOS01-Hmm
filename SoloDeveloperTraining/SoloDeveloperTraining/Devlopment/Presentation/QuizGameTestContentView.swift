//
//  QuizGameTestContentView.swift
//  SoloDeveloperTraining
//
//  Created by Claude on 1/21/26.
//

import SwiftUI

private enum Constant {
    enum Padding {
        static let horizontal: CGFloat = 16
        static let vertical: CGFloat = 20
        static let questionTop: CGFloat = 40
        static let optionsSpacing: CGFloat = 12
        static let submitTop: CGFloat = 24
    }

    enum Timer {
        static let height: CGFloat = 8
        static let cornerRadius: CGFloat = 4
    }
}

struct QuizGameTestContentView: View {
    // MARK: - Properties
    @State var game: QuizGame

    @Binding var isGameStarted: Bool

    // MARK: - State
    @State private var showCompletionAlert = false
    @State private var hasStarted = false

    init(user: User, isGameStarted: Binding<Bool>) {
        self._isGameStarted = isGameStarted
        self._game = State(initialValue: QuizGame(user: user))
    }

    var body: some View {
        let state = game.state

        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // 헤더 (닫기 버튼, 진행도)
                headerSection

                // 타이머 프로그래스 바
                timerProgressBar

                // 문제 및 선택지
                if state.phase == .questionInProgress || state.phase == .showingExplanation {
                    questionSection
                } else if state.phase == .completed {
                    EmptyView()
                }

                Spacer()
            }
        }
        .onAppear {
            if !hasStarted {
                print("👀 View appeared, starting game")
                game.startGame()
                hasStarted = true
            }
        }
        .alert("퀴즈 완료!", isPresented: $showCompletionAlert) {
            Button("확인") {
                isGameStarted = false
            }
            .withTapSound()
        } message: {
            Text("정답: \(state.correctAnswersCount)/3개\n획득 다이아: \(state.totalDiamondsEarned)개")
        }
        .onChange(of: state.phase) { _, newPhase in
            if newPhase == .completed {
                showCompletionAlert = true
            }
        }
    }
}

// MARK: - View Components
private extension QuizGameTestContentView {
    var headerSection: some View {
        let state = game.state

        return VStack(spacing: 8) {
            HStack {
                Button {
                    game.stopGame()
                    isGameStarted = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }

                Spacer()

                Text(state.progressText)
                    .textStyle(.title3)
                    .foregroundStyle(.black)

                Spacer()

                // 대칭을 위한 투명 공간
                Color.clear.frame(width: 20, height: 20)
            }

            // 현재 다이아 표시
            HStack {
                Image(systemName: "diamond.fill")
                    .foregroundStyle(.blue)
                Text("다이아: \(game.user.wallet.diamond)")
                    .textStyle(.body)
                    .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.vertical, Constant.Padding.vertical)
    }

    var timerProgressBar: some View {
        let state = game.state

        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 배경
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: Constant.Timer.height)

                // 진행 바
                Rectangle()
                    .fill(timerColor)
                    .frame(
                        width: geometry.size.width * state.timerProgress,
                        height: Constant.Timer.height
                    )
                    .animation(.linear(duration: 1.0), value: state.timerProgress)
            }
            .cornerRadius(Constant.Timer.cornerRadius)
        }
        .frame(height: Constant.Timer.height)
        .padding(.horizontal, Constant.Padding.horizontal)
    }

    var timerColor: Color {
        let progress = game.state.timerProgress
        if progress > 0.5 {
            return .blue
        } else if progress > 0.2 {
            return .yellow
        } else {
            return .red
        }
    }

    var questionSection: some View {
        let state = game.state

        return VStack(alignment: .leading, spacing: Constant.Padding.optionsSpacing) {
            // 문제 텍스트
            if let question = state.currentQuestion {
                Text(question.question)
                    .textStyle(.headline)
                    .foregroundStyle(.black)
                    .padding(.top, Constant.Padding.questionTop)
                    .padding(.bottom, Constant.Padding.vertical)

                // 답안 선택지
                ForEach(0..<question.options.count, id: \.self) { index in
                    optionButton(index: index, text: question.options[index])
                }

                // 제출 버튼 또는 해설
                if state.phase == .questionInProgress {
                    submitButton
                } else if state.phase == .showingExplanation {
                    explanationSection
                }
            }
        }
        .padding(.horizontal, Constant.Padding.horizontal)
    }

    func optionButton(index: Int, text: String) -> some View {
        let state = game.state

        return QuizButton(
            isSelected: state.selectedAnswerIndex == index,
            title: "\(index + 1). \(text)"
        ) {
            if state.phase == .questionInProgress {
                game.selectAnswer(index)
            }
        }
        .overlay {
            // 제출 후 정답/오답 표시
            if state.phase == .showingExplanation {
                correctnessOverlay(for: index)
            }
        }
        .disabled(state.phase != .questionInProgress)
    }

    @ViewBuilder
    func correctnessOverlay(for index: Int) -> some View {
        let state = game.state

        return Group {
            if let question = state.currentQuestion {
            if index == question.correctAnswerIndex {
                // 정답에 체크 표시
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.system(size: 24))
                        .padding()
                }
            } else if index == state.selectedAnswerIndex && state.currentAnswerResult != .correct {
                // 선택한 오답에 X 표시
                HStack {
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 24))
                        .padding()
                }
            }
            }
        }
    }

    var submitButton: some View {
        let state = game.state

        return LargeButton(
            title: "제출",
            isEnabled: state.isSubmitEnabled
        ) {
            game.submitSelectedAnswer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Constant.Padding.submitTop)
    }

    var explanationSection: some View {
        let state = game.state

        return VStack(alignment: .leading, spacing: 16) {
            // 정답/오답 표시
            HStack {
                Image(systemName: resultIcon)
                    .foregroundStyle(resultColor)
                    .font(.system(size: 24))
                Text(resultText)
                    .textStyle(.title3)
                    .foregroundStyle(resultColor)
            }

            // 해설
            if let question = state.currentQuestion {
                Text("해설")
                    .textStyle(.headline)
                    .foregroundStyle(.black)

                Text(question.explanation)
                    .textStyle(.body)
                    .foregroundStyle(.gray)
            }

            // 다음 버튼
            LargeButton(
                title: state.nextButtonTitle
            ) {
                game.proceedToNextQuestion()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
        .padding(.top, Constant.Padding.submitTop)
    }

    var resultIcon: String {
        switch game.state.currentAnswerResult {
        case .correct: return "checkmark.circle.fill"
        case .incorrect, .timeout: return "xmark.circle.fill"
        case .none: return ""
        }
    }

    var resultColor: Color {
        switch game.state.currentAnswerResult {
        case .correct: return .green
        case .incorrect, .timeout: return .red
        case .none: return .black
        }
    }

    var resultText: String {
        switch game.state.currentAnswerResult {
        case .correct: return "정답입니다!"
        case .incorrect: return "오답입니다."
        case .timeout: return "시간 초과!"
        case .none: return ""
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isGameStarted = true

        var body: some View {
            QuizGameTestView()
        }
    }

    return PreviewWrapper()
}
