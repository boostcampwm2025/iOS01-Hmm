//
//  MissionCardButton.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let buttonHeight: CGFloat = 14
    static let buttonWidth: CGFloat = .infinity

    enum Title {
        static let acquired = "획득하기"
        static let completed = "달성 완료"
    }

    enum BackgroundColor {
        static let acquired = Color.white
        static let completed = AppColors.accentGreen
        static let progressTotal = Color.white
        static let progressCurrent = AppColors.orange100
    }

    enum ForegroundColor {
        static let acquired = Color.black
        static let completed = Color.white
        static let progress = Color.black
    }
}

struct MissionCardButton: View {
    let buttonState: ButtonState
    var onTap: (() -> Void)?

    @State private var isPressed: Bool = false

    var body: some View {
        Button {
            onTap?()
        } label: {
            ZStack {
                if case .progress(let currentValue, let totalValue) = buttonState {
                    Rectangle().fill(buttonState.backgroundColor)
                    GeometryReader { geometry in
                        let progress = min(Double(currentValue) / Double(totalValue), 1.0)
                        Rectangle()
                            .fill(Constant.BackgroundColor.progressCurrent)
                            .frame(width: geometry.size.width * progress)
                    }
                } else {
                    Rectangle().fill(buttonState.backgroundColor)
                }

                Text(buttonState.title)
                    .textStyle(.label)
                    .foregroundStyle(buttonState.foregroundColor)
            }
            .frame(height: Constant.buttonHeight)
            .frame(maxWidth: Constant.buttonWidth)
            .animation(.none, value: buttonState)
        }
        .disabled(!buttonState.isEnabled)
        .buttonStyle(.pressable(isPressed: $isPressed))
    }
}

// MARK: - ButtonState
extension MissionCardButton {
    enum ButtonState: Equatable {
        case acquired
        case completed
        case progress(currentValue: Int, totalValue: Int)

        var title: String {
            switch self {
            case .acquired:
                return Constant.Title.acquired
            case .completed:
                return Constant.Title.completed
            case .progress(let currentValue, let totalValue):
                return "\(currentValue.formatted())/\(totalValue.formatted())"
            }
        }

        var backgroundColor: Color {
            switch self {
            case .acquired:
                return Constant.BackgroundColor.acquired
            case .completed:
                return Constant.BackgroundColor.completed
            case .progress:
                return Constant.BackgroundColor.progressTotal
            }
        }

        var foregroundColor: Color {
            switch self {
            case .acquired:
                return Constant.ForegroundColor.acquired
            case .completed:
                return Constant.ForegroundColor.completed
            case .progress:
                return Constant.ForegroundColor.progress
            }
        }

        var isEnabled: Bool {
            switch self {
            case .acquired:
                return true
            case .completed, .progress:
                return false
            }
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(AppColors.gray200)

        VStack {
            MissionCardButton(buttonState: .acquired) {
                print("획득하기 버튼 클릭")
            }
            MissionCardButton(buttonState: .completed)
        }
        .padding(.horizontal, 16)
    }
    .padding()
}
