import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct DevUpAdminApp: App {

    init() {
        FirebaseApp.configure()
        // 어드민 툴은 오프라인 캐시 불필요 — 동시 실행 시 LevelDB 락 오류 방지
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        Firestore.firestore().settings = settings
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
