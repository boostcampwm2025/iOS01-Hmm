//
//  TokenAnimation.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/28/26.
//

import SwiftUI

/// Figma 디자인 시스템 "개발자 키우기"의 모션-애니메이션 토큰입니다.
@MainActor
public struct TokenAnimation {
    public let animation: Animation
}

extension TokenAnimation {
    public static let fadeInPage     = TokenAnimation(animation: .easeOut(duration: 0.5))
    public static let crossFade      = TokenAnimation(animation: .easeInOut(duration: 0.25))
    public static let floatingFadeOut = TokenAnimation(animation: .easeOut(duration: 1.0))
    public static let offsetMove     = TokenAnimation(animation: .easeOut(duration: 0.25))
    public static let blinkLoop      = TokenAnimation(animation: .easeInOut(duration: 1.0).repeatForever(autoreverses: true))
    public static let springMove     = TokenAnimation(animation: .spring(duration: 0.3))
}

// MARK: - FloatingFadeOutModifier

struct FloatingFadeOutModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : -12)
            .animation(TokenAnimation.floatingFadeOut.animation, value: isVisible)
    }
}

extension View {
    func floatingFadeOut(isVisible: Bool) -> some View {
        modifier(FloatingFadeOutModifier(isVisible: isVisible))
    }
}
