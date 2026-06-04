//
//  TokenShadow.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

/// Figma 디자인 시스템 "개발자 키우기"의 그림자(Elevation) 토큰입니다.
public struct TokenShadow: Sendable {

    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public static let none      = TokenShadow(color: .clear,   radius: 0, x: 0, y: 0)
    public static let dim       = TokenShadow(color: .gray400,  radius: 0, x: 1, y: 2)
    public static let `default` = TokenShadow(color: .gray700, radius: 0, x: 1, y: 2)
}

// MARK: - 뷰 모디파이어

public struct TokenShadowModifier: ViewModifier {
    let shadow: TokenShadow

    public func body(content: Content) -> some View {
        content.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

public extension View {
    func tokenShadow(_ shadow: TokenShadow) -> some View {
        modifier(TokenShadowModifier(shadow: shadow))
    }
}
