//
//  TokenLine.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/3/26.
//

import SwiftUI

/// Figma 디자인 시스템 "개발자 키우기"의 라인(테두리) 토큰입니다.
public struct TokenLine: Sendable {
    public let color: Color
    public let width: CGFloat

    public static let `default` = TokenLine(color: .gray700, width: 2)
}

// MARK: - 뷰 모디파이어

public struct TokenLineBorderModifier: ViewModifier {
    let line: TokenLine
    let cornerRadius: CGFloat

    public func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(line.color, lineWidth: line.width)
        )
    }
}

// MARK: - View 확장

public extension View {

    func tokenLine(_ line: TokenLine, cornerRadius: CGFloat = 0) -> some View {
        modifier(TokenLineBorderModifier(line: line, cornerRadius: cornerRadius))
    }
}
