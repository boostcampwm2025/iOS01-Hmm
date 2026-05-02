import Foundation

struct PolicyVersionMeta: Identifiable {
    let id: String          // Firestore 문서 ID ("latest" or "v1", "v2", ...)
    let version: Int
    let modifiedBy: String
    let modifiedAt: Date

    var isLatest: Bool { id == "latest" }

    var versionLabel: String {
        isLatest ? "최신 (v\(version))" : "v\(version)"
    }

    var modifiedAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: modifiedAt)
    }
}
