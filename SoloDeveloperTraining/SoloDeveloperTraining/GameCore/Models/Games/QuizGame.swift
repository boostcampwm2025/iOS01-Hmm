//
//  QuizGame.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//


class QuizGame {
    let user: User
    let quizs: [Quiz]

    init(user: User, quizs: [Quiz]) {
        self.user = user
        self.quizs = quizs
    }

    func startGame() {}
    func selectAnswer(quiz: Quiz, answerIndex: Int) -> Bool { return false }
}