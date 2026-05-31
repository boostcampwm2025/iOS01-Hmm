//
//  TokenRadius.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

/// Figma 디자인 시스템 "개발자 키우기"의 모서리 반경 토큰입니다.
public enum TokenRadius {
    /// `0pt` — 직각
    public static let none: CGFloat = 0
    /// `4pt`
    public static let xs:   CGFloat = 4
    /// `8pt`
    public static let sm:   CGFloat = 8
    /// `12pt`
    public static let md:   CGFloat = 12
    /// `16pt`
    public static let lg:   CGFloat = 16
    /// `24pt`
    public static let xl:   CGFloat = 24
    /// `999pt` — 완전한 원형
    public static let full: CGFloat = 999
}
