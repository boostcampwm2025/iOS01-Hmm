import Foundation

enum PolicyEnvironment: String, CaseIterable, Identifiable {
    case test = "test"
    case live = "live"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .test: "테스트"
        case .live: "라이브"
        }
    }

    var accentColor: String {
        switch self {
        case .test: "blue"
        case .live: "red"
        }
    }
}
