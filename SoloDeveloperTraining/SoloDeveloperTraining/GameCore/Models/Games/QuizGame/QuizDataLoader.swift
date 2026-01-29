//
//  QuizDataLoader.swift
//  SoloDeveloperTraining
//
//  Created by Claude on 1/21/26.
//

import Foundation

enum QuizDataLoaderError: Error {
    case fileNotFound
    case invalidData
    case decodingError(Error)
    case invalidQuestions
}

/// TSV 파일에서 퀴즈 문제를 로드하는 유틸리티
struct QuizDataLoader {

    /// 지정된 TSV 파일에서 모든 퀴즈 문제를 로드합니다
    /// - Parameter fileName: Resources 폴더의 TSV 파일명 (확장자 제외)
    /// - Returns: 검증된 퀴즈 문제 배열
    /// - Throws: 파일을 찾을 수 없거나 데이터가 유효하지 않은 경우 QuizDataLoaderError
    static func loadQuestions(from fileName: String) throws -> [QuizQuestion] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "tsv") else {
            throw QuizDataLoaderError.fileNotFound
        }

        do {
            let data = try String(contentsOf: url, encoding: .utf8)

            // TSV 파싱: 탭으로 구분
            let lines = data.components(separatedBy: .newlines)

            // 헤더 제거 및 빈 줄 필터링
            let dataLines = lines.dropFirst().filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

            var questions: [QuizQuestion] = []

            for line in dataLines {
                // 탭으로 분리
                let columns = line.components(separatedBy: "\t")
                let trimColumns = columns.map { $0.trimmingCharacters(in: .whitespaces) }

                // TSV 형식: 문제 번호\t문제명\t선지1\t선지2\t선지3\t선지4\t정답\t해설
                guard columns.count == 8,
                      let id = Int(trimColumns[0]),
                      let correctAnswer = Int(trimColumns[6])
                else {
                    continue
                }

                let question = QuizQuestion(
                    id: id,
                    question: trimColumns[1],
                    options: [trimColumns[2], trimColumns[3], trimColumns[4], trimColumns[5]],
                    correctAnswerIndex: correctAnswer - 1, // 1-based -> 0-based
                    explanation: trimColumns[7]
                )
                questions.append(question)
            }

            guard !questions.isEmpty else { throw QuizDataLoaderError.invalidQuestions }
            return questions
        } catch let error as QuizDataLoaderError {
            throw error
        } catch {
            throw QuizDataLoaderError.decodingError(error)
        }
    }

    /// 문제 풀에서 N개의 랜덤 문제를 선택합니다
    /// - Parameters:
    ///   - questions: 사용 가능한 문제 풀
    ///   - count: 선택할 문제 개수
    /// - Returns: 랜덤하게 선택된 문제 배열
    static func selectRandomQuestions(from questions: [QuizQuestion], count: Int) -> [QuizQuestion] {
        return Array(questions.shuffled().prefix(count))
    }
}
