//
//  Int+.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import Foundation

extension Int {
    var formatted: String {
        let absValue = abs(self)
        let sign = self < 0 ? "-" : ""

        switch absValue {
        case 0..<1_000:
            return "\(sign)\(absValue)"
        case 1_000..<1_000_000:
            let value = Double(absValue) / 1_000.0
            return "\(sign)\(formatDecimal(value))K"
        case 1_000_000..<1_000_000_000:
            let value = Double(absValue) / 1_000_000.0
            return "\(sign)\(formatDecimal(value))M"
        default:
            let value = Double(absValue) / 1_000_000_000.0
            return "\(sign)\(formatDecimal(value))B"
        }
    }

    /// 소수점을 적절히 포맷팅합니다 (불필요한 0 제거)
    private func formatDecimal(_ value: Double) -> String {
        // 소수점 이하 2자리까지 표시
        var formatted = String(format: "%.2f", value)

        // 끝의 0 제거
        while formatted.contains(".") && formatted.hasSuffix("0") {
            formatted = String(formatted.dropLast())
        }
        if formatted.hasSuffix(".") {
            formatted = String(formatted.dropLast())
        }

        return formatted
    }
}
