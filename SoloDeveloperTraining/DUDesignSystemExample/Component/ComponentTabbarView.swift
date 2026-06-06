//
//  ComponentTabbarView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentTabbarView: View {

    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack {
            Text("선택된 탭: \(Tabbar.items[selectedIndex].text)")
                .duFont(.caption)
                .foregroundStyle(Color.gray400)

            Tabbar(selectedIndex: $selectedIndex)
            Spacer()
        }
        .padding(TokenGrid.paddingSide)
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Tabbar")
    }
}

#Preview {
    NavigationStack {
        ComponentTabbarView()
    }
}
