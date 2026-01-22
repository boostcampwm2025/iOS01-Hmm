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
        static let disabledBackground = AppColors.gray200
    }
}

struct QuizButton: View {
    @State private var isPressed: Bool = false

    let style: QuizButtonStyle
    let isSelected: Bool
    let isEnabled: Bool
    let title: String
    let action: () -> Void

    init(
        style: QuizButtonStyle = .option,
        isSelected: Bool = false,
        isEnabled: Bool = true,
        title: String,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.title = title
        self.action = action
    }

    var body: some View {
        Button {
            if isEnabled {
                action()
            }
        } label: {
            Text(title)
                .textStyle(textStyle)
                .foregroundStyle(Constant.Color.foreground)
                .frame(maxWidth: .infinity)
                .frame(height: Constant.height)
                .background(backgroundColor)
                .cornerRadius(Constant.cornerRadius)
                .animation(.none, value: isSelected)
                .animation(.none, value: isEnabled)
        }
        .buttonStyle(.pressable(isPressed: $isPressed))
        .disabled(!isEnabled)
    }
}

// MARK: - Helper
extension QuizButton {
    enum QuizButtonStyle {
        case option      // 선택지 버튼용
        case submit      // 제출 버튼용
    }

    /// 버튼 배경색
    private var backgroundColor: SwiftUI.Color {
        guard isEnabled else {
            return Constant.Color.disabledBackground
        }
        switch style {
        case .option:
            return isSelected ? Constant.Color.selectedBackground : Constant.Color.defaultBackground
        case .submit:
            return Constant.Color.defaultBackground
        }
    }

    /// 버튼 폰트 스타일
    var textStyle: TypographyStyle {
        switch style {
        case .option:
            return .subheadline
        case .submit:
            return .body
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedIndex: Int?

        var body: some View {
            VStack(spacing: 20) {
                // 선택지 버튼들 (토글 가능)
                QuizButton(
                    style: .option,
                    isSelected: selectedIndex == 0,
                    title: "1. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    // 토글: 이미 선택된 버튼이면 해제, 아니면 선택
                    selectedIndex = selectedIndex == 0 ? nil : 0
                }

                QuizButton(
                    style: .option,
                    isSelected: selectedIndex == 1,
                    title: "2. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    selectedIndex = selectedIndex == 1 ? nil : 1
                }

                QuizButton(
                    style: .option,
                    isSelected: selectedIndex == 2,
                    title: "3. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    selectedIndex = selectedIndex == 2 ? nil : 2
                }

                QuizButton(
                    style: .option,
                    isSelected: selectedIndex == 3,
                    title: "4. (함께 코드를 보며) 이 부분 빨리 수정 가능할까요?"
                ) {
                    selectedIndex = selectedIndex == 3 ? nil : 3
                }

                // 제출 버튼
                QuizButton(
                    style: .submit,
                    isEnabled: selectedIndex != nil,
                    title: "제출하기"
                ) {
                    print("제출됨: \(selectedIndex ?? -1)")
                }
            }
            .padding()
        }
    }

    return PreviewWrapper()
}
