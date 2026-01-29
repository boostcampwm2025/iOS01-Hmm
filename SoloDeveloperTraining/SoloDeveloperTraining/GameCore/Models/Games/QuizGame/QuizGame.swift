//
//  QuizGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation
import Observation

private enum Constant {
    /// 퀴즈 데이터 파일명 (확장자 제외)
    static let questionLoadFileName = "QuizData"
}

@Observable
final class QuizGame {
    /// 게임을 플레이하는 사용자
    var user: User
    /// 리소스 파일에서 로드한 전체 문제 풀
    private var allQuestions: [QuizQuestion] = []
    /// 현재 게임 세션에서 출제된 문제들 (게임당 3문제)
    private(set) var currentGameQuestions: [QuizQuestion] = []
    /// 현재 풀고 있는 문제의 인덱스 (0부터 시작, 0~2)
    private(set) var currentQuestionIndex: Int = 0
    /// 현재 표시 중인 문제
    /// - currentQuestionIndex가 유효한 범위일 때만 반환
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < currentGameQuestions.count else { return nil }
        return currentGameQuestions[currentQuestionIndex]
    }
    /// 사용자가 선택한 답안의 인덱스 (0~3)
    /// - nil이면 아직 답을 선택하지 않은 상태
    private(set) var selectedAnswerIndex: Int?
    /// 현재 문제의 정답/오답/타임아웃 결과
    /// - 답안 제출 후에만 값이 설정됨
    private(set) var currentAnswerResult: QuizAnswerResult?
    /// 문제당 타이머
    /// - 문제 시작 시 생성되고, 답안 제출 또는 타임아웃 시 중지됨
    private var questionTimer: Timer?
    /// 현재 문제의 남은 시간 (초)
    /// - 매 초마다 1씩 감소
    private(set) var remainingSeconds: Int = Policy.Game.Quiz.secondsPerQuestion
    /// 게임의 현재 진행 단계
    private(set) var phase: QuizGamePhase = .loading
    /// 현재 세션에서 맞춘 문제 개수
    private(set) var correctAnswersCount: Int = 0

    /// 모든 상태 정보
    var state: QuizGameState {
        QuizGameState(
            totalDiamondsEarned: correctAnswersCount * Policy.Game.Quiz.diamondsPerCorrect,
            progressText: "\(currentQuestionIndex + 1)/\(Policy.Game.Quiz.questionsPerGame)",
            nextButtonTitle: currentQuestionIndex >= currentGameQuestions.count - 1 ? "보상받기" : "다음으로",
            isSubmitEnabled: selectedAnswerIndex != nil && phase == .questionInProgress,
            timerProgress: Double(remainingSeconds) / Double(Policy.Game.Quiz.secondsPerQuestion),
            phase: phase,
            currentQuestion: currentQuestion,
            selectedAnswerIndex: selectedAnswerIndex,
            currentAnswerResult: currentAnswerResult,
            remainingSeconds: remainingSeconds,
            correctAnswersCount: correctAnswersCount
        )
    }

    init(user: User) {
        self.user = user
        loadQuestions()
    }

    deinit {
        stopTimer()
    }

    /// 새로운 게임 세션 시작
    /// - 전체 문제 풀에서 랜덤하게 3문제 선택
    /// - 게임 상태 초기화 (점수, 인덱스 등)
    /// - 첫 번째 문제 자동 시작
    func startGame() {
        // 랜덤하게 3문제 선택
        currentGameQuestions = QuizDataLoader.selectRandomQuestions(
            from: allQuestions,
            count: Policy.Game.Quiz.questionsPerGame
        )

        // 게임 상태 초기화
        currentQuestionIndex = 0
        correctAnswersCount = 0
        phase = .ready

        // 첫 문제 시작
        startQuestion()
    }

    /// 게임 강제 종료
    /// - 타이머를 중지하고 게임 상태를 완료로 변경
    /// - 사용자가 중도 포기하는 경우 호출
    func stopGame() {
        stopTimer()
        phase = .completed
    }

    /// 답 선택
    /// - Parameter index: 선택한 답안의 인덱스 (0~3)
    /// - Note: 문제 풀이 중일 때만 선택 가능
    func selectAnswer(_ index: Int) {
        guard phase == .questionInProgress else { return }
        guard (0...3).contains(index) else { return }
        selectedAnswerIndex = index
    }

    /// 선택한 답안 해제
    /// - Note: 문제 풀이 중일 때만 선택 해제 가능
    func deselectAnswer() {
        guard phase == .questionInProgress else { return }
        selectedAnswerIndex = nil
    }

    /// 선택한 답안 제출
    /// - 문제 풀이 중이고, 답을 선택한 상태일 때만 제출 가능
    /// - 제출 후 타이머 중지 및 결과 표시
    func submitSelectedAnswer() {
        guard phase == .questionInProgress else { return }
        guard let answerIndex = selectedAnswerIndex else { return }
        submitAnswer(answerIndex)
    }

    /// 다음 문제로 진행 또는 게임 종료
    /// - 해설 표시 중일 때만 호출 가능
    /// - 마지막 문제가 아니면: 다음 문제 시작
    /// - 마지막 문제면: 게임 완료 및 보상 지급
    func proceedToNextQuestion() {
        guard phase == .showingExplanation else { return }

        currentQuestionIndex += 1

        if currentQuestionIndex >= currentGameQuestions.count {
            // 모든 문제 완료 - 보상 지급 및 게임 종료
            completeGame()
        } else {
            // 다음 문제 시작
            startQuestion()
        }
    }
}

private extension QuizGame {

    /// 리소스 파일에서 문제 데이터 로드
    /// - TSV 파일에서 모든 문제를 읽어와 allQuestions에 저장
    /// - 로드 성공 시 게임 상태를 ready로 변경
    /// - 실패 시 에러 메시지와 함께 error 상태로 변경
    func loadQuestions() {
        do {
            allQuestions = try QuizDataLoader.loadQuestions(from: Constant.questionLoadFileName)
            phase = .ready
        } catch {
            phase = .error("문제를 불러오는데 실패했습니다: \(error.localizedDescription)")
        }
    }

    /// 새로운 문제 시작
    /// - 선택한 답안, 결과, 타이머를 초기화
    /// - 게임 상태를 questionInProgress로 변경
    /// - 타이머 시작
    func startQuestion() {
        guard currentQuestion != nil else {
            phase = .error("문제를 찾을 수 없습니다")
            return
        }

        // 상태 초기화
        selectedAnswerIndex = nil
        currentAnswerResult = nil
        remainingSeconds = Policy.Game.Quiz.secondsPerQuestion
        phase = .questionInProgress

        // 타이머 시작
        startTimer()
    }

    /// 답안 제출 처리
    /// - Parameter answerIndex: 제출할 답안의 인덱스
    /// - 타이머 중지
    /// - 정답 확인 후 결과 저장
    /// - 정답일 경우 correctAnswersCount 증가
    /// - 게임 상태를 showingExplanation으로 변경
    func submitAnswer(_ answerIndex: Int) {
        stopTimer()

        guard let question = currentQuestion else { return }

        // 정답 확인
        let isCorrect = answerIndex == question.correctAnswerIndex
        currentAnswerResult = isCorrect ? .correct : .incorrect

        if isCorrect {
            correctAnswersCount += 1
        }

        SoundService.shared.trigger(isCorrect ? .languageCorrect : .languageWrong)
        phase = .showingExplanation
    }

    /// 게임 완료 처리
    /// - 타이머 중지
    /// - 획득한 다이아를 사용자 지갑에 추가
    /// - 게임 상태를 completed로 변경
    func completeGame() {
        stopTimer()

        // 다이아 보상 지급 (정답당 5개)
        let diamondsToAward = correctAnswersCount * Policy.Game.Quiz.diamondsPerCorrect
        user.wallet.addDiamond(diamondsToAward)

        phase = .completed
    }

    /// 타이머 시작
    /// - 기존 타이머가 있으면 먼저 정지
    /// - 1초마다 timerTick() 호출하는 타이머 생성
    /// - weak self를 사용하여 메모리 누수 방지
    func startTimer() {
        stopTimer()

        questionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }

    /// 타이머 중지 및 정리
    /// - 타이머 무효화
    /// - 타이머 참조 해제
    func stopTimer() {
        questionTimer?.invalidate()
        questionTimer = nil
    }

    /// 매 초마다 호출되는 타이머 틱
    /// - 남은 시간 1초 감소
    /// - 시간이 0이 되면 타임아웃 처리
    func timerTick() {
        remainingSeconds -= 1

        if remainingSeconds <= 0 {
            handleTimeout()
        }
    }

    /// 시간 초과 처리
    /// - 타이머 중지
    /// - 결과를 timeout으로 설정
    /// - 해설 화면으로 전환 (오답과 동일한 처리)
    func handleTimeout() {
        stopTimer()

        currentAnswerResult = .timeout
        phase = .showingExplanation
    }
}
