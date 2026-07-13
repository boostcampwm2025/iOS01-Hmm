//
//  ComponentTabbarView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentTabbarView: View {

    @State private var selectedIndex: Int = 0
    @State private var hasCompletedMission: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                Tabbar(selectedIndex: $selectedIndex, hasCompletedMission: hasCompletedMission)
                    .frame(maxWidth: .infinity)
            }

            // MARK: - Controls
            List {
                Section("선택된 탭") {
                    Text(Tabbar.items[selectedIndex].text)
                        .foregroundStyle(Color.gray400)
                }

                Section("뱃지") {
                    Toggle("미션 완료", isOn: $hasCompletedMission)
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
