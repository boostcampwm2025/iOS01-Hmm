//
//  Tabbar.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/5/26.
//

import SwiftUI

public struct Tabbar: View {

    public static let items: [(assetName: String, text: String)] = [
        ("work",    "업무"),
        ("skill",   "스킬"),
        ("shop",    "상점"),
        ("mission", "미션"),
    ]

    @Binding public var selectedIndex: Int
    public var hasCompletedMission: Bool

    public init(selectedIndex: Binding<Int>, hasCompletedMission: Bool = false) {
        self._selectedIndex = selectedIndex
        self.hasCompletedMission = hasCompletedMission
    }

    public var body: some View {
        HStack(spacing: TokenSpacing.xs) {
            ForEach(0..<Self.items.count, id: \.self) { index in
                let item = Self.items[index]
                TabbarItem(
                    assetName: item.assetName,
                    text: item.text,
                    state: selectedIndex == index ? .selected : .default,
                    isNew: index == 3 && hasCompletedMission
                ) {
                    selectedIndex = index
                }
            }
        }
    }
}

#Preview {
    Tabbar(selectedIndex: .constant(0))
        .padding()
        .background(Color.beige200)
}
