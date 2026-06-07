//
//  ComponentTabbarView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentTabbarView: View {

    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                Tabbar(selectedIndex: $selectedIndex)
                    .frame(maxWidth: .infinity)
            }

            // MARK: - Controls
            List {
                Section("선택된 탭") {
                    Text(Tabbar.items[selectedIndex].text)
                        .foregroundStyle(Color.gray400)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("Tabbar")
    }
}

#Preview {
    NavigationStack {
        ComponentTabbarView()
    }
}
