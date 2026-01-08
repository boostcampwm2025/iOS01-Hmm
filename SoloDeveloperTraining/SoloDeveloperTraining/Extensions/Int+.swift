//
//  Int+.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import Foundation

extension Int {
    var formatted: String {
        Self.decimalFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    private static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
