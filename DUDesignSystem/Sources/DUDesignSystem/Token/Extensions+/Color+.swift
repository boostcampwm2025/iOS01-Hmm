//
//  Color+.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

/// Figma 디자인 시스템 "개발자 키우기"의 컬러 토큰입니다.
public extension Color {

    // MARK: - White

    static let white300           = Color(hex: "#FFFFFF")
    static let white300StatusBar  = Color(hex: "#FFFFFF").opacity(0.8)

    // MARK: - Black

    static let black300                 = Color(hex: "#000000")
    static let black300EventDim         = Color(hex: "#000000").opacity(0.9)
    static let black300PopUpDimStatusBar = Color(hex: "#000000").opacity(0.3)
    static let black300GrayBar          = Color(hex: "#000000").opacity(0.1)

    // MARK: - Gray

    static let gray100 = Color(hex: "#D9D9D9")
    static let gray200 = Color(hex: "#B4B4B4")
    static let gray400 = Color(hex: "#6A6A6A")
    static let gray700 = Color(hex: "#111111")

    // MARK: - Orange

    static let orange200 = Color(hex: "#F3A487")
    static let orange300 = Color(hex: "#E17B43")
    static let orange500 = Color(hex: "#723C1E")

    // MARK: - Beige

    static let beige50  = Color(hex: "#FFFAF3")
    static let beige100 = Color(hex: "#FFF9F0")
    static let beige200 = Color(hex: "#FFF1E7")
    static let beige300 = Color(hex: "#EDE0D5")
    static let beige400 = Color(hex: "#BCAEA3")

    // MARK: - Light

    static let lightGreen  = Color(hex: "#4EFF48")
    static let lightOrange = Color(hex: "#F57C00")

    // MARK: - Accent

    static let accentGreen  = Color(hex: "#59B755")
    static let accentYellow = Color(hex: "#FBC02D")
    static let accentRed    = Color(hex: "#D32F2F")
}

// MARK: - 내부 헬퍼

private extension Color {
    /// HEX 문자열로 Color를 생성합니다. `#RRGGBB` 형식을 지원합니다.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8)  & 0xFF) / 255
            b = Double(int         & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}
