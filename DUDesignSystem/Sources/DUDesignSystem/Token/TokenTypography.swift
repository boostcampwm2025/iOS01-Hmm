//
//  TokenTypography.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI
import CoreText

// MARK: - 폰트 이름 상수

enum DUFont {
    static let extraBold = "PFStardustExtraBold"
    static let bold      = "PFStardustBold"
    static let regular   = "PFStardust"
}

// MARK: - 폰트 등록

private enum FontRegistrar {
    /// 앱 번들에서 폰트 파일을 로드하고 시스템에 등록합니다.
    /// Swift `static let`의 특성상 최초 접근 시 단 한 번만 실행됩니다.
    static let register: Void = {
        ["PFStardust-Regular", "PFStardust-Bold", "PFStardust-ExtraBold"].forEach { fileName in
            guard let url = Bundle.module.url(forResource: fileName, withExtension: "ttf") else {
                assertionFailure("[DUDesignSystem] 폰트 파일을 찾을 수 없습니다: \(fileName).ttf")
                return
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()
}

// MARK: - 내부 헬퍼

/// 폰트 등록을 보장한 뒤 타이포그래피 토큰을 반환합니다.
private func makeToken(_ name: String, size: CGFloat, underlined: Bool = false) -> DUTypographyToken {
    _ = FontRegistrar.register
    return DUTypographyToken(.custom(name, size: size), underlined: underlined)
}

// MARK: - 타이포그래피 토큰

/// Figma 디자인 시스템 "개발자 키우기"의 타이포그래피 토큰입니다.
/// PF 스타더스트 폰트 기반이며, 첫 접근 시 자동으로 폰트가 등록됩니다.
public struct DUTypographyToken: Sendable {
    public let font: Font
    public let isUnderlined: Bool

    init(_ font: Font, underlined: Bool = false) {
        self.font = font
        self.isUnderlined = underlined
    }

    /// ExtraBold, 34pt
    public static let largeTitle:  DUTypographyToken = makeToken(DUFont.extraBold, size: 34)

    /// Bold, 28pt
    public static let title:       DUTypographyToken = makeToken(DUFont.bold, size: 28)

    /// Bold, 23pt
    public static let title2:      DUTypographyToken = makeToken(DUFont.bold, size: 23)

    /// Bold, 20pt
    public static let title3:      DUTypographyToken = makeToken(DUFont.bold, size: 20)

    /// ExtraBold, 17pt
    public static let headline:    DUTypographyToken = makeToken(DUFont.extraBold, size: 17)

    /// ExtraBold, 15pt
    public static let subheadline: DUTypographyToken = makeToken(DUFont.extraBold, size: 15)

    /// Bold, 17pt
    public static let body:        DUTypographyToken = makeToken(DUFont.bold, size: 17)

    /// Bold, 16pt
    public static let callout:     DUTypographyToken = makeToken(DUFont.bold, size: 16)

    /// Bold, 12pt
    public static let caption:     DUTypographyToken = makeToken(DUFont.bold, size: 12)

    /// Bold, 12pt
    public static let caption2:    DUTypographyToken = makeToken(DUFont.bold, size: 12)

    /// Bold, 11pt
    public static let label:       DUTypographyToken = makeToken(DUFont.bold, size: 11)

    /// Regular, 11pt — 밑줄 포함
    public static let labelline:   DUTypographyToken = makeToken(DUFont.regular, size: 11, underlined: true)
}

// MARK: - 뷰 모디파이어

@available(iOS 16.0, *)
private struct DUFontModifier: ViewModifier {
    let token: DUTypographyToken

    func body(content: Content) -> some View {
        if token.isUnderlined {
            content.font(token.font).underline()
        } else {
            content.font(token.font)
        }
    }
}

// MARK: - View 확장

public extension View {

    /// `DUTypographyToken` 토큰을 적용합니다. `labelline`의 경우 밑줄이 자동으로 포함됩니다.
    @available(iOS 16.0, *)
    func duFont(_ token: DUTypographyToken) -> some View {
        modifier(DUFontModifier(token: token))
    }
}
