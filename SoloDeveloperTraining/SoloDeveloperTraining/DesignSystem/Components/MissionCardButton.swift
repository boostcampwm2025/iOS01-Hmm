//
//  MissionCardButton.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let buttonHeight: CGFloat = 16
    static let buttonWidth: CGFloat = .infinity

    enum Title {
        static let claimable = "획득하기"
        static let claimed = "달성 완료"
    }

    enum BackgroundColor {
        static let claimable = AppColors.accentGreen
        static let claimed = AppColors.gray100
        static let progressTotal = Color.white
        static let progressCurrent = AppColors.orange200
    }

    enum ForegroundColor {
        static let claimable = Color.white
        static let claimed = Color.black
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
                if case .inProgress(let currentValue, let totalValue) = buttonState {
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
        case claimable
        case claimed
        case inProgress(currentValue: Int, totalValue: Int)

        var title: String {
            switch self {
            case .claimable:
                return Constant.Title.claimable
            case .claimed:
                return Constant.Title.claimed
            case .inProgress(let currentValue, let totalValue):
                let percent = Double(currentValue) / Double(totalValue) * 100
                return String(format: "%.2f%%", percent)
            }
        }

        var backgroundColor: Color {
            switch self {
            case .claimable:
                return Constant.BackgroundColor.claimable
            case .claimed:
                return Constant.BackgroundColor.claimed
            case .inProgress:
                return Constant.BackgroundColor.progressTotal
            }
        }

        var foregroundColor: Color {
            switch self {
            case .claimable:
                return Constant.ForegroundColor.claimable
            case .claimed:
                return Constant.ForegroundColor.claimed
            case .inProgress:
                return Constant.ForegroundColor.progress
            }
        }

        var isEnabled: Bool {
            switch self {
            case .claimable:
                return true
            case .claimed, .inProgress:
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
            MissionCardButton(
                buttonState: .inProgress(currentValue: 19, totalValue: 2000)
            ) {
                print("획득하기 버튼 클릭")
            }
            MissionCardButton(buttonState: .claimable) {
                print("획득하기 버튼 클릭")
            }
            MissionCardButton(buttonState: .claimed)
        }
        .padding(.horizontal, 16)
    }
    .padding()
}
