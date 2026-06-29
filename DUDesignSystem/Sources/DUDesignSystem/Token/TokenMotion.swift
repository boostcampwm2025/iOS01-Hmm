//
//  TokenMotion.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/28/26.
//

import SwiftUI

/// Figma 디자인 시스템 "개발자 키우기"의 모션 토큰입니다.

// MARK: - Transition
@MainActor
public struct TokenTransition {
    public let effect: AnyTransition
    public let animation: Animation
    public let duration: Duration
}

extension TokenTransition {
    public static let overlay = TokenTransition(
        effect: .opacity,
        animation: .easeInOut(duration: 0.25),
        duration: .milliseconds(250)
    )
    public static let scale = TokenTransition(
        effect: .opacity.combined(with: .scale(scale: 0.95)),
        animation: .easeInOut(duration: 0.25),
        duration: .milliseconds(250)
    )
}

// MARK: - Animation
@MainActor
public struct TokenAnimation {
    public let animation: Animation
    public let duration: Duration

    public init(
        animation: Animation,
        duration: Duration
    ) {
        self.animation = animation
        self.duration = duration
    }
}

extension TokenAnimation {
    public static let fadeInSlow = TokenAnimation(
        animation: .easeOut(duration: 0.5),
        duration: .milliseconds(500)
    )

    public static let crossFade = TokenAnimation(
        animation: .easeInOut(duration: 0.25),
        duration: .milliseconds(250)
    )

    public static let floatingFadeOut = TokenAnimation(
        animation: .easeOut(duration: 1.0),
        duration: .seconds(1)
    )

    public static let offsetMove = TokenAnimation(
        animation: .easeOut(duration: 0.25),
        duration: .milliseconds(250)
    )

    public static let blinkLoop = TokenAnimation(
        animation: .easeInOut(duration: 1.0)
            .repeatForever(autoreverses: true),
        duration: .seconds(1)
    )

    public static let springMove = TokenAnimation(
        animation: .spring(duration: 0.3),
        duration: .milliseconds(300)
    )
}

// MARK: - FadeInSlowModifier
struct FadeInSlowModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .animation(TokenAnimation.fadeInSlow.animation, value: isVisible)
    }
}

// MARK: - FloatingFadeOutModifier
struct FloatingFadeOutModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isActive ? 1 : 0)
            .offset(y: isActive ? 0 : -12)
            .animation(
                TokenAnimation.floatingFadeOut.animation,
                value: isActive
            )
    }
}

// MARK: - BlinkLoopModifier
struct BlinkLoopModifier: ViewModifier {
    let isPlaying: Bool
    @State private var isBlinking = false

    func body(content: Content) -> some View {
        content
            .opacity(isBlinking ? 1.0 : 0.3)
            .onChange(of: isPlaying) { _, newValue in
                if newValue {
                    withAnimation(TokenAnimation.blinkLoop.animation) {
                        isBlinking = true
                    }
                } else {
                    withAnimation(.default) {
                        isBlinking = false
                    }
                }
            }
    }
}

public extension View {
    func fadeInSlow(isVisible: Bool) -> some View {
        modifier(FadeInSlowModifier(isVisible: isVisible))
    }

    func floatingFadeOut(isActive: Bool) -> some View {
        modifier(FloatingFadeOutModifier(isActive: isActive))
    }

    func blinkLoop(isPlaying: Bool) -> some View {
        modifier(BlinkLoopModifier(isPlaying: isPlaying))
    }
}
