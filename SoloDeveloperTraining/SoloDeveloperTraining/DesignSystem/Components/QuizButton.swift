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

    enum Opacity {
        static let pressed: Double = 0.8
        static let unPressed: Double = 1.0
    }
}

struct QuizButton: View {
    @State private var isPressed: Bool = false

    let isSelected: Bool
    let title: String
    let action: () -> Void

    init(
        isSelected: Bool = false,
        title: String,
        action: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.title = title
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .textStyle(.subheadline)
                .foregroundStyle(Constant.Color.foreground)
                .frame(maxWidth: .infinity)
                .frame(height: Constant.height)
                .background(backgroundColor)
                .cornerRadius(Constant.cornerRadius)
                .opacity(isPressed ? Constant.Opacity.pressed : Constant.Opacity.unPressed)
                .animation(.none, value: isSelected)
        }
        .buttonStyle(.pressable(isPressed: $isPressed))
    }

    private var backgroundColor: SwiftUI.Color {
        isSelected ? Constant.Color.selectedBackground : Constant.Color.defaultBackground
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedIndex: Int?
        @State private var isEnabled: Bool = true

        var body: some View {
            VStack(spacing: 20) {
                QuizButton(
                    isSelected: selectedIndex == 0,
                    title: "1. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    selectedIndex = 0
                }

                QuizButton(
                    isSelected: selectedIndex == 1,
                    title: "2. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    selectedIndex = 1
                }

                QuizButton(
                    isSelected: selectedIndex == 2,
                    title: "3. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    selectedIndex = 2
                }

                QuizButton(
                    isSelected: selectedIndex == 3,
                    title: "4. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    selectedIndex = 3
                }

                Button("제출 (비활성화)") {
                    isEnabled = false
                }
                .padding()
            }
            .padding()
            .disabled(!isEnabled)
        }
    }

    return PreviewWrapper()
}
