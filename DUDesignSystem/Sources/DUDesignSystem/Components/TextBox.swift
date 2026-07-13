//
//  TextBox.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/13/26.
//

import SwiftUI

public struct TextBox: View {
    public let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        ItemLabel(text: text, font: .body2, color: .black300)
        .frame(maxWidth: .infinity)
        .padding(.all, TokenSpacing.md)
        .background(Color.white300)
        .overlay {
            RoundedRectangle(cornerRadius: TokenRadius.ss)
                .stroke(Color.gray700, lineWidth: 2)
        }
        .padding(.all, TokenSpacing.lg) // 바깥 여백
    }
}
