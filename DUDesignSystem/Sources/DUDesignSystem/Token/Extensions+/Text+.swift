//
//  Text+.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI

public extension Text {

    /// `DUTypographyToken` 토큰을 적용합니다. `labelline`의 경우 밑줄이 자동으로 포함됩니다.
    func duTypography(_ token: DUTypographyToken) -> Text {
        token.isUnderlined
            ? self.font(token.font).underline()
            : self.font(token.font)
    }
}
