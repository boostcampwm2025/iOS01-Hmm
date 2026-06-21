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

struct OldLanguageItem: View {
    let languageType: LanguageType
    let state: LanguageItemState

    var body: some View {
        VStack(alignment: .center, spacing: Constant.vStackSpacing) {
            ZStack {
                if state != .empty {
                    Image(languageType.imageName)
                        .resizable()
                        .scaledToFit()
                        .opacity(opacity)
                }
            }
            .frame(width: iconSize, height: iconSize)

            Text(languageType.rawValue)
                .textStyle(textStyle)
                .fixedSize(horizontal: true, vertical: false)
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
            OldLanguageItem(languageType: .swift, state: .upcoming)
            OldLanguageItem(languageType: .kotlin, state: .upcoming)
            OldLanguageItem(languageType: .dart, state: .upcoming)
            OldLanguageItem(languageType: .python, state: .upcoming)
        }

        HStack(spacing: 20) {
            OldLanguageItem(languageType: .swift, state: .active)
            OldLanguageItem(languageType: .kotlin, state: .active)
            OldLanguageItem(languageType: .dart, state: .active)
            OldLanguageItem(languageType: .python, state: .active)
        }

        HStack(spacing: 20) {
            OldLanguageItem(languageType: .swift, state: .completed)
            OldLanguageItem(languageType: .kotlin, state: .completed)
            OldLanguageItem(languageType: .dart, state: .completed)
            OldLanguageItem(languageType: .python, state: .completed)
        }
    }
    .padding()
}
