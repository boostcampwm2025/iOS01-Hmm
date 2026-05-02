import Foundation

struct PolicyVersionMeta: Identifiable {
    let id: String          // Firestore 문서 ID ("v1", "v2", ...)
    let version: Int
    let modifiedBy: String
    let modifiedAt: Date
    var isDeployedToTest: Bool
    var isDeployedToLive: Bool

    var versionLabel: String { "v\(version)" }

    var modifiedAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: modifiedAt)
    }
}
