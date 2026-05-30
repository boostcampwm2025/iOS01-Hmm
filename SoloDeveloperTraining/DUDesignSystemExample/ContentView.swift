//
//  ContentView.swift
//  DUDesignSystemExample
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Token", destination: TokenListView())
            }
            .navigationTitle("DUDesignSystem")
        }
    }
}

#Preview {
    ContentView()
}
