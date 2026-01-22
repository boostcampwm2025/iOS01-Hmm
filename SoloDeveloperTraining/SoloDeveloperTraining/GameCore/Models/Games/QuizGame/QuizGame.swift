//
//  QuizGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

private enum Constant {
    static let questionsPerGame = 3
    static let secondsPerQuestion = 15
    static let diamondsPerCorrectAnswer = 5
    static let questionLoadFileName = "QuizData"
}

enum QuizGameState: Equatable {
    case loading
    case ready
    case questionInProgress
    case showingExplanation
    case completed
    case error(String)
}

enum QuizAnswerResult {
    case correct
    case incorrect
    case timeout

    var isCorrect: Bool {
        return self == .correct
    }
}

@Observable
final class QuizGame {
    var user: User
    /// 전체 문제 풀
    private var allQuestions: [QuizQuestion] = []
    /// 현재 게임 세션의 3문제
    private(set) var currentGameQuestions: [QuizQuestion] = []
    /// 현재 문제 인덱스 (0-2)
    private(set) var currentQuestionIndex: Int = 0
    /// 현재 표시 중인 문제
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < currentGameQuestions.count else { return nil }
        return currentGameQuestions[currentQuestionIndex]
    }
    /// 선택한 답 인덱스
    private(set) var selectedAnswerIndex: Int?
    /// 현재 문제의 정답/오답 결과
    private(set) var currentAnswerResult: QuizAnswerResult?
    /// 타이머
    private var questionTimer: Timer?
    /// 남은 시간 (초)
    private(set) var remainingSeconds: Int = Constant.secondsPerQuestion
    /// 게임 상태
    private(set) var gameState: QuizGameState = .loading
    /// 맞춘 문제 개수
    private(set) var correctAnswersCount: Int = 0
    /// 획득한 총 다이아
    var totalDiamondsEarned: Int {
        return correctAnswersCount * Constant.diamondsPerCorrectAnswer
    }
    /// 진행도 텍스트 (예: "1/3")
    var progressText: String {
        return "\(currentQuestionIndex + 1)/\(Constant.questionsPerGame)"
    }
    /// 다음/결과 보기 버튼 텍스트
    var nextButtonTitle: String {
        return currentQuestionIndex >= currentGameQuestions.count - 1 ? "결과 보기" : "다음"
    }
    /// 제출 버튼 활성화 여부
    var isSubmitEnabled: Bool {
        return selectedAnswerIndex != nil && gameState == .questionInProgress
    }
    /// 타이머 프로그래스 (0.0 - 1.0)
    var timerProgress: Double {
        return Double(remainingSeconds) / Double(Constant.secondsPerQuestion)
    }

    init(user: User) {
        self.user = user
        loadQuestions()
    }

    deinit {
        stopTimer()
    }

    func startGame() {
        // 3문제 랜덤 선택
        currentGameQuestions = QuizDataLoader.selectRandomQuestions(
            from: allQuestions,
            count: Constant.questionsPerGame
        )

        currentQuestionIndex = 0
        correctAnswersCount = 0
        gameState = .ready

        // 첫 문제 시작
        startQuestion()
    }

    func stopGame() {
        stopTimer()
        gameState = .completed
    }

    /// 답안 제출 처리
    func submitSelectedAnswer() {
        guard gameState == .questionInProgress else {
            return
        }
        guard let answerIndex = selectedAnswerIndex else {
            return
        }
        submitAnswer(answerIndex)
    }

    /// JSON 파일에서 문제 로드
    private func loadQuestions() {
        do {
            allQuestions = try QuizDataLoader.loadQuestions(from: Constant.questionLoadFileName)
            gameState = .ready
        } catch {
            gameState = .error("문제를 불러오는데 실패했습니다: \(error.localizedDescription)")
        }
    }

    /// 문제 시작 (타이머 포함)
    private func startQuestion() {
        guard currentQuestion != nil else {
            gameState = .error("문제를 찾을 수 없습니다")
            return
        }

        // 상태 초기화
        selectedAnswerIndex = nil
        currentAnswerResult = nil
        remainingSeconds = Constant.secondsPerQuestion
        gameState = .questionInProgress

        // 타이머 시작
        startTimer()
    }

    /// 답 선택
    func selectAnswer(_ index: Int) {
        guard gameState == .questionInProgress else { return }
        guard (0...3).contains(index) else { return }
        selectedAnswerIndex = index
    }

    /// 답안 제출
    private func submitAnswer(_ answerIndex: Int) {
        stopTimer()

        guard let question = currentQuestion else {
            return
        }

        // 정답 확인
        let isCorrect = answerIndex == question.correctAnswerIndex
        currentAnswerResult = isCorrect ? .correct : .incorrect

        if isCorrect {
            correctAnswersCount += 1
        }

        gameState = .showingExplanation
    }

    /// 다음 문제로 진행 또는 게임 종료
    func proceedToNextQuestion() {
        guard gameState == .showingExplanation else {
            return
        }

        currentQuestionIndex += 1

        if currentQuestionIndex >= currentGameQuestions.count {
            // 게임 완료, 다이아 지급
            completeGame()
        } else {
            // 다음 문제 시작
            startQuestion()
        }
    }

    /// 게임 완료 및 보상 지급
    private func completeGame() {
        stopTimer()
        // 다이아 보상 지급
        let diamondsToAward = correctAnswersCount * Constant.diamondsPerCorrectAnswer
        user.wallet.addDiamond(diamondsToAward)
        gameState = .completed
    }

    // MARK: - Timer Management

    private func startTimer() {
        stopTimer()

        questionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }

    private func stopTimer() {
        questionTimer?.invalidate()
        questionTimer = nil
    }

    private func timerTick() {
        remainingSeconds -= 1

        if remainingSeconds <= 0 {
            handleTimeout()
        }
    }

    private func handleTimeout() {
        stopTimer()

        // 타임아웃으로 오답 처리
        currentAnswerResult = .timeout
        gameState = .showingExplanation
    }
}
