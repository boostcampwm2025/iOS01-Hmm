//
//  LanguageItem.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/12/26.
//

import SwiftUI

private enum Constant {
    static let vStackSpacing: CGFloat = 15

    enum IconSize {
        static let normal: CGFloat = 44
        static let active: CGFloat = 60
    }

    enum Opacity {
        static let completed: Double = 0.5
        static let normal: Double = 1.0
        static let empty: Double = 0.0
    }
}

struct LanguageItem: View {
    let languageType: LanguageType
    let state: LanguageItemState

    var body: some View {
        VStack(alignment: .center, spacing: Constant.vStackSpacing) {
            ZStack {
                if state != .empty {
                    Image(languageType.imageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: iconSize, height: iconSize)

            Text(languageType.rawValue)
                .textStyle(textStyle)
                .lineLimit(1)
                .opacity(opacity)
        }
    }

    // MARK: - Computed Properties

    private var iconSize: CGFloat {
        switch state {
        case .completed, .upcoming, .empty:
            return Constant.IconSize.normal
        case .active:
            return Constant.IconSize.active
        }
    }

    private var opacity: Double {
        switch state {
        case .completed:
            return Constant.Opacity.completed
        case .active, .upcoming:
            return Constant.Opacity.normal
        case .empty:
            return Constant.Opacity.empty
        }
    }

    private var textStyle: TypographyStyle {
        switch state {
        case .completed, .upcoming, .empty:
            return .caption
        case .active:
            return .title3
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            LanguageItem(languageType: .swift, state: .upcoming)
            LanguageItem(languageType: .kotlin, state: .upcoming)
            LanguageItem(languageType: .dart, state: .upcoming)
            LanguageItem(languageType: .python, state: .upcoming)
        }

        HStack(spacing: 20) {
            LanguageItem(languageType: .swift, state: .active)
            LanguageItem(languageType: .kotlin, state: .active)
            LanguageItem(languageType: .dart, state: .active)
            LanguageItem(languageType: .python, state: .active)
        }

        HStack(spacing: 20) {
            LanguageItem(languageType: .swift, state: .completed)
            LanguageItem(languageType: .kotlin, state: .completed)
            LanguageItem(languageType: .dart, state: .completed)
            LanguageItem(languageType: .python, state: .completed)
        }
    }
    .padding()
}
