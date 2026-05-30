import SwiftUI

// MARK: - Spacing & Radius Tokens
// Figma Design System "개발자 키우기"

// MARK: - Spacing Tokens

public enum TokenSpacing {
    public static let none: CGFloat = 0
    public static let xx:   CGFloat = 2
    public static let xs:   CGFloat = 4
    public static let sm:   CGFloat = 8
    public static let mm:   CGFloat = 12
    public static let md:   CGFloat = 16
    public static let lg:   CGFloat = 24
    public static let xl:   CGFloat = 32
    public static let xxl:  CGFloat = 40
    public static let xxxl: CGFloat = 44
}

// MARK: - Radius Tokens

public enum TokenRadius {
    public static let none: CGFloat = 0
    public static let xs:   CGFloat = 4
    public static let sm:   CGFloat = 8
    public static let md:   CGFloat = 12
    public static let lg:   CGFloat = 16
    public static let xl:   CGFloat = 24
    /// 완전한 원형 (999)
    public static let full: CGFloat = 999
}

// MARK: - View Extension

public extension View {

    /// TokenSpacing 기반 padding
    func duPadding(_ edges: Edge.Set = .all, _ token: CGFloat) -> some View {
        self.padding(edges, token)
    }

    /// TokenRadius 기반 cornerRadius
    func duRadius(_ token: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: token))
    }
}