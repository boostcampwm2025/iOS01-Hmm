//
//  TokenListView.swift
//  DUDesignSystemExample
//

import SwiftUI

struct TokenListView: View {
    var body: some View {
        List {
            NavigationLink("Color", destination: TokenColorView())
            NavigationLink("Opacity", destination: TokenOpacityView())
            NavigationLink("Elevation", destination: TokenElevationView())
        }
        .navigationTitle("Token")
    }
}

#Preview {
    NavigationStack {
        TokenListView()
    }
}
