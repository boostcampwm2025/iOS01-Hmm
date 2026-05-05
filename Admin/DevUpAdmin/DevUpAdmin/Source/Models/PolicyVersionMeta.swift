import Foundation

struct DeployRecord: Identifiable {
    let id = UUID()
    let deployedBy: String
    let deployedAt: Date

    var deployedAtFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd HH:mm"
        return f.string(from: deployedAt)
    }
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

    var versionLabel: String { "v\(version)" }

    var modifiedAtFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd HH:mm"
        return f.string(from: modifiedAt)
    }
}
