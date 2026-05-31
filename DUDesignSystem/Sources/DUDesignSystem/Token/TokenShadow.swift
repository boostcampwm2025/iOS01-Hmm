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

    /// 그림자 없음
    public static let none   = TokenShadow(color: .clear,                    radius: 0, x: 0, y: 0)
    /// 약한 그림자 — opacity 30%, radius 2
    public static let small  = TokenShadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 2)
    /// 중간 그림자 — opacity 50%, radius 2
    public static let medium = TokenShadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 2)
    /// 강한 그림자 — opacity 100%, radius 2
    public static let large  = TokenShadow(color: .black.opacity(1.0), radius: 2, x: 1, y: 2)
    /// 매우 강한 그림자 — opacity 100%, radius 3
    public static let xLarge = TokenShadow(color: .black.opacity(1.0), radius: 3, x: 3, y: 3)
}

// MARK: - 뷰 모디파이어

/// `TokenShadow` 토큰을 SwiftUI `.shadow()` 모디파이어로 적용합니다.
public struct TokenShadowModifier: ViewModifier {
    let shadow: TokenShadow

    public func body(content: Content) -> some View {
        content.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

// MARK: - View 확장

public extension View {

    /// `TokenShadow` 토큰으로 그림자를 적용합니다.
    func tokenShadow(_ shadow: TokenShadow) -> some View {
        modifier(TokenShadowModifier(shadow: shadow))
    }
}
