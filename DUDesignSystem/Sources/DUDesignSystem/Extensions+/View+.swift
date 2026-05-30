//
//  View+.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

public extension View {
    func tokenShadow(_ shadow: TokenShadow.Shadow) -> some View {
        modifier(TokenShadowModifier(shadow: shadow))
    }
}
