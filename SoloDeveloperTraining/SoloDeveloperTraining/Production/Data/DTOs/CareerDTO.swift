//
//  CareerDTO.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-26.
//

import Foundation

struct CareerDTO: Codable {
    let rawValue: String

    init(from career: Career) {
        self.rawValue = career.rawValue
    }

    func toCareer() -> Career {
        Career(rawValue: rawValue) ?? .unemployed
    }
}
