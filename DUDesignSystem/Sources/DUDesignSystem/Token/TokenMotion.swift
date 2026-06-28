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
}

extension TokenTransition {
    public static let overlay = TokenTransition(effect: .opacity)
    public static let scale = TokenTransition(
        effect: .opacity.combined(with: .scale(scale: 0.95))
    )
}

// MARK: - Animation
@MainActor
public struct TokenAnimation {
    public let animation: Animation
}

extension TokenAnimation {
    public static let fadeInSlow     = TokenAnimation(animation: .easeOut(duration: 0.5))
    public static let crossFade      = TokenAnimation(animation: .easeInOut(duration: 0.25))
    public static let floatingFadeOut = TokenAnimation(animation: .easeOut(duration: 1.0))
    public static let offsetMove     = TokenAnimation(animation: .easeOut(duration: 0.25))
    public static let blinkLoop      = TokenAnimation(animation: .easeInOut(duration: 1.0).repeatForever(autoreverses: true))
    public static let springMove     = TokenAnimation(animation: .spring(duration: 0.3))
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

// MARK: - CrossFadeModifier

struct CrossFadeModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .animation(TokenAnimation.crossFade.animation, value: isVisible)
    }
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

// MARK: - OffsetMoveModifier
struct OffsetMoveModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .animation(TokenAnimation.offsetMove.animation, value: isVisible)
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

    func crossFade(isVisible: Bool) -> some View {
        modifier(CrossFadeModifier(isVisible: isVisible))
    }

    func floatingFadeOut(isVisible: Bool) -> some View {
        modifier(FloatingFadeOutModifier(isVisible: isVisible))
    }

    func offsetMove(isVisible: Bool) -> some View {
        modifier(OffsetMoveModifier(isVisible: isVisible))
    }

    func blinkLoop(isPlaying: Bool) -> some View {
        modifier(BlinkLoopModifier(isPlaying: isPlaying))
    }
}
