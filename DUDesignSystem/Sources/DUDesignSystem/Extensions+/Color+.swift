//
//  Color+.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

public extension Color {

    // MARK: White
    static let white200 = Color(hex: "#FFFFFF")
    static let white300 = Color(hex: "#FFFFFF")

    // MARK: Black
    static let black100 = Color(hex: "#000000").opacity(0.2)
    static let black300 = Color(hex: "#000000")

    // MARK: Gray
    static let gray100 = Color(hex: "#D9D9D9")
    static let gray200 = Color(hex: "#B4B4B4")
    static let gray300 = Color(hex: "#8E8E8E")
    static let gray400 = Color(hex: "#6A6A6A")
    static let gray500 = Color(hex: "#484848")
    static let gray600 = Color(hex: "#282828")
    static let gray700 = Color(hex: "#111111")

    // MARK: Orange
    static let orange100 = Color(hex: "#F9D8CF")
    static let orange200 = Color(hex: "#F3A487")  // F3a487 → 대소문자 통일
    static let orange300 = Color(hex: "#E17B43")
    static let orange400 = Color(hex: "#A45930")
    static let orange500 = Color(hex: "#723C1E")
    static let orange600 = Color(hex: "#44210E")
    static let orange700 = Color(hex: "#1F0C04")

    // MARK: Beige
    static let beige50  = Color(hex: "#FFF9F0")
    static let beige100 = Color(hex: "#FFF9F0")
    static let beige200 = Color(hex: "#F4EDE3")
    static let beige300 = Color(hex: "#EEE1D5")
    static let beige400 = Color(hex: "#BCAEA3")

    // MARK: Light
    static let lightGreen  = Color(hex: "#4EFF4B")
    static let lightOrange = Color(hex: "#F57C00")

    // MARK: Accent
    static let accentGreen  = Color(hex: "#598755")
    static let accentYellow = Color(hex: "#FBC02D")
    static let accentRed    = Color(hex: "#D32F2F")

    // MARK: Pastel
    static let pastelYellow = Color(hex: "#FADF9A")
    static let pastelPink   = Color(hex: "#F69AFA")
    static let pastelBlue   = Color(hex: "#C7CFF8")
    static let pastelGreen  = Color(hex: "#B0F8BC")
}

private extension Color {
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
