//
//  LanguageItem.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct LanguageItem: View {

    public enum LanguageItemState {
        case completed
        case upcoming
        case active
    }

    public enum LanguageType: String {
        case swift  = "languageSwift"
        case kotlin = "languageKotlin"
        case dart   = "languageDart"
        case python = "languagePython"
    }

    public var language: LanguageType
    public var state: LanguageItemState

    public init(language: LanguageType, state: LanguageItemState) {
        self.language = language
        self.state = state
    }

    private var size: CGFloat {
        switch state {
        case .completed: return 38
        case .upcoming:  return 38
        case .active:    return 52
        }
    }

    private var opacity: Double {
        switch state {
        case .completed: return TokenOpacity.opacity20
        case .upcoming:  return TokenOpacity.opacity100
        case .active:    return TokenOpacity.opacity100
        }
    }

    public var body: some View {
        Image(language.rawValue, bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .opacity(opacity)
    }
}

#Preview {
    HStack(spacing: TokenSpacing.md) {
        LanguageItem(language: .swift, state: .completed)
        LanguageItem(language: .swift, state: .upcoming)
        LanguageItem(language: .swift, state: .active)
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
