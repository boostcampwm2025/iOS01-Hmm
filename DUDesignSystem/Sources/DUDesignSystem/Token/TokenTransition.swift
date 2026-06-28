//
//  TokenTransition.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/28/26.
//

import SwiftUI

/// Figma 디자인 시스템 "개발자 키우기"의 모션-트랜지션 토큰입니다.
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
