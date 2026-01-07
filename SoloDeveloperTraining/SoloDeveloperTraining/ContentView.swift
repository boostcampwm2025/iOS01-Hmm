//
//  ContentView.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import SwiftUI

struct ContentView: View {
    let user = User(
        nickname: "test",
        wallet: .init(),
        inventory: .init(),
        record: .init()
    )
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
