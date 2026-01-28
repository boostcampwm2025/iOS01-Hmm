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
        static let titleTop: CGFloat = 22
        static let descriptionTop: CGFloat = 4
        static let imageTop: CGFloat = 20
        static let imageHorizontal: CGFloat = 11
        static let imageBottom: CGFloat = 10
    }
}

struct WorkItemButton: View {
    let title: String
    let description: String
    let imageName: String
    @Binding var buttonState: ButtonState
    var onTap: (() -> Void)?

    var body: some View {
        buttonContent
            .disabled(buttonState.isDisabled)
            .onTapGesture {
                if let onTap = onTap {
                    onTap()
                } else {
                    changeState()
                }
            }
    }
}

// MARK: - Subviews
private extension WorkItemButton {

    var buttonContent: some View {
        ZStack(alignment: .top) {
            backgroundShape
            contentStack
        }
        .frame(height: Constant.buttonHeight)
    }

    var backgroundShape: some View {
        RoundedRectangle(cornerRadius: Constant.cornerRadius)
            .foregroundStyle(buttonState.backgroundColor)
            .overlay {
                if let borderColor = buttonState.borderColor {
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .stroke(borderColor, lineWidth: Constant.borderWidth)
                }
            }
    }

    var contentStack: some View {
        VStack(spacing: 0) {
            titleLabel
            descriptionLabel
            itemImage
        }
    }

    var titleLabel: some View {
        Text(title)
            .foregroundStyle(.black)
            .textStyle(.headline)
            .padding(.top, Constant.Padding.titleTop)
    }

    var descriptionLabel: some View {
        Text(description)
            .foregroundStyle(.black)
            .textStyle(.label)
            .padding(.top, Constant.Padding.descriptionTop)
    }

    var itemImage: some View {
        GeometryReader { geometry in
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
        .padding(.top, Constant.Padding.imageTop)
        .padding(.horizontal, Constant.Padding.imageHorizontal)
        .padding(.bottom, Constant.Padding.imageBottom)
        .overlay {
            if buttonState == .disabled {
                disabledOverlay
            }
        }
    }

    var disabledOverlay: some View {
        ZStack {
            Color.black.opacity(Constant.disabledOverlayOpacity)
                .padding(.top, Constant.Padding.imageTop)
                .padding(.horizontal, Constant.Padding.imageHorizontal)
                .padding(.bottom, Constant.Padding.imageBottom)

            Image(.iconLock)
                .resizable()
                .frame(
                    width: Constant.lockIconSize.width,
                    height: Constant.lockIconSize.height
                )
        }
    }
}

// MARK: - Helper
private extension WorkItemButton {
    func changeState() {
        switch buttonState {
        case .normal:
            buttonState = .focused
        case .focused:
            buttonState = .normal
        case .disabled:
            break
        }
    }
}

// MARK: - ButtonState
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
            return self == .disabled
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
                imageName: "housing_street",
                buttonState: $buttonState1
            )
            WorkItemButton(
                title: "타이틀",
                description: "선택 상태",
                imageName: "housing_street",
                buttonState: $buttonState2
            )
            WorkItemButton(
                title: "타이틀",
                description: "비활성 상태",
                imageName: "housing_street",
                buttonState: $buttonState3
            )
        }
    }
    .padding(.horizontal)
}
