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
    }

    enum ForegroundColor {
        static let acquired = Color.black
        static let completed = Color.white
    }
}

struct MissionCardButton: View {
    @Binding var buttonState: ButtonState
    var onTap: (() -> Void)?

    @State private var isPressed: Bool = false

    var body: some View {
        Button {
            if let onTap = onTap {
                onTap()
            } else {
                changeState()
            }
        } label: {
            Text(buttonState.title)
                .textStyle(.label)
                .foregroundStyle(buttonState.foregroundColor)
                .frame(height: Constant.buttonHeight)
                .frame(maxWidth: Constant.buttonWidth)
                .background(buttonState.backgroundColor)
                .animation(.none, value: buttonState)
        }
        .disabled(!buttonState.isEnabled)
        .buttonStyle(.pressable(isPressed: $isPressed))
    }

    private func changeState() {
        if buttonState == .acquired {
            buttonState = .completed
        }
    }
}

// MARK: - ButtonState
extension MissionCardButton {
    enum ButtonState {
        case acquired
        case completed

        var title: String {
            switch self {
            case .acquired:
                return Constant.Title.acquired
            case .completed:
                return Constant.Title.completed
            }
        }

        var backgroundColor: Color {
            switch self {
            case .acquired:
                return Constant.BackgroundColor.acquired
            case .completed:
                return Constant.BackgroundColor.completed
            }
        }

        var foregroundColor: Color {
            switch self {
            case .acquired:
                return Constant.ForegroundColor.acquired
            case .completed:
                return Constant.ForegroundColor.completed
            }
        }

        var isEnabled: Bool {
            switch self {
            case .acquired:
                return true
            case .completed:
                return false
            }
        }
    }
}

#Preview {
    @Previewable @State var buttonState1: MissionCardButton.ButtonState = .acquired
    @Previewable @State var buttonState2: MissionCardButton.ButtonState = .completed

    ZStack {
        Rectangle()
            .fill(AppColors.gray200)

        VStack {
            MissionCardButton(buttonState: $buttonState1)
            MissionCardButton(buttonState: $buttonState2)
        }
        .padding(.horizontal, 16)
    }
    .padding()
}
