//
//  TabBarView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case work = "업무"
    case enhance = "강화"
    case shop = "상점"
    case mission = "미션"

    var imageName: String {
        switch self {
        case .work: return "tab_work"
        case .enhance: return "tab_enhance"
        case .shop: return "tab_shop"
        case .mission: return "tab_mission"
        }
    }
}

struct TabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack(spacing: 4) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(Color(.clear))
    }
}

private struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(tab.imageName)
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(tab.rawValue)
                    .textStyle(.caption)
            }
            .foregroundStyle(isSelected ? .white : AppColors.orange500)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(
                Rectangle()
                    .fill(isSelected ? AppColors.orange300 : AppColors.beige300)
                    .shadow(color: .black, radius: 0, x: 2, y: 3)
            )
            .offset(x: isPressed ? 2 : 0, y: isPressed ? 2 : 0)
            .animation(.none, value: isSelected)
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    @Previewable @State var selectedTab: TabItem = .work
    TabBar(selectedTab: $selectedTab)
}
