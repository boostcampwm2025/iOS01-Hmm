import SwiftUI
import FirebaseCore

@main
struct DevUpAdminApp: App {

    init() { FirebaseApp.configure() }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
