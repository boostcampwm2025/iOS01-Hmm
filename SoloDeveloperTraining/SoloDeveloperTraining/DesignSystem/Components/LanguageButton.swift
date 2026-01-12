//
//  LanguageButton.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/12/26.
//

import SwiftUI

struct LanguageButton: View {
    let languageType: LanguageType
    let action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 8) {
                    Image(languageType.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    Text(languageType.rawValue)
                        .textStyle(.caption)
                }
                .frame(width: 77, height: 77)
                .background(Rectangle().fill(pastelColor(for: languageType)))
                .offset(x: isPressed ? 2 : 0, y: isPressed ? 2 : 0)

                Rectangle()
                    .fill(Color.black)
                    .frame(width: 77, height: 77)
                    .offset(x: 3, y: 3)
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
