import Foundation

private let policyDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy.MM.dd HH:mm"
    return f
}()

struct DeployRecord: Identifiable {
    let id: String   // deployedBy + deployedAt 조합으로 stable identity
    let deployedBy: String
    let deployedAt: Date

    var deployedAtFormatted: String { policyDateFormatter.string(from: deployedAt) }
}

struct FieldChangeRecord: Identifiable {
    let id = UUID()
    let fieldId: String
    let fieldName: String
    let before: Double
    let after: Double
    let beforeInput: String  // 수식 또는 숫자 문자열
    let afterInput: String
}

struct PolicyVersionMeta: Identifiable {
    let id: String          // Firestore 문서 ID ("v1", "v2", ...)
    let version: Int
    let modifiedBy: String
    let modifiedAt: Date
    var isDeployedToTest: Bool
    var isDeployedToLive: Bool
    var testDeployments: [DeployRecord]
    var liveDeployments: [DeployRecord]
    var baseVersion: Int?
    var fieldChanges: [FieldChangeRecord]

    var versionLabel: String { "v\(version)" }

    var modifiedAtFormatted: String { policyDateFormatter.string(from: modifiedAt) }
}
