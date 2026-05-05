import Foundation
import JavaScriptCore

enum FormulaEvaluator {
    /// 수식을 평가합니다.
    /// - `=` 로 시작하면 수식으로 처리합니다.
    /// - 변수로 한글 항목명 (예: 무직, 탭당 획득량), 전체 경로 (예: career.unemployed),
    ///   언더스코어 (예: career_unemployed), 단축 영문 (예: unemployed) 모두 지원합니다.
    /// - 예: "=무직 * 1.1", "=탭당 획득량 + 5", "=career.unemployed * 2"
    static func evaluate(_ input: String, context: [String: Double], nameContext: [String: Double] = [:]) -> Double? {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        if !trimmed.hasPrefix("=") {
            return Double(trimmed)
        }

        var expression = String(trimmed.dropFirst()).trimmingCharacters(in: .whitespaces)

        // 언더스코어 형식 (fever_tap_decreasePercent)
        let underscoreContext = Dictionary(uniqueKeysWithValues:
            context.map { ($0.key.replacingOccurrences(of: ".", with: "_"), $0.value) }
        )

        // 단축 영문 이름 (마지막 path component), 중복 제거
        var shortNameContext: [String: Double] = [:]
        var ambiguous = Set<String>()
        for (key, value) in context {
            let short = String(key.split(separator: ".").last ?? Substring(key))
            if shortNameContext[short] != nil { ambiguous.insert(short) }
            shortNameContext[short] = value
        }
        for name in ambiguous { shortNameContext.removeValue(forKey: name) }

        // 한글 이름 컨텍스트 (중복 키는 호출부에서 이미 제거됨)
        let koreanContext = nameContext

        // 치환 우선순위: 한글명 → 전체경로 → 언더스코어 → 단축영문
        // 길이 내림차순 정렬로 부분 치환 방지
        var allVars: [(String, Double)] = []
        allVars += koreanContext.map { ($0.key, $0.value) }
        allVars += context.map { ($0.key, $0.value) }
        allVars += underscoreContext.map { ($0.key, $0.value) }
        allVars += shortNameContext.map { ($0.key, $0.value) }
        allVars.sort { $0.0.count > $1.0.count }

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
