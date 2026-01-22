//
//  QuizQuestion.swift
//  SoloDeveloperTraining
//
//  Created by Claude on 1/21/26.
//

import Foundation

/// 퀴즈 문제 데이터 모델
struct QuizQuestion: Codable, Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String

    enum CodingKeys: String, CodingKey {
        case id
        case question
        case options
        case correctAnswerIndex = "correct_answer"
        case explanation
    }
}
