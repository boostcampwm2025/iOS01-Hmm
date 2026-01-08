//
//  Text+Style.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//
//  사용 예시:
//  Text("string")
//      .textStyle(.caption)

import SwiftUI

// MARK: - Font Name
enum PFFontName {
    static let regular = "PFStardust"
    static let bold = "PFStardustBold"
    static let extraBold = "PFStardustExtraBold"
}

// MARK: - Typography Style
struct PFTextStyle: ViewModifier {
    let fontName: String
    let size: CGFloat
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: size))
            .lineSpacing(size * (lineHeight - 1))
    }
}

// MARK: - Typography Preset
enum Typography {

    /// LargeTitle – ExtraBold, 34pt, 130%
    static let largeTitle = PFTextStyle(
        fontName: PFFontName.extraBold,
        size: 34,
        lineHeight: 1.3
    )

    /// Title – Bold, 28pt, 140%
    static let title = PFTextStyle(
        fontName: PFFontName.bold,
        size: 28,
        lineHeight: 1.4
    )

    /// Title2 – Bold, 22pt, 140%
    static let title2 = PFTextStyle(
        fontName: PFFontName.bold,
        size: 22,
        lineHeight: 1.4
    )

    /// Title3 – Bold, 20pt, 140%
    static let title3 = PFTextStyle(
        fontName: PFFontName.bold,
        size: 20,
        lineHeight: 1.4
    )

    /// Headline – ExtraBold, 17pt, 140%
    static let headline = PFTextStyle(
        fontName: PFFontName.extraBold,
        size: 17,
        lineHeight: 1.4
    )

    /// Body – Bold, 17pt, 140%
    static let body = PFTextStyle(
        fontName: PFFontName.bold,
        size: 17,
        lineHeight: 1.4
    )

    /// Callout – Bold, 16pt, 140%
    static let callout = PFTextStyle(
        fontName: PFFontName.bold,
        size: 16,
        lineHeight: 1.4
    )

    /// Subheadline – ExtraBold, 15pt, 140%
    static let subheadline = PFTextStyle(
        fontName: PFFontName.extraBold,
        size: 15,
        lineHeight: 1.4
    )

    /// Caption – ExtraBold, 12pt, 140%
    static let caption = PFTextStyle(
        fontName: PFFontName.extraBold,
        size: 12,
        lineHeight: 1.4
    )

    /// Caption2 – Bold, 12pt, 140%
    static let caption2 = PFTextStyle(
        fontName: PFFontName.bold,
        size: 12,
        lineHeight: 1.4
    )

    /// Label – Bold, 11pt, 140%
    static let label = PFTextStyle(
        fontName: PFFontName.bold,
        size: 11,
        lineHeight: 1.4
    )

    /// LabelLined – Regular, 11pt, 140%
    static let labelLined = PFTextStyle(
        fontName: PFFontName.regular,
        size: 11,
        lineHeight: 1.4
    )
}

enum TextStyle {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case caption
    case caption2
    case label
    case labelLined
}

extension Text {
    func textStyle(_ style: TextStyle) -> some View {
        switch style {
        case .largeTitle:
            self.modifier(Typography.largeTitle)
        case .title:
            self.modifier(Typography.title)
        case .title2:
            self.modifier(Typography.title2)
        case .title3:
            self.modifier(Typography.title3)
        case .headline:
            self.modifier(Typography.headline)
        case .body:
            self.modifier(Typography.body)
        case .callout:
            self.modifier(Typography.callout)
        case .subheadline:
            self.modifier(Typography.subheadline)
        case .caption:
            self.modifier(Typography.caption)
        case .caption2:
            self.modifier(Typography.caption2)
        case .label:
            self.modifier(Typography.label)
        case .labelLined:
            self.modifier(Typography.labelLined)
        }
    }
}
