//
//  LanguageButton.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/12/26.
//

import SwiftUI

private enum Constant {
    static let vStackSpacing: CGFloat = 8

    enum Size {
        static let imageWidth: CGFloat = 44
        static let imageHeight: CGFloat = 44
        static let buttonWidth: CGFloat = 77
        static let buttonHeight: CGFloat = 77
    }

    enum Offset {
        static let pressedX: CGFloat = 2
        static let pressedY: CGFloat = 2
        static let shadowX: CGFloat = 3
        static let shadowY: CGFloat = 3
    }
}

struct LanguageButton: View {
    let languageType: LanguageType
    let action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: Constant.vStackSpacing) {
                    Image(languageType.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constant.Size.imageWidth, height: Constant.Size.imageHeight)
                    Text(languageType.rawValue)
                        .textStyle(.caption)
                }
                .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
                .background(Rectangle().fill(pastelColor(for: languageType)))
                .offset(x: isPressed ? Constant.Offset.pressedX : 0, y: isPressed ? Constant.Offset.pressedY : 0)

                Rectangle()
                    .fill(Color.black)
                    .frame(width: Constant.Size.buttonWidth, height: Constant.Size.buttonHeight)
                    .offset(x: Constant.Offset.shadowX, y: Constant.Offset.shadowY)
                    .zIndex(-1)
            }
            .animation(.none, value: isPressed)
        }
        .buttonStyle(.pressable(isPressed: $isPressed))
    }

    private func pastelColor(for languageType: LanguageType) -> Color {
        switch languageType.backgroundColorName {
        case "PastelYellow":
            return AppColors.pastelYellow
        case "PastelPink":
            return AppColors.pastelPink
        case "PastelBlue":
            return AppColors.pastelBlue
        case "PastelGreen":
            return AppColors.pastelGreen
        default:
            return AppColors.gray100
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        LanguageButton(languageType: .swift) {
            print("Swift 버튼이 눌렸습니다")
        }
        LanguageButton(languageType: .kotlin) {
            print("Kotlin 버튼이 눌렸습니다")
        }
        LanguageButton(languageType: .dart) {
            print("Dart 버튼이 눌렸습니다")
        }
        LanguageButton(languageType: .python) {
            print("Python 버튼이 눌렸습니다")
        }
    }
    .padding()
}
