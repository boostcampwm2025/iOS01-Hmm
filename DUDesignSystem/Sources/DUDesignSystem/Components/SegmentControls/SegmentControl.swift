//
//  SegmentControl.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/5/26.
//

import SwiftUI

public struct SegmentControl: View {

    public var leading: String
    public var trailing: String
    @Binding public var selectedIndex: Int

    public init(leading: String, trailing: String, selectedIndex: Binding<Int>) {
        self.leading = leading
        self.trailing = trailing
        self._selectedIndex = selectedIndex
    }

    public var body: some View {
        HStack(spacing: 0) {
            segmentButton(title: leading, index: 0)
            segmentButton(title: trailing, index: 1)
        }
        .background(Color.beige300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xs))
        .tokenShadow(.default)
    }

    @ViewBuilder
    private func segmentButton(title: String, index: Int) -> some View {
        let isSelected = selectedIndex == index
        Text(title)
            .duFont(.caption)
            .foregroundStyle(isSelected ? Color.white300 : Color.orange500)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                isSelected
                    ? RoundedRectangle(cornerRadius: TokenRadius.xs).fill(Color.orange300)
                    : nil
            )
            .contentShape(Rectangle())
            .onTapGesture { selectedIndex = index }
    }
}

#Preview {
    SegmentControl(leading: "업무", trailing: "스킬", selectedIndex: .constant(0))
        .padding()
        .background(Color.beige200)
}
