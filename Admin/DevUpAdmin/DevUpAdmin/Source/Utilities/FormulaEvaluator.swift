import Foundation
import JavaScriptCore

enum FormulaEvaluator {
    /// 수식을 평가합니다.
    /// - `=` 로 시작하면 수식으로 처리합니다.
    /// - 변수 이름은 camelCase 단축 이름 (예: unemployed, maxPercent) 또는 전체 경로 언더스코어 (예: fever_tap_decreasePercent)
    /// - 예: "=unemployed * 2", "=100 * 1.5 + 50"
    static func evaluate(_ input: String, context: [String: Double]) -> Double? {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        if !trimmed.hasPrefix("=") {
            return Double(trimmed)
        }

        var expression = String(trimmed.dropFirst()).trimmingCharacters(in: .whitespaces)

        // 언더스코어 형식 변수 (fever_tap_decreasePercent → field id "fever.tap.decreasePercent" 매핑)
        let underscoreContext = Dictionary(uniqueKeysWithValues:
            context.map { (key, value) in
                (key.replacingOccurrences(of: ".", with: "_"), value)
            }
        )

        // 중복 없는 단축 이름 컨텍스트 (마지막 path component)
        var shortNameContext: [String: Double] = [:]
        var ambiguous = Set<String>()
        for (key, value) in context {
            let short = String(key.split(separator: ".").last ?? Substring(key))
            if shortNameContext[short] != nil {
                ambiguous.insert(short)
            }
            shortNameContext[short] = value
        }
        for name in ambiguous { shortNameContext.removeValue(forKey: name) }

        // 길이 내림차순 정렬 후 치환 (부분 치환 방지)
        let allVars = underscoreContext.merging(shortNameContext) { underscore, _ in underscore }
            .sorted { $0.key.count > $1.key.count }

        for (varName, value) in allVars {
            let numStr = value.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(value))
                : String(value)
            expression = expression.replacingOccurrences(of: varName, with: numStr)
        }

        guard let jsContext = JSContext() else { return nil }
        let result = jsContext.evaluateScript(expression)
        guard let result, result.isNumber else { return nil }
        return result.toDouble()
    }
}
