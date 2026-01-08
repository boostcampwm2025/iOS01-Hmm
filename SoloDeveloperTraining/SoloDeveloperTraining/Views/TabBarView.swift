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

struct TabBarView: View {
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
        .padding(.vertical, 12)
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
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 2) {
                    Image(tab.imageName)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text(tab.rawValue)
                        .textStyle(.caption)
                }
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: 80, height: 50)
                .background(
                    Rectangle()
                        .fill(isSelected ? Color("test_blue") : Color("test_gray"))
                )
                .offset(x: isPressed ? 2 : 0, y: isPressed ? 2 : 0)

                Rectangle()
                    .fill(Color.black)
                    .frame(width: 80, height: 50)
                    .offset(x: 4, y: 4)
                    .zIndex(-1)
            }
            .animation(.none, value: isSelected)
        }
        .frame(width: 84, height: 54)
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
