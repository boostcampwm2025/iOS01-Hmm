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
        Text(text).duFont(.body2).foregroundStyle(Color.black300)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.all, TokenSpacing.md)
        .background(Color.white300)
        .overlay {
            RoundedRectangle(cornerRadius: TokenRadius.ss)
                .stroke(Color.gray700, lineWidth: 2)
        }
    }
}
