import Foundation
import JavaScriptCore

enum FormulaEvaluator {

    enum EvalResult {
        case value(Double)
        case divisionByZero
        case unknownIdentifier(String)
        case invalid
    }

    /// 수식을 평가합니다.
    /// - `=` 로 시작하면 수식으로 처리합니다.
    /// - 변수로 한글 항목명 (예: 무직, 탭당 획득량), 전체 경로 (예: career.unemployed),
    ///   언더스코어 (예: career_unemployed), 단축 영문 (예: unemployed) 모두 지원합니다.
    /// - 예: "=무직 * 1.1", "=탭당 획득량 + 5", "=career.unemployed * 2"
    static func evaluate(_ input: String, context: [String: Double], nameContext: [String: Double] = [:]) -> Double? {
        if case .value(let v) = evaluateDetailed(input, context: context, nameContext: nameContext) {
            return v
        }
        return nil
    }

    static func evaluateDetailed(_ input: String, context: [String: Double], nameContext: [String: Double] = [:]) -> EvalResult {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        if !trimmed.hasPrefix("=") {
            guard let v = Double(trimmed) else { return .invalid }
            return .value(v)
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

        // 알려진 식별자 집합
        let knownIdentifiers = Set(allVars.map(\.0))

        for (varName, value) in allVars {
            let numStr = value.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(value))
                : String(value)
            expression = expression.replacingOccurrences(of: varName, with: numStr)
        }

        // 치환 후 남은 알파벳/한글 식별자가 있으면 미정의 필드명
        let identifierPattern = "[a-zA-Z가-힣_][a-zA-Z가-힣0-9_.]*"
        if let regex = try? NSRegularExpression(pattern: identifierPattern),
           let match = regex.firstMatch(in: expression, range: NSRange(expression.startIndex..., in: expression)) {
            let range = Range(match.range, in: expression)!
            let unknown = String(expression[range])
            // JS 내장 함수(Math 등)는 허용
            if !unknown.hasPrefix("Math") {
                // 원본 수식에서 해당 토큰이 knownIdentifiers에 없는 경우만 오류
                let originalExpression = String(trimmed.dropFirst()).trimmingCharacters(in: .whitespaces)
                let originalMatches = (try? NSRegularExpression(pattern: identifierPattern))?
                    .matches(in: originalExpression, range: NSRange(originalExpression.startIndex..., in: originalExpression))
                    .compactMap { Range($0.range, in: originalExpression).map { String(originalExpression[$0]) } } ?? []
                if let unknownOriginal = originalMatches.first(where: { !knownIdentifiers.contains($0) && !$0.hasPrefix("Math") }) {
                    return .unknownIdentifier(unknownOriginal)
                }
            }
        }

        guard let jsContext = JSContext() else { return .invalid }
        jsContext.exceptionHandler = { _, _ in }
        let result = jsContext.evaluateScript(expression)
        guard let result, result.isNumber else { return .invalid }
        let value = result.toDouble()

        if value.isNaN { return .invalid }
        if value.isInfinite { return .divisionByZero }
        return .value(value)
    }
}
