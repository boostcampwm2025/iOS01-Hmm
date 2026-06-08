//
//  Toast.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct Toast: View {

    public var message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        Text(message)
            .duFont(.body)
            .foregroundStyle(Color.white300)
            .frame(maxWidth: .infinity)
            .padding(.vertical, TokenSpacing.mm)
            .background(Color.black300.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            .tokenShadow(.dim)
            .padding(.horizontal, TokenSpacing.lg)
    }
}

#Preview {
    VStack(spacing: TokenSpacing.md) {
        Toast(message: "토스트 안내 메시지입니다.")
        Toast(message: "저장되었습니다.")
    }
    .background(Color.beige200)
}
