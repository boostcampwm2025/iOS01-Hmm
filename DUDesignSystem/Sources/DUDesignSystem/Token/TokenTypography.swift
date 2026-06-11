//
//  TokenTypography.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

// MARK: - 폰트 이름 상수

private enum DUFont {
    static let extraBold = "PFStardustExtraBold"
    static let bold      = "PFStardustBold"
    static let regular   = "PFStardust"
    // regular 제거
}

// MARK: - 폰트 등록

private enum FontRegistrar {
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

private func makeToken(_ name: String, size: CGFloat, underlined: Bool = false) -> DUTypographyToken {
    _ = FontRegistrar.register
    return DUTypographyToken(.custom(name, size: size), underlined: underlined)
}

// MARK: - 타이포그래피 토큰

/// Figma 디자인 시스템 "개발자 키우기"의 타이포그래피 토큰입니다.
/// PF 스타더스트 폰트 기반이며, 첫 접근 시 자동으로 폰트가 등록됩니다.
public struct DUTypographyToken: Sendable, Hashable {
    public let font: Font
    public let isUnderlined: Bool

    init(_ font: Font, underlined: Bool = false) {
        self.font = font
        self.isUnderlined = underlined
    }

    public static let title1:      DUTypographyToken = makeToken(DUFont.extraBold, size: 24)
    public static let title2:      DUTypographyToken = makeToken(DUFont.bold,      size: 20)
    public static let headline:    DUTypographyToken = makeToken(DUFont.extraBold, size: 16)
    public static let subheadline: DUTypographyToken = makeToken(DUFont.extraBold, size: 14)
    public static let body:        DUTypographyToken = makeToken(DUFont.bold,      size: 16)
    public static let body2:       DUTypographyToken = makeToken(DUFont.bold,      size: 14)
    public static let caption:     DUTypographyToken = makeToken(DUFont.extraBold, size: 12)
    public static let label:       DUTypographyToken = makeToken(DUFont.bold,      size: 12)
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

public extension View {
    @available(iOS 16.0, *)
    func duFont(_ token: DUTypographyToken) -> some View {
        modifier(DUFontModifier(token: token))
    }
}
