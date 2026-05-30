//
//  TokenTypography.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI
import CoreText

// MARK: - Font Name Constants

public enum DUFont {
    static let extraBold = "PFStardustExtraBold"
    static let bold      = "PFStardustBold"
    static let regular   = "PFStardust"
}

// MARK: - Font Registrar

private enum FontRegistrar {
    /// Swift static let은 최초 접근 시 단 한 번, thread-safe하게 실행됩니다.
    static let register: Void = {
        // PostScript 이름과 파일명이 달라 파일명으로 직접 탐색합니다.
        ["PFStardust-Regular", "PFStardust-Bold", "PFStardust-ExtraBold"].forEach { fileName in
            guard let url = Bundle.module.url(forResource: fileName, withExtension: "ttf") else {
                assertionFailure("[DUDesignSystem] 폰트 파일을 찾을 수 없습니다: \(fileName).ttf")
                return
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()
}

// MARK: - Internal Helper

/// 폰트 등록을 보장하고 Font를 반환합니다. 등록은 최초 1회만 실행됩니다.
private func makeFont(_ name: String, size: CGFloat) -> Font {
    _ = FontRegistrar.register
    return .custom(name, size: size)
}

// MARK: - Typography Tokens

public enum TokenTypography {

    /// largeTitle — Extra Bold, 34px
    public static let largeTitle:  Font = makeFont(DUFont.extraBold, size: 34)

    /// title — Bold, 28px
    public static let title:       Font = makeFont(DUFont.bold, size: 28)

    /// title2 — Bold, 23px
    public static let title2:      Font = makeFont(DUFont.bold, size: 23)

    /// title3 — Bold, 20px
    public static let title3:      Font = makeFont(DUFont.bold, size: 20)

    /// headline — Extra Bold, 17px
    public static let headline:    Font = makeFont(DUFont.extraBold, size: 17)

    /// subheadline — Extra Bold, 15px
    public static let subheadline: Font = makeFont(DUFont.extraBold, size: 15)

    /// body — Bold, 17px
    public static let body:        Font = makeFont(DUFont.bold, size: 17)

    /// callout — Bold, 16px
    public static let callout:     Font = makeFont(DUFont.bold, size: 16)

    /// caption — Bold, 12px
    public static let caption:     Font = makeFont(DUFont.bold, size: 12)

    /// caption2 — Bold, 12px
    public static let caption2:    Font = makeFont(DUFont.bold, size: 12)

    /// label — Bold, 11px
    public static let label:       Font = makeFont(DUFont.bold, size: 11)

    /// labelline — Regular, 11px
    public static let labelline:   Font = makeFont(DUFont.regular, size: 11)
}

