//
//  QuizButton.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let height: CGFloat = 56
    static let cornerRadius: CGFloat = 10

    enum Color {
        static let foreground = SwiftUI.Color.white
        static let selectedBackground = AppColors.lightOrange
        static let defaultBackground = AppColors.gray700
    }
}

struct QuizButton: View {
    @State private var isSelected: Bool
    let action: () -> Void
    let label: Text

    init(
        isSelected: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Text
    ) {
        self.isSelected = isSelected
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button {
            isSelected.toggle()
            action()
        } label: {
            label
                .textStyle(.subheadline)
                .foregroundStyle(Constant.Color.foreground)
                .frame(maxWidth: .infinity)
                .frame(height: Constant.height)
                .background(backgroundColor)
                .cornerRadius(Constant.cornerRadius)
                .animation(.none, value: isSelected)
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: SwiftUI.Color {
        isSelected ? Constant.Color.selectedBackground : Constant.Color.defaultBackground
    }
}
