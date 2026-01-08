//
//  Typography.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/8/26.
//
//  사용 예시:
//
//  1. Text (lineSpacing 자동 포함)
//     Text("안녕하세요")
//         .textStyle(.caption)
//
//  2. TextField (단일 라인 - lineSpacing 불필요)
//     TextField("입력", text: $text)
//         .font(.pfFont(.body))
//
//  3. TextEditor (다중 라인 - lineSpacing 필요)
//     TextEditor(text: $longText)
//         .font(.pfFont(.body))
//         .lineSpacing(TypographyStyle.body.lineSpacing)
//
//  4. 커스텀 크기
//     Text("특별한 크기")
//         .font(.pfCustom(.extraBold, size: 25))

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

enum TypographyStyle {
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

    var lineSpacing: CGFloat {
        switch self {
        case .largeTitle: return 34 * (1.3 - 1)
        case .title: return 28 * (1.4 - 1)
        case .title2: return 22 * (1.4 - 1)
        case .title3: return 20 * (1.4 - 1)
        case .headline: return 17 * (1.4 - 1)
        case .body: return 17 * (1.4 - 1)
        case .callout: return 16 * (1.4 - 1)
        case .subheadline: return 15 * (1.4 - 1)
        case .caption: return 12 * (1.4 - 1)
        case .caption2: return 12 * (1.4 - 1)
        case .label: return 11 * (1.4 - 1)
        case .labelLined: return 11 * (1.4 - 1)
        }
    }
}

// MARK: - Text Extension
extension Text {
    func textStyle(_ style: TypographyStyle) -> some View {
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

// MARK: - Font Extension
extension Font {
    static func pfFont(_ style: TypographyStyle) -> Font {
        switch style {
        case .largeTitle:
            return .custom(PFFontName.extraBold, size: 34)
        case .title:
            return .custom(PFFontName.bold, size: 28)
        case .title2:
            return .custom(PFFontName.bold, size: 22)
        case .title3:
            return .custom(PFFontName.bold, size: 20)
        case .headline:
            return .custom(PFFontName.extraBold, size: 17)
        case .body:
            return .custom(PFFontName.bold, size: 17)
        case .callout:
            return .custom(PFFontName.bold, size: 16)
        case .subheadline:
            return .custom(PFFontName.extraBold, size: 15)
        case .caption:
            return .custom(PFFontName.extraBold, size: 12)
        case .caption2:
            return .custom(PFFontName.bold, size: 12)
        case .label:
            return .custom(PFFontName.bold, size: 11)
        case .labelLined:
            return .custom(PFFontName.regular, size: 11)
        }
    }

    static func pfCustom(_ weight: PFFontWeight, size: CGFloat) -> Font {
        return .custom(weight.fontName, size: size)
    }
}

enum PFFontWeight {
    case regular
    case bold
    case extraBold

    var fontName: String {
        switch self {
        case .regular: return PFFontName.regular
        case .bold: return PFFontName.bold
        case .extraBold: return PFFontName.extraBold
        }
    }
}
