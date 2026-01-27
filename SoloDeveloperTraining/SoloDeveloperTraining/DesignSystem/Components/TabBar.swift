//
//  TabBarView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let hStack: CGFloat = 4
        static let vStack: CGFloat = 4
    }

    enum Padding {
        static let horizontal: CGFloat = 16
        static let vertical: CGFloat = 10
        static let buttonVertical: CGFloat = 4.5
        static let badgeTrailing: CGFloat = 6
        static let badgeBottom: CGFloat = 40
        static let imageHeight: CGFloat = 24
    }

    enum Size {
        static let imageWidth: CGFloat = 24
        static let imageHeight: CGFloat = 24
        static let badge: CGFloat = 14
    }

    enum Offset {
        static let pressedX: CGFloat = 2
        static let pressedY: CGFloat = 3
        static let shadowX: CGFloat = 2
        static let shadowY: CGFloat = 3
    }
}

enum TabItem: String, CaseIterable {
    case work = "업무"
    case skill = "스킬"
    case shop = "상점"
    case mission = "미션"

    var imageName: String {
        switch self {
        case .work: return "icon_work"
        case .skill: return "icon_skill"
        case .shop: return "icon_shop"
        case .mission: return "icon_mission"
        }
    }
}

struct TabBar: View {
    private var hasCompletedMisson: Bool
    @Binding var selectedTab: TabItem

    init(selectedTab: Binding<TabItem>, hasCompletedMisson: Bool) {
        self._selectedTab = selectedTab
        self.hasCompletedMisson = hasCompletedMisson
    }

    var body: some View {
        HStack(alignment: .center, spacing: Constant.Spacing.hStack) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    hasBadge: tab == .mission && hasCompletedMisson
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, Constant.Padding.horizontal)
        .padding(.vertical, Constant.Padding.vertical)
        .background(AppColors.beige200)
    }
}

private struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let hasBadge: Bool
    let action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: Constant.Spacing.vStack) {
                    Image(tab.imageName)
                        .resizable()
                        .frame(width: Constant.Size.imageWidth, height: Constant.Size.imageHeight)

                    Text(tab.rawValue)
                        .textStyle(.caption)
                }
                .padding(.vertical, Constant.Padding.buttonVertical)
                .foregroundStyle(isSelected ? .white : AppColors.orange500)
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .fill(isSelected ? AppColors.orange300 : AppColors.beige300)
                )
                .offset(x: isPressed ? Constant.Offset.pressedX : 0, y: isPressed ? Constant.Offset.pressedY : 0)
                .layoutPriority(1)

                Rectangle()
                    .fill(Color.black)
                    .offset(x: Constant.Offset.shadowX, y: Constant.Offset.shadowY)
                    .zIndex(-1)
                /// 미션 탭 배지
                if hasBadge {
                    Image(.iconNewBadge)
                        .resizable()
                        .frame(width: Constant.Size.badge, height: Constant.Size.badge)
                        .padding(.trailing, Constant.Padding.badgeTrailing)
                        .padding(.bottom, Constant.Padding.badgeBottom)
                }
            }
            .animation(.none, value: isSelected)
        }
            .buttonStyle(.pressable(isPressed: $isPressed))
    }
}

#Preview {
    @Previewable @State var selectedTab: TabItem = .work
    TabBar(selectedTab: $selectedTab, hasCompletedMisson: true)
}
