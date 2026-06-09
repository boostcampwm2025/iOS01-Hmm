//
//  WorkSegmentControl.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct WorkSegmentControl: View {

    public struct Item {
        public var title: String
        public var imageName: String
        public var isLocked: Bool

        public init(title: String, imageName: String, isLocked: Bool = false) {
            self.title = title
            self.imageName = imageName
            self.isLocked = isLocked
        }
    }

    public var items: [Item]
    @Binding public var selectedIndex: Int

    public init(items: [Item], selectedIndex: Binding<Int>) {
        self.items = items
        self._selectedIndex = selectedIndex
    }

    public var body: some View {
        HStack(spacing: TokenSpacing.xs) {
            ForEach(items.indices, id: \.self) { index in
                WorkItemCard(
                    title: items[index].title,
                    imageName: items[index].imageName,
                    state: cardState(for: index),
                    onTap: { selectedIndex = index }
                )
            }
        }
    }

    private func cardState(for index: Int) -> WorkItemCard.WorkItemCardState {
        if items[index].isLocked { return .locked }
        if selectedIndex == index { return .selected }
        return .default
    }
}

#Preview {
    @Previewable @State var selectedIndex: Int = 0

    WorkSegmentControl(
        items: [
            .init(title: "언어 맞추기", imageName: "work_language"),
            .init(title: "스택 맞추기", imageName: "work_stack"),
            .init(title: "탭 하기", imageName: "work_tap"),
            .init(title: "피하기", imageName: "work_dodge", isLocked: true)
        ],
        selectedIndex: $selectedIndex
    )
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
