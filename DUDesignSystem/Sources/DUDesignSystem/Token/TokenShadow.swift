//
//  TokenShadow.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

public enum TokenShadow {
    public static let none: Shadow = .init(
        color: .clear, radius: 0, x: 0, y: 0
    )
    public static let small: Shadow = .init(
        color: Color.black.opacity(0.3), radius: 2, x: 1, y: 2
    )
    public static let medium: Shadow = .init(
        color: Color.black.opacity(0.5), radius: 2, x: 1, y: 2
    )
    public static let large: Shadow = .init(
        color: Color.black.opacity(1.0), radius: 2, x: 1, y: 2
    )
    public static let xLarge: Shadow = .init(
        color: Color.black.opacity(1.0), radius: 3, x: 3, y: 3
    )

    public struct Shadow: Sendable {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
    }
}

// MARK: - View Modifier for Shadow Token

public struct TokenShadowModifier: ViewModifier {
    let shadow: TokenShadow.Shadow

    public func body(content: Content) -> some View {
        content
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}
