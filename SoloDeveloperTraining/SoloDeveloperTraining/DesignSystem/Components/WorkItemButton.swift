//
//  WorkItemButton.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/14/26.
//

import SwiftUI

private enum Constant {
    static let buttonHeight: CGFloat = 218
    static let borderWidth: CGFloat = 2
    static let cornerRadius: CGFloat = 4
    static let lockIconSize = CGSize(width: 24, height: 24)
    static let disabledOverlayOpacity: Double = 0.5

    enum Padding {
        static let titleLabelTop: CGFloat = 22
        static let subTitleLabelTop: CGFloat = 4
        static let imageTop: CGFloat = 20
        static let imageHorizontal: CGFloat = 11
        static let imageBottom: CGFloat = 10
    }
}

struct WorkItemButton: View {

    let title: String
    let description: String
    let imageResource: ImageResource
    @Binding var buttonState: ButtonState

    var body: some View {
        Button {
            changeState()
        } label: {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
                    .foregroundStyle(buttonState.backgroundColor)
                    .overlay {
                        if let borderColor = buttonState.borderColor {
                            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                                .stroke(borderColor, lineWidth: Constant.borderWidth)
                        }
                    }
                VStack {
                    Text(title)
                        .foregroundStyle(.black)
                        .textStyle(.headline)
                        .padding(.top, Constant.Padding.titleLabelTop)
                    Text(description)
                        .foregroundStyle(.black)
                        .textStyle(.label)
                        .padding(.top, Constant.Padding.subTitleLabelTop)

                    ZStack {
                        Image(imageResource)
                            .resizable()
                            .padding(.top, Constant.Padding.imageTop)
                            .padding(.horizontal, Constant.Padding.imageHorizontal)
                            .padding(.bottom, Constant.Padding.imageBottom)
                            .overlay {
                                // 비활성 상태일 때 어두운 오버레이 + 자물쇠 아이콘
                                if buttonState == .disabled {
                                    ZStack {
                                        Rectangle()
                                            .foregroundStyle(.black.opacity(Constant.disabledOverlayOpacity))
                                            .padding(.top, Constant.Padding.imageTop)
                                            .padding(.horizontal, Constant.Padding.imageHorizontal)
                                            .padding(.bottom, Constant.Padding.imageBottom)

                                        Image(.lock)
                                            .resizable()
                                            .frame(
                                                width: Constant.lockIconSize.width,
                                                height: Constant.lockIconSize.height
                                            )
                                    }
                                }
                            }
                    }
                }
            }
            .frame(height: Constant.buttonHeight)
        }
        .disabled(buttonState.isDisabled)
    }
}

extension WorkItemButton {
    enum ButtonState {
        case focused
        case normal
        case disabled

        var backgroundColor: Color {
            switch self {
            case .focused, .normal:
                return .beige100
            case .disabled:
                return .beige400
            }
        }

        var borderColor: Color? {
            switch self {
            case .focused:
                return .black
            default:
                return nil
            }
        }

        var isDisabled: Bool {
            switch self {
            case .disabled:
                return true
            default:
                return false
            }
        }
    }

    private func changeState() {
        if buttonState == .normal {
            buttonState = .focused
        } else if buttonState == .focused {
            buttonState = .normal
        }
    }
}

#Preview {
    @Previewable @State var buttonState1: WorkItemButton.ButtonState = .normal
    @Previewable @State var buttonState2: WorkItemButton.ButtonState = .focused
    @Previewable @State var buttonState3: WorkItemButton.ButtonState = .disabled

    VStack(spacing: 20) {
        HStack {
            WorkItemButton(
                title: "타이틀",
                description: "기본 상태",
                imageResource: .backgroundHouse,
                buttonState: $buttonState1
            )
            WorkItemButton(
                title: "타이틀",
                description: "선택 상태",
                imageResource: .backgroundHouse,
                buttonState: $buttonState2
            )
            WorkItemButton(
                title: "타이틀",
                description: "비활성 상태",
                imageResource: .backgroundHouse,
                buttonState: $buttonState3
            )
        }
    }
    .padding(.horizontal)
}
